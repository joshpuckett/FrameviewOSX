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
{
    BOOL isRetina;
    BOOL isIphone;
    NSImage *phoneImage;
    NSView* _centerView;
    NSView* _contentView;
    CALayer* _phoneImageLayer;
    CALayer* _centerLayer;
    
}
@synthesize window;
@synthesize prototypeWebView;

static NSString *SaveToolbarItemIdentifier = @"My Save Toolbar Item";
static NSString *SearchToolbarItemIdentifier = @"My Search Toolbar Item";

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[self window] setDelegate:self];

    isIphone = true;

    //Determine isRetina
    CGFloat backingScaleFactor = self.window.screen.backingScaleFactor;
    if (backingScaleFactor == 2) {
        isRetina = true;
    } else {
        isRetina = false;
    }

    _contentView = window.contentView;

    phoneImage = [NSImage imageNamed:@"iphone_white@2x"];
    NSSize phoneImageSize = phoneImage.size;
    _centerView = [[NSView alloc] initWithFrame:(NSRect){0,0,(isRetina ? phoneImageSize.width : phoneImageSize.width*2),(isRetina ? phoneImageSize.height : phoneImageSize.height*2)}];
    _centerView.wantsLayer = YES;
    _centerLayer = _centerView.layer;
    _phoneImageLayer = [CALayer layer];
    _phoneImageLayer.contents = [phoneImage layerContentsForContentsScale:backingScaleFactor];
    _phoneImageLayer.contentsGravity = kCAGravityResizeAspect;
    _phoneImageLayer.frame = (CGRect){0,0,(isRetina ? phoneImageSize.width : phoneImageSize.width*2),(isRetina ? phoneImageSize.height : phoneImageSize.height*2)};
    [_centerLayer addSublayer:_phoneImageLayer];
    [_contentView addSubview:_centerView];

    NSRect webViewBounds = (NSRect){0,0,(isRetina ? 320 : 640),(isRetina ? 568 : 1136)};
    webViewBounds.origin.x = ((isRetina ? phoneImageSize.width : phoneImageSize.width*2) - webViewBounds.size.width) / 2;
    webViewBounds.origin.y = ((isRetina ? phoneImageSize.height : phoneImageSize.height*2) - webViewBounds.size.height) / 2;
    prototypeWebView = [[WebView alloc] initWithFrame:webViewBounds];
    [_centerView addSubview:prototypeWebView];

    //Set up my web view to hold the prototypes
    NSString *urlAddress = @"";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [prototypeWebView.mainFrame loadRequest:requestObj];
    [prototypeWebView.mainFrame.frameView setAllowsScrolling:NO];
    prototypeWebView.frameLoadDelegate = self;

    [_contentView setPostsFrameChangedNotifications:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentViewBoundsDidChange:) name:NSViewFrameDidChangeNotification object:_contentView];

    [self contentViewBoundsDidChange:nil];

}


- (void)contentViewBoundsDidChange:(NSNotification*)notification
{
    [_centerView scaleUnitSquareToSize:[_centerView convertSize:(NSSize){1, 1} fromView:nil]];

    NSSize contentSize = _contentView.frame.size;
    NSRect centerViewBounds = _centerView.bounds;

    CGFloat centerViewScale = (contentSize.height / (centerViewBounds.size.height + 10)) * 0.8;
    CGFloat aspectRatio = centerViewBounds.size.width / centerViewBounds.size.height;
    CGSize scaledSize;
    scaledSize.height = (centerViewBounds.size.height * centerViewScale);
    scaledSize.width = scaledSize.height * aspectRatio;

    [_centerView setFrameOrigin:(NSPoint){
        (floorf(contentSize.width) - floorf(scaledSize.width)) / 2,
        (floorf(contentSize.height) - floorf(scaledSize.height)) / 2
    }];

    [_centerView scaleUnitSquareToSize:(NSSize){centerViewScale, centerViewScale}];
}


#pragma mark - WebFrameLoadDelegate

- (void)setupWebView {
    if (isRetina) {
        [prototypeWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.style.webkitTransformOrigin = '0 0'; document.body.style.webkitTransform = 'scale(%f)';", 0.5]];
    }
}


- (void)webView:(WebView *)webView didClearWindowObject:(WebScriptObject *)windowObject forFrame:(WebFrame *)frame {
    [self setupWebView];
}


- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    // Called when the web view's frame has its environment set up.
    [self setupWebView];
}

- (IBAction)buttonPressed:(NSButton *)sender {

}

-(void)windowDidEnterFullScreen:(NSNotification *)notification {
    [self contentViewBoundsDidChange:nil];
}

- (IBAction)deviceDidChange:(NSSegmentedControl *)sender {
    CGFloat backingScaleFactor = self.window.screen.backingScaleFactor;

    NSImage *androidPhoneImage;
    if (isIphone) {
        androidPhoneImage = [NSImage imageNamed:@"nexus@2x"];
    }
    else {
        androidPhoneImage = [NSImage imageNamed:@"iphone_white@2x"];
    }
    NSSize phoneImageSize = androidPhoneImage.size;
    [_centerView setFrame:(CGRect){0,0,(isRetina ? phoneImageSize.width : phoneImageSize.width*2),(isRetina ? phoneImageSize.height : phoneImageSize.height*2)}];
    _phoneImageLayer.contents = [androidPhoneImage layerContentsForContentsScale:backingScaleFactor];
    [_phoneImageLayer setFrame:(CGRect){0,0,(isRetina ? phoneImageSize.width : phoneImageSize.width*2),(isRetina ? phoneImageSize.height : phoneImageSize.height*2)}];

    NSRect webViewBounds = (NSRect){0,0,(isIphone ? (isRetina ? 360 : 720) : (isRetina ? 320 : 640)),(isIphone ? (isRetina ? 640 : 1280) : (isRetina ? 568 : 1136))};
    webViewBounds.origin.x = ((isRetina ? phoneImageSize.width : phoneImageSize.width*2) - webViewBounds.size.width) / 2;
    webViewBounds.origin.y = ((isRetina ? phoneImageSize.height : phoneImageSize.height*2) - webViewBounds.size.height) / 2;
    prototypeWebView.frame = webViewBounds;

    [self contentViewBoundsDidChange:nil];
    isIphone = !isIphone;
    NSLog(@"Button clicked");
}
@end