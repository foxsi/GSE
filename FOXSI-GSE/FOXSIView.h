//
//  FOXSIView.h
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/23/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FOXSIView : NSOpenGLView

@property (strong) NSArray *data;
@property int imageMax;
@property int pixelHalfLife;

@end
