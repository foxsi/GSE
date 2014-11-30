//
//  ViewController.h
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/19/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FOXSIView.h"
#import "DetectorView.h"
#import "SpectraView.h"

@interface ViewController : NSViewController{
    @private
    int imageMaximum;
    int imagePixelHalfLife;
}

@property int imageMaximum;
@property int imagePixelHalfLife;

@property (weak) IBOutlet NSTextField *localTimeTextField;
@property (weak) IBOutlet NSTextField *versionTextField;

// Telemetry Box
@property (weak) IBOutlet NSTextField *frameNumberTextField;
@property (weak) IBOutlet NSTextField *timeTextField;
@property (weak) IBOutlet NSTextField *highVoltageTextField;
@property (weak) IBOutlet NSTextField *shutterStateTextField;
@property (weak) IBOutlet NSTextField *commandNumberTextField;
@property (weak) IBOutlet NSTextField *commandValueTextField;

// Control Box
- (IBAction)updateDetectorToDisplayAction:(NSSegmentedControl *)sender;
@property (weak) IBOutlet NSSegmentedControl *FlushTypeSegmentedControl;

// Voltages Box
@property (weak) IBOutlet NSTextField *VoltsTextField_five;
@property (weak) IBOutlet NSTextField *VoltsTextField_mfive;
@property (weak) IBOutlet NSTextField *VoltsTextField_onefive;
@property (weak) IBOutlet NSTextField *VoltsTextField_threethree;

// Temperatures Box
@property (weak) IBOutlet NSTextField *TemperatureTextField_tref;
@property (weak) IBOutlet NSTextField *TemperatureTextField_pwr;
@property (weak) IBOutlet NSTextField *TemperatureTextField_fact;
@property (weak) IBOutlet NSTextField *TemperatureTextField_fclk;
@property (weak) IBOutlet NSTextField *TemperatureTextField_aact;
@property (weak) IBOutlet NSTextField *TemperatureTextField_det6;
@property (weak) IBOutlet NSTextField *TemperatureTextField_det3;
@property (weak) IBOutlet NSTextField *TemperatureTextField_det4;
@property (weak) IBOutlet NSTextField *TemperatureTextField_det1;
@property (weak) IBOutlet NSTextField *TemperatureTextField_dplan;
@property (weak) IBOutlet NSTextField *TemperatureTextField_det0;
@property (weak) IBOutlet NSTextField *TemperatureTextField_abrd;

// FOXSI Image
@property (weak) IBOutlet NSTextField *PixelIndexTextField;
@property (weak) IBOutlet NSTextField *ArcminIndexTextField;
@property (weak) IBOutlet NSTextField *PixelValueTextField;


// Controls Box
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

- (IBAction)StartAction:(NSButton *)sender;
- (IBAction)CancelAction:(NSButton *)sender;
- (IBAction)TestAction:(NSButton *)sender;
- (IBAction)SetImageMaximumAction:(NSSlider *)sender;
- (IBAction)SetImagePixelHalfLifeAction:(NSSlider *)sender;
- (IBAction)FlushAction:(NSButton *)sender;

@property (weak) IBOutlet FOXSIView *foxsiView;
@property (weak) IBOutlet DetectorView *detectorView;
@property (weak) IBOutlet SpectraView *spectraView;

@property (nonatomic, retain) NSOperationQueue *operationQueue;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSDate *startTime;

@property (nonatomic, retain) NSArray *detectors;

- (void) receiveDataReadyNotification:(NSNotification *) notification;
- (void) StoppedReadingDataNotification:(NSNotification *) notification;

@end

