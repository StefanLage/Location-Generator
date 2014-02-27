//
//  LGAppDelegate.m
//  Location Generator
//
//  Created by Stefan Lage on 27/02/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import "LGAppDelegate.h"
#import "Constants.h"

@implementation LGAppDelegate

@synthesize nCenter, progressIndicator;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Create path where gpx files will be created
    nCenter = [[NSNotificationCenter alloc] init];
    [nCenter addObserver:self
                selector:@selector(generatorObserver:)
                    name:NOTIFICATION_GPX
                  object:nil];
    [nCenter addObserver:self
                selector:@selector(generatorErrorObserver:)
                    name:NOTIFICATION_ERROR
                  object:nil];
    // Create destination if not existing
    [self createDirectory];
    // Get origin of progressIndicator
    progressX = self.generateBtn.frame.origin.x + self.generateBtn.frame.size.width + 20;
    progressY = self.generateBtn.frame.origin.y;
}

-(void)generateLocationFile{
    NSTask* task = [[NSTask alloc] init];
    task.launchPath = PYTHON_PATH;
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:GPX_SCRIPT_NAME
                                                           ofType:PYTHON_EXTENSION];
    task.arguments = @[scriptPath, GPX_OPTION_CITY, city,
                       GPX_OPTION_COUNTRY, country, GPX_OPTION_ADDRESS,
                       address, GPX_OPTION_POSTAL_CODE, pCode,
                       GPX_OPTION_PATH, GPX_PATH, GPX_OPTION_OUTPUT, filename];
    // NSLog breaks if we don't do this...
    [task setStandardInput: [NSPipe pipe]];
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    // Execute CMD
    [task launch];
    NSData *data;
    data = [file readDataToEndOfFile];
    NSString *string;
    string = [[NSString alloc] initWithData:data
                                   encoding:NSUTF8StringEncoding];
    if([string isEqualToString:GENERATOR_ERROR])
        // Something went wrong !
        [nCenter postNotificationName:NOTIFICATION_ERROR object:nil];
    else
        [nCenter postNotificationName:NOTIFICATION_GPX object:nil];
}

- (IBAction)generateFile:(id)sender {
    filename    = [self.filenameField stringValue];
    address     = [self.addressField stringValue];
    city        = [self.cityField stringValue];
    country     = [self.countryField stringValue];
    pCode       = [self.postalCodeField stringValue];
    if([self isRequiredInformed]){
        [self.generateBtn setEnabled:NO];
        [self createSpinner];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
            [self generateLocationFile];
        });
    }
}

-(BOOL)isRequiredInformed{
    if([city isEqualToString:EMPTY_STRING]
       || [country isEqualToString:EMPTY_STRING]){
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:REQUIRED_MSG];
        [alert runModal];
        return NO;
    }
    else
        return YES;
}

-(void)resetFields{
    [self.filenameField     setStringValue:EMPTY_STRING];
    [self.addressField      setStringValue:EMPTY_STRING];
    [self.cityField         setStringValue:EMPTY_STRING];
    [self.postalCodeField   setStringValue:EMPTY_STRING];
    [self.countryField      setStringValue:EMPTY_STRING];
}

#pragma NSNotificationCenter Observers

-(void)generatorObserver:(id)sender{
    if([filename isEqualToString:EMPTY_STRING])
        filename = GPX_DEFAULT_FILENAME;
    NSUserNotification *notification    = [[NSUserNotification alloc] init];
    notification.title                  = NOTIFICATION_TITLE;
    notification.informativeText        = [NSString stringWithFormat:NOTIFICATION_MESSAGE, filename];
    notification.soundName              = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    [self deleteSpinner];
    [self resetFields];
    [self openDirectory];
    [self.generateBtn setEnabled:YES];
}

-(void)generatorErrorObserver:(id)sender{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:GENERATOR_ERROR];
    [alert runModal];
}

#pragma Directory management

-(void)createDirectory{
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:[GPX_URL path]
                                             isDirectory:&isDirectory]){
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtURL:GPX_URL
                                 withIntermediateDirectories:NO
                                                  attributes:nil
                                                       error:&error];
        if(error)
            NSLog(@"CANNOT CREATE DIRECTORY %@", error.description);
    }
}

-(void)openDirectory{
    [[NSWorkspace sharedWorkspace] openURL:GPX_URL];
}

#pragma Spinner

-(void)createSpinner
{
    if(self.progressIndicator == nil)
        self.progressIndicator = [[NSProgressIndicator alloc] init];
    [self.progressIndicator setBezeled: NO];
    [self.progressIndicator setStyle: NSProgressIndicatorSpinningStyle];
    [self.progressIndicator setControlSize: NSRegularControlSize];
    [self.progressIndicator sizeToFit];
    [self.progressIndicator setUsesThreadedAnimation:YES];
    [self.progressIndicator setFrameOrigin:NSMakePoint(progressX, progressY)];
    [self.progressIndicator startAnimation:self];
    [self.view addSubview:progressIndicator];
}

-(void)deleteSpinner{
    [self.progressIndicator removeFromSuperview];
    self.progressIndicator = nil;
}


@end
