//
//  CustomTrackingArea.m
//  CursorTest
//
//  Created by Josh Puckett on 5/2/14.
//  Copyright (c) 2014 Josh Puckett. All rights reserved.
//

#import "CursorBobble.h"

@implementation CursorBobble
{
    NSCursor *_bobble;
    NSCursor *_bobblePress;

}


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    return self;

}

- (void)updateTrackingAreas
{
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingCursorUpdate | NSTrackingActiveInActiveApp | NSTrackingMouseMoved);
    _trackingArea = [ [NSTrackingArea alloc] initWithRect:[self frame]
                                                  options:opts
                                                    owner:self
                                                 userInfo:nil];
    [self addTrackingArea:_trackingArea];
    
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    _bobble = [[NSCursor alloc] initWithImage:[NSImage imageNamed:@"bobble"] hotSpot:NSMakePoint(22, 22)];
    _bobblePress = [[NSCursor alloc] initWithImage:[NSImage imageNamed:@"bobble_press"] hotSpot:NSMakePoint(22, 22)];

}

-(void)mouseEntered:(NSEvent *)theEvent
{
    [self resetCursorRects];
}

- (void)mouseDown:(NSEvent *)theEvent {
  //  [[NSCursor crosshairCursor] set];

    [_bobblePress set];
        NSLog(@"mouse down");
}

- (void)mouseUp:(NSEvent *)theEvent {
    NSLog(@"mouse up");
    [_bobble set];
}


- (void)resetCursorRects
{
    [self discardCursorRects];
     _bobble = [[NSCursor alloc] initWithImage:[NSImage imageNamed:@"bobble"] hotSpot:NSMakePoint(22, 22)];
    [self addCursorRect:[self bounds] cursor:_bobble];
}



@end
