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
#define MAX_CHANNEL 1024
#define MAX_TIME 1024

@interface Detector : NSObject{
    unsigned long image[XSTRIPS*YSTRIPS];
    unsigned long spectrum[MAX_CHANNEL];
    unsigned long lightcurve[MAX_TIME];
}


@property (nonatomic, strong) NSString *name;
@property (nonatomic) int xpixels;
@property (nonatomic) int ypixels;
@property (nonatomic) unsigned long imageMaximum;

-(void) addCount: (int)x :(int)y :(int)channel;
-(void) flushImage;
-(void) flushSpectrum;
-(void) flushLightcurve;
-(void) flushAll;
-(unsigned long  *) image;
-(unsigned long  *) spectrum;
-(unsigned long  *) lightcurve;


@end
