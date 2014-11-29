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
#include <GLUT/GLUT.h>
#include "Detector.h"

#define XSTRIPS 128
#define YSTRIPS 128
#define	XBORDER 5
#define YBORDER 5
#define NUM_DETECTORS 7
#define BORDER_BUFFER 35
#define NUM_CIRCLE_SEGMENTS   30    // the number of line segments to use for circles

@interface FOXSIView ()
@property (nonatomic, strong) NSArray *detector_angles;
-(void) drawText: (NSPoint) origin :(NSString *)text;
-(void) drawCircle: (NSPoint) origin :(float) r;
@end

@implementation FOXSIView

@synthesize detector_angles;

-(id) initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        // does not execute this code?!
    }
    return self;
}

+ (NSOpenGLPixelFormat *)defaultPixelFormat
{
    static NSOpenGLPixelFormat *pf;
    
    if (pf == nil)
    {
        /*
         Making sure the context's pixel format doesn't have a recovery renderer is important - otherwise CoreImage may not be able to create deeper context's that share textures with this one.
         */
        static const NSOpenGLPixelFormatAttribute attr[] = {
            NSOpenGLPFAAccelerated,
            NSOpenGLPFANoRecovery,
            NSOpenGLPFAColorSize, 32,
            NSOpenGLPFAAllowOfflineRenderers,  /* Allow use of offline renderers */
            0
        };
        
        pf = [[NSOpenGLPixelFormat alloc] initWithAttributes:(void *)&attr];
    }
    
    return pf;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [[self openGLContext] makeCurrentContext];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
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
                position_name = @"+D2 (CdTe)";
                break;
            case 3:
                center.x = 2*XSTRIPS + BORDER_BUFFER; center.y = 0.5*YSTRIPS - BORDER_BUFFER;
                position_name = @"D3 (CdTe)";
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
        float rotationAngle = [[self.detector_angles objectAtIndex:detector_num] floatValue];
        glRotatef( rotationAngle + 90, 0.0f, 0.0f, 1.0f);
        // glScaled(1, 1, 1);
        glScaled(-1, -1, 1);
        
        // draw the data
        // draw the data in the detector
        GLfloat grey = 0.0;
        Detector *currentDetector = [self.data objectAtIndex:detector_num];
        for(int i = 0; i < XSTRIPS; i++)
        {
            for(int j = 0; j < YSTRIPS; j++)
            {
                //grey = image[i][j][detector_num]/ymax[detector_num];
                //Detector *currentDetector = [self.data objectAtIndex:i];
                UInt8 pixel_value;
                [currentDetector.image getBytes:&pixel_value range:NSMakeRange(i + XSTRIPS*j, 1)];
                grey = pixel_value/(float)currentDetector.imageMaximum;
                if (grey != 0)
                {
                    //pixel_time = imagetime[i][j][detector_num];
                    //if (half_life != 0){
                    //    elapsed_time = ((double) current_time - pixel_time)/(CLOCKS_PER_SEC);
                    //    alpha = exp(-elapsed_time*0.693/half_life);
                    //} else {alpha = 1.0;}
                    glColor4f(grey, grey, grey, 1.0);
                    glBegin(GL_QUADS);
                    glVertex2f(i - 0.5*XSTRIPS, j - 0.5*XSTRIPS); glVertex2f(i+1 - 0.5*XSTRIPS, j- 0.5*XSTRIPS);
                    glVertex2f(i + 1 - 0.5*XSTRIPS, j + 1 - 0.5*XSTRIPS); glVertex2f(i - 0.5*XSTRIPS, j + 1- 0.5*XSTRIPS);
                    glEnd();
                }
            }
        }
        
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
        //glEnable(GL_LINE_STIPPLE);
        
        // border at 3 arcmin
        float border_factor = 3.0/16.5*0.5;
        [self drawCircle: NSMakePoint(0, 0) :border_factor*XSTRIPS];
        
        // border at 6 arcmin
        border_factor = 6.0/16.5*0.5;
        [self drawCircle: NSMakePoint(0, 0) :border_factor*XSTRIPS];
        
        // border at 9 arcmin
        border_factor = 9.0/16.5*0.5;
        [self drawCircle: NSMakePoint(0, 0) :border_factor*XSTRIPS];
        
        //glDisable(GL_LINE_STIPPLE);
    }
    glPopMatrix();
    glFinish();
    glFlush();
    
    //[self setNeedsDisplay:YES];
}

- (void)prepareOpenGL
{
    GLint parm = 1;
    
    /* Enable beam-synced updates. */
    
    [[self openGLContext] setValues:&parm forParameter:NSOpenGLCPSwapInterval];
    
    /* Make sure that everything we don't need is disabled. Some of these
     * are enabled by default and can slow down rendering. */
    
    glDisable(GL_ALPHA_TEST);
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_SCISSOR_TEST);
    glDisable(GL_BLEND);
    glDisable(GL_DITHER);
    glDisable(GL_CULL_FACE);
    glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
    glDepthMask(GL_FALSE);
    glStencilMask(0);
    glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
    glHint(GL_TRANSFORM_HINT_APPLE, GL_FASTEST);

    NSRect bounds = [self bounds];
    glViewport(0, 0, bounds.size.width, bounds.size.height);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0, 3*XSTRIPS+4 + BORDER_BUFFER * 2 + 2 * BORDER_BUFFER, 0, 3 * YSTRIPS + 4 + BORDER_BUFFER * 2 + 2 *BORDER_BUFFER, -1, 1);
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    //initialization
    self.detector_angles = [NSArray arrayWithObjects:[NSNumber numberWithFloat:82.5],
                            [NSNumber numberWithFloat:-7.5+90.0],
                            [NSNumber numberWithFloat:-67.5],
                            [NSNumber numberWithFloat:-75.0],
                            [NSNumber numberWithFloat:-87.5+180],
                            [NSNumber numberWithFloat:90.0],
                            [NSNumber numberWithFloat:-60], nil];
}

-(void) drawText: (NSPoint) origin :(NSString *)text
{
    glRasterPos2f(origin.x, origin.y);
    for (int i = 0; i < [text length]; i++) {
        glutBitmapCharacter(GLUT_BITMAP_HELVETICA_12, [text characterAtIndex:i]);
    }
}

-(void) drawCircle: (NSPoint) origin :(float) r{
    // code courtesy of SiegeLord's Abode
    // http://slabode.exofire.net/circle_draw.shtml
    float theta = 2 * 3.1415926 / (float)NUM_CIRCLE_SEGMENTS;
    float c = cosf(theta);//precalculate the sine and cosine
    float s = sinf(theta);
    float t;
    
    float x = r;//we start at angle = 0
    float y = 0;
    
    glBegin(GL_LINE_LOOP);
    for(int ii = 0; ii < NUM_CIRCLE_SEGMENTS; ii++)
    {
        glVertex2f(x + origin.x, y + origin.y);//output vertex
        
        //apply the rotation matrix
        t = x;
        x = c * x - s * y;
        y = s * t + c * y;
    }
    glEnd();
}



@end
