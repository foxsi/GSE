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
        image[x][y]++;
        if (self.imageMaximum < image[x][y]) {
            self.imageMaximum = image[x][y];
        }
    }

}

@end
