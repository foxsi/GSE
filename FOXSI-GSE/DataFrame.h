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
@property (strong) NSNumber *commnand_count;
@property (strong) NSNumber *command_value;
@property (strong) NSNumber *high_voltage;
@property (strong) NSNumber *high_voltage_status;
@property (strong) NSArray *data;
@property int type;

@end
