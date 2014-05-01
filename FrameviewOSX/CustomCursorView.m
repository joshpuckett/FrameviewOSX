//
//  CustomCursorView.m
//  FrameviewOSX
//
//  Created by Josh Puckett on 4/5/14.
//  Copyright (c) 2014 Josh Puckett. All rights reserved.
//

#import "CustomCursorView.h"

@implementation CustomCursorView
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

- (void)resetCursorRects
{
    [super resetCursorRects];
    _bobble = [[NSCursor alloc] initWithImage:[NSImage imageNamed:@"bobble@2x"] hotSpot:NSMakePoint(16, 16)];
    [self addCursorRect:[self bounds] cursor:_bobble];
    NSLog(@"resetCursorRects was called");
}


@end
