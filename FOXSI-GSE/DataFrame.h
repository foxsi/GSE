//
//  DataFrame.h
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/20/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFrame : NSObject

@property (strong) NSNumber *number;
@property (strong) NSNumber *time;
@property (strong) NSMutableArray *voltages;
@property (strong) NSMutableArray *temperatures;
@property (strong) NSNumber *commnand_count;
@property (strong) NSNumber *command_value;
@property (strong) NSNumber *high_voltage;

-(void) addTemperature: (unsigned short int)temp atIndex: (unsigned short int)i;
-(void) addVoltage: (unsigned short int)v atIndex: (unsigned short int)i;
@end
