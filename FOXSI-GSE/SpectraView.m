//
//  SpectraView.m
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/30/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import "SpectraView.h"
#import "Detector.h"
#include <OpenGL/gl.h>

#define XSTRIPS 128
#define YSTRIPS 128

@implementation SpectraView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [[self openGLContext] makeCurrentContext];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    NSUInteger numberOfDetectors = [self.data count];
    
    for (Detector *currentDetector in self.data) {
        
        // draw a line separating the histograms
        glColor3f(1.0, 1.0, 1.0);
        glBegin(GL_LINES);
        glVertex2f(1024 * numberOfDetectors/self.binsize, 0);
        glVertex2f(1024 * numberOfDetectors/self.binsize, 100);
        glEnd();
        
        glColor3f(0.0, 1.0, 0.0);

        for(int i = 0; i < 1024/self.binsize; i++)
        {
            NSUInteger currentChannelCount;
            [currentDetector.spectrum getBytes:&currentChannelCount range:NSMakeRange(i * sizeof(NSUInteger), sizeof(NSUInteger))];
            
            // draw histogram horizontal lines
            glBegin(GL_LINES);
            glVertex2f(i + currentDetector.maxChannel/self.binsize*numberOfDetectors + numberOfDetectors, currentChannelCount);
            glVertex2f(i + 1 + currentDetector.maxChannel / self.binsize * numberOfDetectors + numberOfDetectors, currentChannelCount);
            glEnd();
            
            // draw error bars
            glBegin(GL_LINES);
            float plusErrorValue = currentChannelCount + sqrt(currentChannelCount);
            float minusErrorValue = currentChannelCount - sqrt(currentChannelCount);
            glVertex2f(i + currentDetector.maxChannel/self.binsize*numberOfDetectors + numberOfDetectors, plusErrorValue);
            glVertex2f(i + 1 + currentDetector.maxChannel / self.binsize * numberOfDetectors + numberOfDetectors, minusErrorValue   );
            glEnd();
        }
        
        // draw the connecting line
        //glBegin(GL_LINE_LOOP);
        //glVertex2f(0.5 + xmax/binsize*detector_num + detector_num, 0);
        //for(int i = 0; i < MAX_CHANNEL/binsize; i++) {
        //    long y = gui->mainHistogramWindow->get_detectorDisplayHistogram(i, detector_num);
        //    glVertex2f(i + 0.5 + xmax/binsize*detector_num + detector_num, y); }
        //glVertex2f(MAX_CHANNEL/binsize + 0.5 + xmax/binsize*detector_num + detector_num, 0);
        //glEnd();
    }
    
    glPopMatrix();
    glFinish();
    glFlush();
    
    //[self setNeedsDisplay:YES];
    // Drawing code here.
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
    
    self.binsize = 1;

    glOrtho(0, 1024 * [self.data count] / self.binsize, 0, 100, 0, -1);
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();    
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

@end
