//
//  DataFrame.m
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/20/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import "DataFrame.h"

@interface DataFrame()
float temperature_convert_ref(unsigned short int value);
float temperature_convert_ysi44031(unsigned short int  value);
float voltage_convert_5v(unsigned short int value);
float voltage_convert_m5v(unsigned short int  value);
float voltage_convert_33v(unsigned short int  value);
float voltage_convert_15v(unsigned short int value);
@end

@implementation DataFrame

@synthesize number = _number;
@synthesize time = _time;
@synthesize voltages = _voltages;
@synthesize temperatures = _temperatures;
@synthesize commnand_count = _commnand_count;
@synthesize command_value = _command_value;
@synthesize housekeeping = _housekeeping;

-(id)init: (unsigned short int)i {
    self = [super init]; // call our super’s designated initializer
    if (self) {
        self.type = 0;
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

-(void) addHousekeeping: (unsigned short int)value atIndex: (unsigned short int)i {
    float housekeeping[4] = {0};

    switch (self.type) {
        case 0:
            housekeeping[0] = temperature_convert_ref(value);
            housekeeping[1] = voltage_convert_15v(value);
            housekeeping[2] = temperature_convert_ysi44031(value);
            housekeeping[3] = temperature_convert_ysi44031(value);
            break;
        case 1:
            housekeeping[0] = voltage_convert_5v(value);
            housekeeping[1] = temperature_convert_ysi44031(value);
            housekeeping[2] = temperature_convert_ysi44031(value);
            housekeeping[3] = temperature_convert_ysi44031(value);
            break;
        case 2:
            housekeeping[0] = voltage_convert_m5v(value);
            housekeeping[1] = temperature_convert_ysi44031(value);
            housekeeping[2] = temperature_convert_ysi44031(value);
            housekeeping[3] = temperature_convert_ysi44031(value);
            break;
        case 3:
            housekeeping[0] = voltage_convert_33v(value);
            housekeeping[1] = temperature_convert_ysi44031(value);
            housekeeping[2] = temperature_convert_ysi44031(value);
            housekeeping[3] = temperature_convert_ysi44031(value);
            break;
        default:
            break;
    }
    self.housekeeping = [NSArray arrayWithObjects:[NSNumber numberWithFloat:housekeeping[0]],
                         [NSNumber numberWithFloat:housekeeping[1]],
                         [NSNumber numberWithFloat:housekeeping[2]],
                         [NSNumber numberWithFloat:housekeeping[3]]
                         , nil];
}

@end
