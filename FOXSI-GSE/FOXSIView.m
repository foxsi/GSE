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
#define BORDER_BUFFER 25

@interface FOXSIView()
-(void) drawText: (NSPoint) origin :(NSString *)text;
@property (nonatomic, strong) NSArray *detector_angles;
@end

@implementation FOXSIView

@synthesize detector_angles = _detector_angles;

-(id) initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        //initialization
        self.detector_angles = [NSArray arrayWithObjects:[NSNumber numberWithFloat:82.5],
                                [NSNumber numberWithFloat:-7.5+90.0],
                                [NSNumber numberWithFloat:-67.5],
                                [NSNumber numberWithFloat:-75.0],
                                [NSNumber numberWithFloat:-87.5+180],
                                [NSNumber numberWithFloat:90.0],
                                [NSNumber numberWithFloat:-60], nil];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    
   	glMatrixMode(GL_MODELVIEW);
    glDisable(GL_DEPTH_TEST);
   	glPushMatrix();
    
    for (int detector_num = 0; detector_num < NUM_DETECTORS; detector_num++) {
        NSPoint center = NSMakePoint(0, 0);
        NSString *position_name;
        
        switch (detector_num) {
            case 6:
                center.x = XSTRIPS; center.y = YSTRIPS;
                position_name = @"+D6";
                break;
            case 1:
                center.x = XSTRIPS; center.y = 2*YSTRIPS + BORDER_BUFFER;
                position_name = @"D1";
                break;
            case 2:
                center.x = 2*XSTRIPS + BORDER_BUFFER; center.y = 1.5*YSTRIPS + BORDER_BUFFER;
                position_name = @"+D%2 (CdTe)";
                break;
            case 3:
                center.x = 2*XSTRIPS + BORDER_BUFFER; center.y = 0.5*YSTRIPS - BORDER_BUFFER;
                position_name = @"D%3 (CdTe)";
                break;
            case 4:
                center.x = XSTRIPS; center.y = 0.0 - BORDER_BUFFER;
                position_name = @"D4";
                break;
            case 5:
                center.x = 0 - BORDER_BUFFER; center.y = 0.5*YSTRIPS - BORDER_BUFFER;
                position_name = @"D5";
                break;
            case 0:
                center.x = 0 - BORDER_BUFFER; center.y = 1.5*YSTRIPS + BORDER_BUFFER;
                position_name = @"D0";
                break;
            default:
                break;
        }
        center.x = center.x + 0.5*XSTRIPS + BORDER_BUFFER;
        center.y = center.y + 0.5*YSTRIPS + BORDER_BUFFER;
        
        glLoadIdentity();
        glTranslatef(center.x + BORDER_BUFFER, center.y + BORDER_BUFFER, 0.0f);
        [self drawText:NSMakePoint(-0.5 * XSTRIPS, -0.5 * XSTRIPS) :position_name];
        
        
        glScaled(1, -1, 0);
        // rotate by 90 CW and flip to correct image based on lead images
        glRotatef( [[self.detector_angles objectAtIndex:detector_num] floatValue] + 90, 0.0f, 0.0f, 1.0f);
        // glScaled(1, 1, 1);
        glScaled(-1, -1, 1);
        
        // draw the border around the detector
        glColor3f(1, 1, 1);
        
        glBegin(GL_LINE_LOOP);
        glVertex2f(- 0.5*XSTRIPS, - 0.5*XSTRIPS);
        glVertex2f(XSTRIPS - 0.5*XSTRIPS, - 0.5*XSTRIPS);
        glVertex2f(XSTRIPS - 0.5*XSTRIPS,  YSTRIPS - 0.5*XSTRIPS);
        glVertex2f(- 0.5*XSTRIPS, YSTRIPS - 0.5*XSTRIPS);
        glEnd();
        
        // draw colored line for p-side
        glColor3f(0, 0, 1);
        glBegin(GL_LINES);
        glVertex2f(- 0.5*XSTRIPS, - 0.5*XSTRIPS); 
        glVertex2f(XSTRIPS - 0.5*XSTRIPS, - 0.5*XSTRIPS);
        glEnd();
        
        // draw colored line for n-side
        glColor3f(1, 0, 0);
        glBegin(GL_LINES);
        glVertex2f(- 0.5*XSTRIPS, - 0.5*XSTRIPS); 
        glVertex2f(- 0.5*XSTRIPS, YSTRIPS - 0.5*XSTRIPS);
        glEnd();

        glColor3f(0.0, 1.0, 0.0);
        //text_output(0.65*YSTRIPS, 0.50*XSTRIPS, optic_name);
        
        // draw inner border for center of FOV
        glColor3f(0.0, 0.5, 0.0);
        glLineStipple(1, 0x3F07);
        glEnable(GL_LINE_STIPPLE);
        
        // border at 3 arcmin
        float border_factor = 3.0/16.5*0.5;
        glBegin(GL_LINE_LOOP);
        glVertex2f(- border_factor*XSTRIPS, - border_factor*XSTRIPS);
        glVertex2f(- border_factor*XSTRIPS + 2*border_factor*XSTRIPS, - border_factor*YSTRIPS);
        glVertex2f(- border_factor*XSTRIPS + 2*border_factor*XSTRIPS,  - border_factor*YSTRIPS + 2*border_factor*YSTRIPS);
        glVertex2f(- border_factor*XSTRIPS, - border_factor*YSTRIPS + 2*border_factor*YSTRIPS);
        glEnd();
        
        // border at 3 arcmin
        border_factor = 6.0/16.5*0.5;
        glBegin(GL_LINE_LOOP);
        glVertex2f(- border_factor*XSTRIPS, - border_factor*XSTRIPS);
        glVertex2f(- border_factor*XSTRIPS + 2*border_factor*XSTRIPS, - border_factor*YSTRIPS);
        glVertex2f(- border_factor*XSTRIPS + 2*border_factor*XSTRIPS,  - border_factor*YSTRIPS + 2*border_factor*YSTRIPS);
        glVertex2f(- border_factor*XSTRIPS, - border_factor*YSTRIPS + 2*border_factor*YSTRIPS);
        glEnd();
        
        // border at 3 arcmin
        border_factor = 9.0/16.5*0.5;
        glBegin(GL_LINE_LOOP);
        glVertex2f(- border_factor*XSTRIPS, - border_factor*XSTRIPS);
        glVertex2f(- border_factor*XSTRIPS + 2*border_factor*XSTRIPS, - border_factor*YSTRIPS);
        glVertex2f(- border_factor*XSTRIPS + 2*border_factor*XSTRIPS,  - border_factor*YSTRIPS + 2*border_factor*YSTRIPS);
        glVertex2f(- border_factor*XSTRIPS, - border_factor*YSTRIPS + 2*border_factor*YSTRIPS);
        glEnd();
        
        glDisable(GL_LINE_STIPPLE);
    }
    glPopMatrix();
    glFinish();
    glFlush();
    
    [self setNeedsDisplay:YES];
}

- (void)prepareOpenGL
{
    // init GL stuff here
    glLoadIdentity();
    glPushMatrix();
    
    gluOrtho2D(0, 3*XSTRIPS+4 + BORDER_BUFFER * 2 + 2 * BORDER_BUFFER, 0, 3 * YSTRIPS + 4 + BORDER_BUFFER * 2 + 2 *BORDER_BUFFER);
    glMatrixMode(GL_MODELVIEW);
    
    glDisable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);
}

-(void) drawText: (NSPoint) origin :(NSString *)text
{
    glRasterPos2f(origin.x, origin.y);
    for (int i = 0; i < [text length]; i++) {
        glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_10, [text characterAtIndex:i]);
    }
}

@end
