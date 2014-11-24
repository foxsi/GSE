//
//  ReadDataOp.m
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/19/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import "ReadDataOp.h"
#import "DataFrame.h"

#define FRAME_SIZE_IN_SHORTINTS 1024
#define FRAME_SIZE_IN_BYTES 2048
#define NUMBER_OF_TEMPERATURE_SENSORS 12
#define NUMBER_OF_VOLTAGE_MONITORS 4

@implementation ReadDataOp

- (void)main {
    // a lengthy operation
    @autoreleasepool {
        long len;
        bool good_read = false;
        FILE *formatterFile;
        unsigned short int buffer[FRAME_SIZE_IN_SHORTINTS];
        uint32_t frameNumber = 0;
        formatterFile = fopen("/Users/schriste/Desktop/FOXSI-2014/detector/data_launch_121102_114631.dat", "r");

        while (true) {
            len = fread((unsigned char *) buffer, 2048, 1, formatterFile);
            // skip 10 frames
            fseek(formatterFile, 204800/4, SEEK_CUR);
            if (len == 1){
                good_read = true;
            }
            // is this operation cancelled?
            if (self.isCancelled){
                NSLog(@"Stopping");
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"StoppedReadingData"
                 object:nil];
                break;
            }
            
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
                        // pass off for parsing to dataframe object
                        
                        
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
                        
                        unsigned short int frame_type;
                        unsigned short int temperature_monitors[NUMBER_OF_TEMPERATURE_SENSORS] = {0};
                        // order is 5V, -5V, 1.5V, -3.3V
                        unsigned short int voltage_monitors[NUMBER_OF_VOLTAGE_MONITORS] = {0};
                        
                        DataFrame *thisFrame = [[DataFrame alloc] init];

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
                        
                        frame_type = buffer[index+1] & 0x3;
                        
                        thisFrame.type = frame_type;
                        
                        index++;
                        index++;
                        
                        // Housekeeping 0
                        switch (frame_type) {
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
                        switch (frame_type) {
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
                        
                        // Housekeeping 2
                        //printf("%i, housekeeping 2: %x\n", index, buffer[index]);
                        switch (frame_type) {
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
                        
                        //printf("Status 0: %x\n", buffer[index++]);
                        index++;
                        index++;
                        index++;
                        //printf("Status 1: %x\n", buffer[index++]);
                        //printf("Status 2: %x\n", buffer[index++]);

                        switch (frame_type) {
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

                        index += 254-index ;
                        
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
                [thisFrame addTemperature:temperature_monitors[temp_sensor_num] atIndex:temp_sensor_num];
            }
            
            for (int volt_monitor_number = 0; volt_monitor_number < NUMBER_OF_VOLTAGE_MONITORS; volt_monitor_number++) {
                [thisFrame addVoltage:voltage_monitors[volt_monitor_number] atIndex:volt_monitor_number];
            }
        }
    }
}
@end
