//
//  ViewController.h
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/19/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController


// Telemetry Box
@property (weak) IBOutlet NSTextField *frameNumberTextField;
@property (weak) IBOutlet NSTextField *timeTextField;
@property (weak) IBOutlet NSTextField *highVoltageTextField;
@property (weak) IBOutlet NSTextField *shutterStateTextField;
@property (weak) IBOutlet NSTextField *commandNumberTextField;
@property (weak) IBOutlet NSTextField *commandValueTextField;

// Voltages Box
@property (weak) IBOutlet NSTextField *fiveVoltsTextField;
@property (weak) IBOutlet NSTextField *minusFiveVoltsTextField;
@property (weak) IBOutlet NSTextField *oneThreeVoltagsTextField;
@property (weak) IBOutlet NSTextField *threeThreeVoltsTextField;

// Temperatures Box


// Controls Box
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

- (IBAction)StartAction:(NSButton *)sender;
- (IBAction)CancelAction:(NSButton *)sender;
- (IBAction)TestAction:(NSButton *)sender;


@property (nonatomic, retain) NSOperationQueue *operationQueue;

- (void) receiveDataReadyNotification:(NSNotification *) notification;
- (void) StoppedReadingDataNotification:(NSNotification *) notification;

@end

