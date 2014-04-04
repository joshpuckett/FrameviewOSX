//
//  AppDelegate.h
//  FrameviewOSX
//
//  Created by Josh Puckett on 4/1/14.
//  Copyright (c) 2014 Josh Puckett. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AppDelegate : NSObject <NSWindowDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong) WebView *prototypeWebView;
@property (weak) IBOutlet NSSegmentedControl *device;
- (IBAction)deviceDidChange:(NSSegmentedControl *)sender;
@property (weak) IBOutlet NSMenuItem *menuItemLog;
- (IBAction)menuItemLogClicked:(NSMenuItem *)sender;




@end
