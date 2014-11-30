//
//  DetectorView.h
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/24/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DetectorView : NSOpenGLView

@property (strong) NSArray *data;
@property int imageMax;
@property int pixelHalfLife;
@property NSInteger detectorToDisplay;

@end
