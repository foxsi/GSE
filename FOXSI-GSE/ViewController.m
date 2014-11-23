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

@implementation ViewController

@synthesize operationQueue = _operationQueue;

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
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
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
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    // Configure your panel the way you want it
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"dat"]];
    
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            
            for (NSURL *fileURL in [panel URLs]) {
                // Do what you want with fileURL
                NSLog(@"User chose file %@", fileURL);
            }
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
        self.commandValueTextField.integerValue = [thisFrame.command_value integerValue];
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
