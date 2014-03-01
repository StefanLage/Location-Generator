//
//  LGWindow.m
//  Location Generator
//
//  Created by Stefan Lage on 01/03/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import "LGWindow.h"

@implementation LGWindow

-(id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag{
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
    if(self){
        [self setRepresentedURL:[NSURL URLWithString:@"WindowTitle"]];
    }
    return self;
}

- (void)setRepresentedURL:(NSURL *)url
{
    [super setRepresentedURL:url];
    NSImage* img = [NSImage imageNamed:@"Icon.png"];
    [[self standardWindowButton:NSWindowDocumentIconButton] setImage:img];
}

@end
