//
//  LGAppDelegate.h
//  Location Generator
//
//  Created by Stefan Lage on 27/02/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LGAppDelegate : NSObject <NSApplicationDelegate>{
    NSString *filename;
    NSString *address;
    NSString *city;
    NSString *pCode;
    NSString *country;
    float progressX;
    float progressY;
}

@property (strong, nonatomic) NSNotificationCenter *nCenter;
@property (strong ,nonatomic) NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSView *view;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *filenameField;
@property (weak) IBOutlet NSTextField *addressField;
@property (weak) IBOutlet NSTextField *cityField;
@property (weak) IBOutlet NSTextField *postalCodeField;
@property (weak) IBOutlet NSTextField *countryField;
@property (weak) IBOutlet NSButton *generateBtn;
- (IBAction)generateFile:(id)sender;

@end
