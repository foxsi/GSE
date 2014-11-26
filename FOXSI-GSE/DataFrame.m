//
//  DataFrame.m
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/20/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import "DataFrame.h"

@interface DataFrame()
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
