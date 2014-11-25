//
//  ViewController.m
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/19/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import "ViewController.h"
#import "ReadDataOp.h"
#import "DataFrame.h"
#import "DataHousekeeping.h"
#import "NumberInRangeFormatter.h"
#import "Detector.h"

@implementation ViewController

@synthesize operationQueue = _operationQueue;

@synthesize sliderAmount;
@synthesize halfLifeValue;
@synthesize detectors;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.operationQueue = [[NSOperationQueue alloc] init];
    [self.operationQueue setMaxConcurrentOperationCount:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDataReadyNotification:)
                                                 name:@"DataReady"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(StoppedReadingDataNotification:)
                                                 name:@"StoppedReadingData"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveHousekeepingNotification:)
                                                 name:@"HousekeepingReady"
                                               object:nil];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
    
    NumberInRangeFormatter *formatter;
    formatter = [self.highVoltageTextField formatter];
    formatter.maximum = 100;
    formatter.minimum = 10;
    
    NSString *appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleSignature"];
    self.versionTextField.stringValue = appVersionString;
    
    Detector *detector0 = [[Detector alloc] init];
    detector0.name = @"D0";
    Detector *detector1 = [[Detector alloc] init];
    detector0.name = @"D1";
    Detector *detector2 = [[Detector alloc] init];
    detector0.name = @"D2";
    Detector *detector3 = [[Detector alloc] init];
    detector0.name = @"D3";
    Detector *detector4 = [[Detector alloc] init];
    detector0.name = @"D4";
    Detector *detector5 = [[Detector alloc] init];
    detector0.name = @"D5";
    Detector *detector6 = [[Detector alloc] init];
    detector0.name = @"D6";
    
    self.detectors = [NSArray arrayWithObjects:detector0, detector1, detector2,
                      detector3, detector4, detector5, detector6, nil];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)StartAction:(NSButton *)sender {
    NSLog(@"blah");
    ReadDataOp *operation = [[ReadDataOp alloc] init];
    [self.operationQueue addOperation:operation];
    [self.progressIndicator startAnimation:nil];
    self.startTime = [NSDate date];
}

- (IBAction)CancelAction:(NSButton *)sender {
    for (NSOperation *operation in [self.operationQueue operations]) {
        [operation cancel];
    }
}

- (IBAction)TestAction:(NSButton *)sender {
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    
    // This method displays the panel and returns immediately.
    // The completion handler is called when the user selects an
    // item or cancels the panel.
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL*  theDoc = [[panel URLs] objectAtIndex:0];
            
            // Open  the document.
        }
        
    }];
}

- (void) receiveDataReadyNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    // if the data is ready then update the displays
    if ([[notification name] isEqualToString:@"DataReady"]){
        DataFrame *thisFrame = [notification object];
        self.frameNumberTextField.integerValue = [thisFrame.number integerValue];
        self.timeTextField.integerValue = [thisFrame.time integerValue];
        self.highVoltageTextField.integerValue = [thisFrame.high_voltage integerValue];
        self.commandNumberTextField.integerValue = [thisFrame.commnand_count integerValue];
        self.commandValueTextField.stringValue = [NSString stringWithFormat:@"%x", [thisFrame.command_value intValue]];
        
        [self.foxsiView setNeedsDisplay:YES];
    }
}

- (void) receiveHousekeepingNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"HousekeepingReady"]){
        DataHousekeeping *thisHouse = [notification object];
    self.TemperatureTextField_tref.floatValue = [[thisHouse.temperatures objectAtIndex:0] floatValue];
    self.TemperatureTextField_pwr.floatValue = [[thisHouse.temperatures objectAtIndex:1] floatValue];
    self.TemperatureTextField_fact.floatValue = [[thisHouse.temperatures objectAtIndex:2] floatValue];
    self.TemperatureTextField_fclk.floatValue = [[thisHouse.temperatures objectAtIndex:3] floatValue];
    self.TemperatureTextField_aact.floatValue = [[thisHouse.temperatures objectAtIndex:4] floatValue];
    self.TemperatureTextField_abrd.floatValue = [[thisHouse.temperatures objectAtIndex:5] floatValue];
    self.TemperatureTextField_det6.floatValue = [[thisHouse.temperatures objectAtIndex:6] floatValue];
    self.TemperatureTextField_det3.floatValue = [[thisHouse.temperatures objectAtIndex:7] floatValue];
    self.TemperatureTextField_det4.floatValue = [[thisHouse.temperatures objectAtIndex:8] floatValue];
    self.TemperatureTextField_det1.floatValue = [[thisHouse.temperatures objectAtIndex:9] floatValue];
    self.TemperatureTextField_dplan.floatValue = [[thisHouse.temperatures objectAtIndex:10] floatValue];
    self.TemperatureTextField_det0.floatValue = [[thisHouse.temperatures objectAtIndex:11] floatValue];
    
    self.VoltsTextField_five.floatValue = [[thisHouse.voltages objectAtIndex:0] floatValue];
    self.VoltsTextField_mfive.floatValue = [[thisHouse.voltages objectAtIndex:1] floatValue];
    self.VoltsTextField_onefive.floatValue = [[thisHouse.voltages objectAtIndex:2] floatValue];
    self.VoltsTextField_threethree.floatValue = [[thisHouse.voltages objectAtIndex:3] floatValue];
    }
}

- (void) StoppedReadingDataNotification:(NSNotification *) notification
{
    [self.progressIndicator stopAnimation:nil];
}

- (void) updateCurrentTime
{
    self.localTimeTextField.stringValue = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateIntervalFormatterFullStyle];
}

@end
