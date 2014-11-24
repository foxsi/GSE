//
//  NumberInRangeFormatter.h
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/23/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberInRangeFormatter : NSFormatter

@property (nonatomic) float minimum;
@property (nonatomic) float maximum;

@end
