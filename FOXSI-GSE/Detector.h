//
//  Detector.h
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/24/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Detector : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) int xpixels;
@property (nonatomic) int ypixels;
@property (nonatomic) unsigned long imageMaximum;
@property (strong) NSMutableData *image;
@property (strong) NSMutableData *spectrum;
@property (strong) NSMutableData *lightCurve;
@property (strong) NSMutableData *imageTime;

-(void) addCount: (int)x :(int)y :(int)channel;
-(void) flushImage;
-(void) flushSpectrum;
-(void) flushLightcurve;
-(void) flushAll;

@end
