//
//  FOXSIView.m
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/23/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import "FOXSIView.h"
#include <OpenGL/gl.h>
#include <OpenGL/glext.h>
#import <GLUT/GLUT.h>

#define XSTRIPS 128
#define YSTRIPS 128
#define	XBORDER 5
#define YBORDER 5
#define NUM_DETECTORS 7

@implementation FOXSIView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    
    glEnable (GL_BLEND);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glViewport(0,0,w(),h());
    glOrtho(0,3*XSTRIPS+4 + detector_buffer[0]*2 + 2*border_buffer,0,3*YSTRIPS+4 + detector_buffer[1]*2 + 2*border_buffer,0,-1);
   	glMatrixMode(GL_MODELVIEW);
    glDisable(GL_DEPTH_TEST);
   	glPushMatrix();
   	glClearColor(0.0,0.0,0.0,0.0);
   	glClear(GL_COLOR_BUFFER_BIT);
    
    
    // Drawing code here.
}

- (void) prepareOpenGL
{
    // init GL stuff here
    glLoadIdentity();
    glPushMatrix();
    
    gluOrtho2D(0,self.numberXPixels.integerValue, 0, self.numberYPixels.integerValue);
    glMatrixMode(GL_MODELVIEW);
    
    glScalef(1, -1, 1);
    glTranslatef(0, -self.numberYPixels.integerValue, 0);
    
    glDisable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);
}

@end
