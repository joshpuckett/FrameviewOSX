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
@property (retain, nonatomic) IBOutlet WebView *prototypeWebView;

@end
