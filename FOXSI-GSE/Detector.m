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

-(id)init{
    self = [super init]; // call our super’s designated initializer
    if (self) {
        // insert initializing here
        self.xpixels = XSTRIPS;
        self.ypixels = YSTRIPS;
        self.imageMaximum = 0;
    }
    return self;
}

-(void) addCount: (int)x :(int)y :(int)channel{
    
    if ((x < XSTRIPS) && (y < YSTRIPS) && (x >= 0) && (y >= 0)){
        image[x * XSTRIPS * y]++;
        spectrum[channel]++;
        lightcurve[0]++;
        if (self.imageMaximum < image[x * XSTRIPS * y]) {
            self.imageMaximum = image[x * XSTRIPS * y];
        }
    }

}

-(unsigned long *)image{
    return image;
}

-(unsigned long *)lightcurve{
    return lightcurve;
}

-(unsigned long *)spectrum{
    return spectrum;
}

-(void) flushImage{
    for (int i = 0; i < XSTRIPS * YSTRIPS; i++) {
        image[i] = 0;
    }
}

-(void) flushSpectrum{
    for (int i = 0; i < MAX_CHANNEL; i++) {
        spectrum[i] = 0;
    }
}

-(void) flushLightcurve{
    for (int i = 0; i < MAX_TIME; i++) {
        lightcurve[i] = 0;
    }
}

-(void) flushAll{
    [self flushImage];
    [self flushLightcurve];
    [self flushSpectrum];
}

@end
