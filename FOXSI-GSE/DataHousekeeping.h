//
//  DataHousekeeping.h
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/24/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHousekeeping : NSObject

@property (strong) NSMutableArray *voltages;
@property (strong) NSMutableArray *temperatures;

-(void) addTemperature: (unsigned short int)temp atIndex: (unsigned short int)i;
-(void) addVoltage: (unsigned short int)v atIndex: (unsigned short int)i;

@end
