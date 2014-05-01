//
//  CustomWebView.m
//  FrameviewOSX
//
//  Created by Josh Puckett on 4/5/14.
//  Copyright (c) 2014 Josh Puckett. All rights reserved.
//

#import "CustomWebView.h"

@implementation CustomWebView
@synthesize _bobble;

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
}

-(void)mouseEntered:(NSEvent *)theEvent {
    [[self window] invalidateCursorRectsForView:self];
}

-(void)mouseExited:(NSEvent *)theEvent {
    [[self window] invalidateCursorRectsForView:self];
}

- (void)resetCursorRects
{
    [self discardCursorRects];
    _bobble = [[NSCursor alloc] initWithImage:[NSImage imageNamed:@"bobble"] hotSpot:NSMakePoint(16, 16)];
    [self addCursorRect:[self bounds] cursor:_bobble];
        NSLog(@"webview cursor reset was called");
}


@end
