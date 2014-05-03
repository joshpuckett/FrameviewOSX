//
//  CustomWebView.m
//  FrameviewOSX
//
//  Created by Josh Puckett on 4/5/14.
//  Copyright (c) 2014 Josh Puckett. All rights reserved.
//

#import "CustomWebView.h"

@implementation CustomWebView
{
    NSCursor *_bobble;
    NSCursor *_bobblePress;

}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {

    }
    return self;
}

-(void)drawRect:(NSRect)dirtyRect
{
    //Drawing code here
    _bobble = [[NSCursor alloc] initWithImage:[NSImage imageNamed:@"bobble"] hotSpot:NSMakePoint(22, 22)];
    _bobblePress = [[NSCursor alloc] initWithImage:[NSImage imageNamed:@"bobble_press"] hotSpot:NSMakePoint(22, 22)];
}

- (void)updateTrackingAreas
{
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingCursorUpdate | NSTrackingActiveInActiveApp);
    _webviewTrackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                  options:opts
                                                    owner:self
                                                 userInfo:nil];
    [self addTrackingArea:_webviewTrackingArea];
}

-(void)mouseEntered:(NSEvent *)theEvent
{
    [self resetCursorRects];
}

-(void)mouseExited:(NSEvent *)theEvent
{
}

-(void)mouseDown:(NSEvent *)theEvent
{
    NSLog(@"Mouse down in webview");
}

-(void)mouseUp:(NSEvent *)theEvent
{
    NSLog(@"Mouse up in webview");
}

- (void)resetCursorRects
{
    [self discardCursorRects];
    [self addCursorRect:[self bounds] cursor:_bobble];
}


@end
