//
//  DataHousekeeping.m
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/24/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import "DataHousekeeping.h"

#define NUMBER_OF_TEMPERATURE_SENSORS 12
#define NUMBER_OF_VOLTAGE_MONITORS 4

@interface DataHousekeeping()
float temperature_convert_ref(unsigned short int value);
float temperature_convert_ysi44031(unsigned short int  value);
float voltage_convert_5v(unsigned short int value);
float voltage_convert_m5v(unsigned short int  value);
float voltage_convert_33v(unsigned short int  value);
float voltage_convert_15v(unsigned short int value);
@end

@implementation DataHousekeeping

@synthesize voltages;
@synthesize temperatures;

-(id)init {
    self = [super init]; // call our super’s designated initializer
    if (self) {
        self.temperatures = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_TEMPERATURE_SENSORS];
        self.voltages = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_VOLTAGE_MONITORS];
        //        if (i == 0) {
        //            self.housekeeping_type = [NSArray arrayWithObjects:@"Tempref",
        //                                      @"1.5V", @"actel", @"det4",
        //                                      nil];
        //        }
        //        if (i == 1) {
        //            self.housekeeping_type = [NSArray arrayWithObjects:@"5V",
        //                                      @"powerboard", @"actelboard", @"det1",
        //                                      nil];
        //        }
        //        if (i == 2) {
        //            self.housekeeping_type = [NSArray arrayWithObjects:@"m5V",
        //                                      @"", @"actelboard", @"det4",
        //                                      nil];
        //        }
        //        if (i == 3) {
        //            self.housekeeping_type = [NSArray arrayWithObjects:@"Temp ref",
        //                                      @"1.5V", @"actelboard", @"det4",
        //                                      nil];
        //        }
    }
    return self;
}

-(void) addTemperature: (unsigned short int)temp atIndex: (unsigned short int)i{
    float temperature;
    if (i == 0) {
        temperature = temperature_convert_ref(temp);
    } else {
        temperature = temperature_convert_ysi44031(temp);
    }

    [self.temperatures insertObject:[NSNumber numberWithFloat:temperature] atIndex:i];
}

-(void) addVoltage: (unsigned short int)v atIndex: (unsigned short int)i{
    float voltage = 0.0;
    // should use case below
    switch (i) {
        case 0:
            voltage = voltage_convert_5v(v);
            break;
        case 1:
            voltage = voltage_convert_m5v(v);
            break;
        case 2:
            voltage = voltage_convert_15v(v);
            break;
        case 3:
            voltage = voltage_convert_33v(v);
            break;
        default:
            break;
    }
    
    [self.voltages insertObject:[NSNumber numberWithFloat:voltage] atIndex:i];
}

float temperature_convert_ref(unsigned short int value)
{
    return (float)value*0.30517 - 255;
}

float voltage_convert_5v(unsigned short int value)
{
    return 8.75 * ( (float)value /4095.);
}

float voltage_convert_m5v(unsigned short int  value)
{
    return 2.5 - 15.0 * ( (float)value / 4095.);
}

float voltage_convert_33v(unsigned short int  value)
{
    return 5. * ( (float)value / 4095.);
}

float voltage_convert_15v(unsigned short int value)
{
    return 2.5 * ( (float)value / 4095.);
}

float temperature_convert_ysi44031(unsigned short int  value)
{
    // Take the reading of A/D Voltage from the YSI 44031 temperature
    // sensor and convert to a temperature (in Celsius).
    
    // Test input 1
    // int value = 0x0FF4;
    // answer should be -80.0
    
    // Test input 2
    // int value = 0x070D;
    // answer should be 31.0
    
    /* double resistance;
     double temperature;
     double frac;
     double voltage;
     
     const float c1 = 0.00099542549430017;
     const float c2 = 0.000234788987236607;
     const float c3 = 1.13519068800246E-07;
     
     frac = value/4095.0;
     voltage = 2.5*frac;
     resistance = 10000.0 * frac/ ( 1.0 - frac );
     //printf("%f\n",resistance);
     temperature = 1 / (c1 + c2 * log(resistance) + c3 * (pow(log(resistance),3))) - 273.15 - 9.73;
     //printf("%f\n", temperature);
     */
    
    float th, temperature;
    th = (float)value;
    th = 10000./((4095./th) -1.);
    temperature = -273. + 1./(0.00102522746225986 + 0.000239789531411299*log(th) + 1.53998393755544E-07*pow(log(th),3));
    return temperature;
}

@end
