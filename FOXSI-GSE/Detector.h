//
//  Detector.h
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/24/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XSTRIPS 128
#define YSTRIPS 128

@interface Detector : NSObject{
    unsigned long image[XSTRIPS][YSTRIPS];
}


@property (nonatomic, strong) NSString *name;
@property (nonatomic) int xpixels;
@property (nonatomic) int ypixels;
@property (nonatomic) unsigned long imageMaximum;

-(void) addCount: (int)x :(int)y :(int)channel;

@end
