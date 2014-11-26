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
@synthesize commnand_count = _commnand_count;
@synthesize command_value = _command_value;
@synthesize data = _data;

-(id)init: (unsigned short int)i {
    self = [super init]; // call our super’s designated initializer
    if (self) {
        self.type = 0;
    }
    return self;
}

@end
