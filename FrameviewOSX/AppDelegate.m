//
//  AppDelegate.m
//  FrameviewOSX
//
//  Created by Josh Puckett on 4/1/14.
//  Copyright (c) 2014 Josh Puckett. All rights reserved.
//

#import "AppDelegate.h"
#import <WebKit/WebKit.h>

@implementation AppDelegate

@synthesize window;
@synthesize prototypeWebView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[self window] setDelegate:self];

    //Set up my web view to hold the prototypes
    NSString *urlAddress = @"https://s3-us-west-2.amazonaws.com/tweakapp.co/Framewebview/lightbox/index.html";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [prototypeWebView.mainFrame loadRequest:requestObj];
    [prototypeWebView.mainFrame.frameView setAllowsScrolling:NO];
    prototypeWebView.frameLoadDelegate = self;
}


- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize
{
    //Keep the view centered (and eventually scale it up by a factor as well
    [prototypeWebView setFrameOrigin:NSMakePoint( (frameSize.width - 320)/2, (frameSize.height - 568)/2 )];
    [self.window.contentView setNeedsDisplay:YES]; // this fixed potential "visual tearing"

    // Scale the webview's body on window resize

    //    float scaleFactor = (frameSize.height - 20)/1136;
    //    NSString *resizeBody = [NSString stringWithFormat:@"document.body.style.webkitTransform = 'scale(%f)';",scaleFactor];
    //    [prototypeWebView stringByEvaluatingJavaScriptFromString:resizeBody];
    return frameSize;
}


#pragma mark - WebFrameLoadDelegate

- (void)webView:(WebView*)webView didClearWindowObject:(WebScriptObject*)windowObject forFrame:(WebFrame*)frame {
    // Called when the web view's frame has its environment set up.
    CGFloat scaleFactor = [self.window.screen respondsToSelector:@selector(backingScaleFactor)] ? self.window.screen.backingScaleFactor : 1.0;
    if (scaleFactor != 1.0) {
        [windowObject evaluateWebScript:[NSString stringWithFormat:@"document.body.style.webkitTransformOrigin = '0 0'; document.body.style.webkitTransform = 'scale(%f)';", 1.0 / scaleFactor]];
    }
}

@end