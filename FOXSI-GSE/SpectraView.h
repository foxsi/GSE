//
//  SpectraView.h
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/30/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SpectraView : NSOpenGLView

@property (strong) NSArray *data;
@property NSUInteger binsize;

@end
