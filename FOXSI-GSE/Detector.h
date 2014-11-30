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
@property (nonatomic) NSUInteger xpixels;
@property (nonatomic) NSUInteger ypixels;
@property (nonatomic) NSUInteger imageMaximum;
@property (nonatomic) NSUInteger spectrumMaximum;
@property (strong) NSMutableData *image;
@property (strong) NSMutableData *spectrum;
@property (strong) NSMutableData *lightCurve;
@property (strong) NSMutableData *imageTime;
@property (nonatomic) NSUInteger maxChannel;

-(void) addCount: (int)x :(int)y :(int)channel;
-(void) flushImage;
-(void) flushSpectrum;
-(void) flushLightcurve;
-(void) flushAll;

@end
