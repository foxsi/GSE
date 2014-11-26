//
//  ReadDataOp.m
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/19/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import "ReadDataOp.h"
#import "DataFrame.h"
#import "DataHousekeeping.h"
#include "utilities.h"

#define FRAME_SIZE_IN_SHORTINTS 1024
#define FRAME_SIZE_IN_BYTES 2048
#define NUMBER_OF_TEMPERATURE_SENSORS 12
#define NUMBER_OF_VOLTAGE_MONITORS 4
#define NUM_DETECTORS 7

@implementation ReadDataOp

- (void)main {
    // a lengthy operation
    @autoreleasepool {
        long len;
        bool good_read = false;
        long lSize;
        FILE *formatterFile;
        unsigned short int buffer[FRAME_SIZE_IN_SHORTINTS];
        uint32_t frameNumber = 0;
        formatterFile = fopen("/Users/schriste/Desktop/FOXSI-2014/detector/data_launch_121102_114631.dat", "r");
        
        // obtain file size:
        fseek (formatterFile , 0 , SEEK_END);
        lSize = ftell (formatterFile);
        rewind(formatterFile);
        
        DataHousekeeping *thisHousekeeping = [[DataHousekeeping alloc] init];
        DataFrame *thisFrame = [[DataFrame alloc] init];
        
        while (true) {
            len = fread((unsigned char *) buffer, 2048, 1, formatterFile);
            
            // skip 10 frames
            // fseek(formatterFile, 204800/4, SEEK_CUR)
            
            if (len == 1){
                good_read = true;
            }
            // is this operation cancelled?
            if (self.isCancelled || ftell(formatterFile) >= lSize){
                fclose(formatterFile);
                NSLog(@"Stopping");
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"StoppedReadingData"
                 object:nil];
                break;
            }
            
            unsigned short int temperature_monitors[NUMBER_OF_TEMPERATURE_SENSORS] = {0};
            // order is 5V, -5V, 1.5V, -3.3V
            unsigned short int voltage_monitors[NUMBER_OF_VOLTAGE_MONITORS] = {0};
            
            int index = 0;
            for( int frame_num = 0, index = 0; frame_num < 4; frame_num++)
            {
                good_read = false;
                //printf("f628: %x\n", buffer[index++]);
                if (buffer[index] == 0xf628) {
                    good_read = true;
                    // check the checksum
                    for( int word_number = 0; word_number < 256; word_number++ ){good_read ^= buffer[word_number];}
                    
                    if( good_read == true ){
                        long long time;
                        unsigned short int command_count;
                        uint32_t command_value;
                        unsigned short int tmp;
                        unsigned short int high_voltage_status;
                        unsigned short int high_voltage;
                        unsigned short int strip_data;
                        unsigned short int strip_number;
                        unsigned short int formatter_status;
                        bool attenuator_actuating = 0;
                        
                        index++;
                        time = (((unsigned long long) buffer[index] << 32) & 0xFFFF00000000);
                        index++;
                        time |= ((unsigned long long) (buffer[index] << 16) & 0xFFFF0000);
                        index++;
                        time |= (unsigned long long) buffer[index];
                        time /= 10e6;
                        
                        thisFrame.time = [NSNumber numberWithLongLong:time];
                        
                        index++;
                        //index++;
                        frameNumber = ((uint32_t)(buffer[index] << 16) & 0xFFFF0000) | buffer[index+1];
                        thisFrame.number = [NSNumber numberWithLong:frameNumber];
                        thisFrame.type = buffer[index+1] & 0x3;
                        
                        index++;
                        index++;
                        
                        // Housekeeping 0
                        switch (thisFrame.type) {
                            case 0:
                                // temperature reference
                                temperature_monitors[0] = buffer[index++];
                                break;
                            case 1:
                                //1.5 V monitor
                                voltage_monitors[2] = buffer[index++];
                                break;
                            case 2:
                                temperature_monitors[4] = buffer[index++];
                                break;
                            case 3:
                                temperature_monitors[8] = buffer[index++];
                                break;
                            default:
                                //printf("housekeeping 0: %u\n", buffer[index++]);
                                index++;
                                break;
                        }
                        
                        command_count = buffer[index];
                        thisFrame.commnand_count = [NSNumber numberWithInt:command_count];
                        //printf("cmd count: %x\n", buffer[index++]);
                        index++;
                        command_value = ((uint32_t)(buffer[index] << 16) & 0xFFFF0000) | buffer[index+1];
                        thisFrame.command_value = [NSNumber numberWithInt:command_value];
                        index++;
                        index++;
                        
                        // Housekeeping 1
                        //printf("%i, housekeeping 1: %x\n", index, buffer[index]);
                        switch (thisFrame.type) {
                            case 0:
                                // 5 V monitor
                                voltage_monitors[0] = buffer[index++];
                                break;
                            case 1:
                                temperature_monitors[1] = buffer[index++];
                                break;
                            case 2:
                                temperature_monitors[5] = buffer[index++];
                                break;
                            case 3:
                                temperature_monitors[9] = buffer[index++];
                                break;
                            default:
                                //printf("Housekeeping 1: %u\n", buffer[index++]);
                                index++;
                                break;
                        }
                        formatter_status = buffer[index++]; // printf("FormatterStatus: %u\n", buffer[index++]);
                        
                        //if (getbits(formatter_status, 2, 1)) {
                        //    attenuator_actuating = 1;
                        //}
                        index++;
                        
                        //printf("HV index %i\n", index);
                        high_voltage_status = buffer[index] & 0xF;
                        high_voltage = ((buffer[index] >> 4) & 0xFFF)/8.0;
                        index++;
                        thisFrame.high_voltage = [NSNumber numberWithInt:high_voltage];
                        thisFrame.high_voltage_status = [NSNumber numberWithInt:high_voltage_status];
                        
                        // Housekeeping 2
                        //printf("%i, housekeeping 2: %x\n", index, buffer[index]);
                        switch (thisFrame.type) {
                            case 0:
                                // -5 V monitor
                                voltage_monitors[1] = buffer[index++];
                                break;
                            case 1:
                                temperature_monitors[2] = buffer[index++];
                                break;
                            case 2:
                                temperature_monitors[6] = buffer[index++];
                                break;
                            case 3:
                                temperature_monitors[10] = buffer[index++];
                                break;
                            default:
                                //printf("Housekeeping 2: %u\n", buffer[index++]);
                                index++;
                                break;
                        }
                        
                        // Status 0
                        index++;
                        // Status 1
                        index++;
                        // Status 2
                        index++;
                        
                        switch (thisFrame.type) {
                            case 0:
                                // 3.3 V monitor
                                voltage_monitors[3] = buffer[index++];
                                break;
                            case 1:
                                temperature_monitors[3] = buffer[index++];
                                break;
                            case 2:
                                temperature_monitors[7] = buffer[index++];
                                break;
                            case 3:
                                temperature_monitors[11] = buffer[index++];
                                break;
                            default:
                                //printf("Housekeeping 3: %u\n", buffer[index++]);
                                index++;
                                break;
                        }
                        
                        //printf("Status 3: %x\n", buffer[index]);
                        index++;
                        //printf("Status 4: %x\n", buffer[index]);
                        index++;
                        //printf("Status 5: %x\n", buffer[index]);
                        index++;
                        //printf("Status 6: %x\n", buffer[index]);
                        index++;
                        
                        //NSLog(@"index = %i", index);
                        
                        for(int detector_num = 0; detector_num < NUM_DETECTORS; detector_num++){
                            unsigned short int common_mode = 0;
                            
                            unsigned short int ymask[128] = {0};
                            unsigned short int xmask[128] = {0};
                            // xstrips are defined as p strips
                            unsigned short int xstrips[128] = {0};
                            // ystrips are defined as n strips
                            unsigned short int ystrips[128] = {0};
                            //printf("Detector %u time, index %i: %u\n", detector_num, buffer[index], index);
                            
                            unsigned short int detector_time = 0;
                            detector_time = buffer[index];
                            
                            // check to see if detector data exists
                            bool detector_data_exists;
                            detector_data_exists = !((buffer[index] == buffer[index+1]) && (buffer[index+2] == buffer[index+3]) && (buffer[index+4] == buffer[index+5]) && (buffer[index+6] && buffer[index+7]));
                            
                            unsigned short int max_pdata, max_ndata, max_pstrip_number, max_nstrip_number;
                            max_ndata = 0;
                            max_pdata = 0;
                            max_pstrip_number = 0;
                            max_nstrip_number = 0;
                            
                            if ( detector_data_exists ) {
                                
                                for(int asic_number = 0; asic_number < 4; asic_number++)
                                {
                                    index++;
                                    // 0ASIC0 mask0
                                    tmp = buffer[index];
                                    
                                    for(int position = 0; position < 16; position++){
                                        if (asic_number == 0) {xmask[position] = getbits(tmp, position, 1);}
                                        if (asic_number == 1) {xmask[position+64] = getbits(tmp, position, 1);}
                                        if (asic_number == 2) {ymask[position] = getbits(tmp, position, 1);}
                                        if (asic_number == 3) {ymask[position+64] = getbits(tmp, position, 1);}
                                    }
                                    // 0ASIC0 mask1
                                    index++;
                                    tmp = buffer[index];
                                    
                                    for(int position = 0; position < 16; position++){
                                        if (asic_number == 0) {xmask[position+16] = getbits(tmp, position, 1);}
                                        if (asic_number == 1) {xmask[position+64+16] = getbits(tmp, position, 1);}
                                        if (asic_number == 2) {ymask[position+16] = getbits(tmp, position, 1);}
                                        if (asic_number == 3) {ymask[position+64+16] = getbits(tmp, position, 1);}
                                    }
                                    // 0ASIC0 mask2tmp = buffer[index++];
                                    index++;
                                    tmp = buffer[index];
                                    
                                    for(int position = 0; position < 16; position++){
                                        if (asic_number == 0) {xmask[position+32] = getbits(tmp, position, 1);}
                                        if (asic_number == 1) {xmask[position+64+32] = getbits(tmp, position, 1);}
                                        if (asic_number == 2) {ymask[position+32] = getbits(tmp, position, 1);}
                                        if (asic_number == 3) {ymask[position+64+32] = getbits(tmp, position, 1);}
                                    }
                                    // 0ASIC0 mask3
                                    index++;
                                    tmp = buffer[index];
                                    for(int position = 0; position < 16; position++){
                                        if (asic_number == 0) {xmask[position+48] = getbits(tmp, position, 1);}
                                        if (asic_number == 1) {xmask[position+64+48] = getbits(tmp, position, 1);}
                                        if (asic_number == 2) {ymask[position+48] = getbits(tmp, position, 1);}
                                        if (asic_number == 3) {ymask[position+64+48] = getbits(tmp, position, 1);}
                                    }
                                    
                                    // 3 strips are read out, middle strip should be biggest one,
                                    // data layout for strips is
                                    // 6 bits - strip number
                                    // 12 bits - strip data
                                    // 4th strip is the common mode and takes up entire 16 bits
                                    unsigned short int strip_data = 0;
                                    unsigned short int h[4] = {buffer[index+1], buffer[index+2], buffer[index+3], buffer[index+4]};
                                    for(int strip_num = 0; strip_num < 4; strip_num++)
                                    {
                                        index++;
                                        
                                        //printf("strip number%u\n", strip_number);
                                        
                                        if ((buffer[index] != 0xFFFF) && (buffer[index] != 0)){
                                            // only keep the middle strip which is the max
                                            if (strip_num == 1) {
                                                strip_data = buffer[index] & 0x3FF;
                                                strip_number = (buffer[index] >> 10) & 0x3F;
                                                
                                                // n side asic
                                                //if (asic_number == 0) {ystrips[strip_number] = strip_data[strip_num];}
                                                //if (asic_number == 1) {ystrips[strip_number + 63] = strip_data[strip_num];}
                                                // p side asic
                                                //if (asic_number == 2) {xstrips[63 - strip_number] = strip_data[strip_num];}
                                                //if (asic_number == 3) {xstrips[127 - strip_number] = strip_data[strip_num];}
                                                
                                                if ((asic_number == 2) || (asic_number == 3)) {
                                                    if (max_pdata < strip_data) {
                                                        max_pdata = strip_data;
                                                        if (asic_number == 2) {max_nstrip_number = 63 - strip_number;}
                                                        if (asic_number == 3) {max_nstrip_number = 127 - strip_number;}
                                                    }
                                                }
                                                if ((asic_number == 0) || (asic_number == 1)) {
                                                    if (max_ndata < strip_data) {
                                                        max_ndata = strip_data;
                                                        if (asic_number == 0) {max_pstrip_number = strip_number;}
                                                        if (asic_number == 1) {max_pstrip_number = strip_number+63;}
                                                    }
                                                }
                                                
                                                
                                            }
                                            
                                            if (strip_num == 3) {common_mode = buffer[index];}
                                            //if (asic_number == 2) {common_mode[0] = buffer[index];}
                                            //if (asic_number == 3) {common_mode[1] = buffer[index];}
                                            
                                            //printf("common mode: %u\n", common_mode);
                                        }
                                    }
                                }
                                
                                thisFrame.data = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:max_pstrip_number],
                                                  [NSNumber numberWithInt:max_nstrip_number],
                                                  [NSNumber numberWithInt:detector_num],
                                                  [NSNumber numberWithInt:max_pdata],
                                                  [NSNumber numberWithInt:common_mode],
                                                  nil];
                                
                                // now add it to the image
                                //if (max_pdata > gui->mainHistogramWindow->get_lowthreshold()) {
                                //    gui->detectorsImageWindow->add_count_to_image(max_pstrip_number, max_nstrip_number, detector_num);
                                //    gui->mainLightcurveWindow->add_count(detector_num);
                                //    if (gui->minus_common_mode_checkbox->value() == 1) {
                                //        gui->mainHistogramWindow->add_count(max_pdata - common_mode, detector_num);}
                                //    else {
                                //        gui->mainHistogramWindow->add_count(max_pdata, detector_num);
                                //    }
                                
                                
                                index++;
                            } else {
                                //printf("No detector %d data found\n", detector_num);
                                //gui->app->no_trigger_count++;
                                index+=33;
                            }
                            //printf("Detector %u:\n", detector_num);
                        }
                        
                        //index++;
                        //printf("checksum: %x\n", buffer[index]);
                        //printf("index = %d, value = %x\n", index, buffer[index]);
                        index++;
                        //printf("index = %d, sync: %x\n", index, buffer[index]);
                        index++;
                        
                        //Fl::lock();
                        //gui->CommandCntOutput->value(command_count);
                        //char text_buffer[50];
                        //sprintf(text_buffer, "%x", command_value);
                        //gui->CommandOutput->value(text_buffer);
                        
                        //gui->frameTime->value(time);
                        //gui->int_timeOutput->value(time - (gui->app->formatter_start_time));
                        
                        //gui->HVOutput->value(high_voltage);
                        //printf("voltage: %i status: %i", voltage, HVvoltage_status);
                        //if (high_voltage_status == 1) {gui->HVOutput->textcolor(FL_RED);}
                        //if (high_voltage_status == 2) {gui->HVOutput->textcolor(FL_BLUE);}
                        //if (high_voltage_status == 4) {gui->HVOutput->textcolor(FL_BLACK); gui->HVOutput->redraw();}
                        //gui->nEventsDone->value(gui->app->frame_display_count);
                        //gui->framenumOutput->value(frameNumber);
                        //if (attenuator_actuating == 1) {gui->shutterstateOutput->value(1);}
                        //Fl::unlock();
                        //index += 254-index ;
                        
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"DataReady"
                         object:thisFrame];
                    }
                    else {
                        NSLog(@"Bad read");
                        // bad checksum, skip this frame and go to the next
                        index+=256;
                    }
                }
            }
            
            for(int temp_sensor_num = 0; temp_sensor_num < NUMBER_OF_TEMPERATURE_SENSORS; temp_sensor_num++)
            {
                [thisHousekeeping addTemperature:temperature_monitors[temp_sensor_num] atIndex:temp_sensor_num];
            }
            
            for (int volt_monitor_number = 0; volt_monitor_number < NUMBER_OF_VOLTAGE_MONITORS; volt_monitor_number++) {
                [thisHousekeeping addVoltage:voltage_monitors[volt_monitor_number] atIndex:volt_monitor_number];
            }
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"HousekeepingReady"
             object:thisHousekeeping];
        }
    }
}
@end
