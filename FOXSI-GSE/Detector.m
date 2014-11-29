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

@implementation Detector

@synthesize image = _image;

-(id)init{
    self = [super init]; // call our super’s designated initializer
    if (self) {
        // insert initializing here
        self.xpixels = XSTRIPS;
        self.ypixels = YSTRIPS;
        self.imageMaximum = 0;
        UInt8 tmp[XSTRIPS*YSTRIPS] = {0};
        self.image = [[NSMutableData alloc] initWithBytes:tmp length:XSTRIPS*YSTRIPS];
    }
    return self;
}

-(void) addCount: (int)x :(int)y :(int)channel{
    
    if ((x < XSTRIPS) && (y < YSTRIPS) && (x >= 0) && (y >= 0)){
        UInt8 currentValue;
        [self.image getBytes:&currentValue range:NSMakeRange(x + XSTRIPS * y, 1)];
        currentValue++;
        [self.image replaceBytesInRange:NSMakeRange(x + XSTRIPS * y, 1) withBytes:&currentValue];
        //self.image[x + XSTRIPS * y]++;
        //spectrum[channel]++;
        //lightcurve[0]++;
        if (self.imageMaximum < currentValue) {
            self.imageMaximum = currentValue;
        }
    }

}

-(void) flushImage{
    for (int i = 0; i < XSTRIPS * YSTRIPS; i++) {
        [self.image resetBytesInRange:NSMakeRange(0, [self.image length])];
    }
}

-(void) flushSpectrum{
    for (int i = 0; i < MAX_CHANNEL; i++) {
        //spectrum[i] = 0;
    }
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
