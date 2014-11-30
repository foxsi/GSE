//
//  Detector.m
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/24/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import "Detector.h"

#define XSTRIPS 128
#define YSTRIPS 128
#define MAX_CHANNEL 1024
#define MAX_TIME 1024

@implementation Detector

@synthesize image = _image;

-(id)init{
    self = [super init]; // call our super’s designated initializer
    if (self) {
        // insert initializing here
        self.xpixels = XSTRIPS;
        self.ypixels = YSTRIPS;
        self.imageMaximum = 0;
        self.spectrumMaximum = 0;
        self.maxChannel = MAX_CHANNEL;
        UInt8 tmp[XSTRIPS*YSTRIPS] = {0};
        self.image = [[NSMutableData alloc] initWithBytes:tmp length:XSTRIPS*YSTRIPS];
        NSTimeInterval times[XSTRIPS*YSTRIPS] = {[NSDate timeIntervalSinceReferenceDate]};
        self.imageTime = [[NSMutableData alloc] initWithBytes:times length:XSTRIPS*YSTRIPS*sizeof(NSTimeInterval)];
        NSUInteger tmp2[MAX_CHANNEL] = {0};
        self.spectrum = [[NSMutableData alloc] initWithBytes:tmp2 length:MAX_CHANNEL*sizeof(NSUInteger)];
    }
    return self;
}

-(void) addCount: (int)x :(int)y :(int)channel{
    
    if ((x < XSTRIPS) && (y < YSTRIPS) && (x >= 0) && (y >= 0)){
        UInt8 currentValue;
        NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
        [self.image getBytes:&currentValue range:NSMakeRange(x + XSTRIPS * y, 1)];
        currentValue++;
        [self.image replaceBytesInRange:NSMakeRange(x + XSTRIPS * y, 1) withBytes:&currentValue];
        [self.imageTime replaceBytesInRange:NSMakeRange(x + XSTRIPS * y, sizeof(currentTime)) withBytes:&currentTime];

        NSUInteger currentChannelCount;
        [self.spectrum getBytes:&currentChannelCount range:NSMakeRange(channel * sizeof(NSUInteger), sizeof(NSUInteger))];
        currentChannelCount++;
        [self.spectrum replaceBytesInRange:NSMakeRange(channel * sizeof(NSUInteger), sizeof(NSUInteger)) withBytes:&currentChannelCount];
        
        //spectrum[channel]++;
        //lightcurve[0]++;
        if (self.imageMaximum < currentValue) {
            self.imageMaximum = currentValue;
        }
        if (self.spectrumMaximum < currentChannelCount) {
            self.spectrumMaximum = currentChannelCount;
        }
    }

}

-(void) flushImage{
    [self.image resetBytesInRange:NSMakeRange(0, [self.image length])];
}

-(void) flushSpectrum{
    [self.spectrum resetBytesInRange:NSMakeRange(0, [self.spectrum length])];
}

-(void) flushLightcurve{
    for (int i = 0; i < MAX_TIME; i++) {
        //lightcurve[i] = 0;
    }
}

-(void) flushAll{
    [self flushImage];
    [self flushLightcurve];
    [self flushSpectrum];
}

@end
