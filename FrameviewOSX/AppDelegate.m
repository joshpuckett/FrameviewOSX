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
    NSImageView *phoneImageView;
    NSImage *phoneImage;
    NSView* _centerView;
    __weak NSView* _contentView;
    CALayer* _phoneImageLayer;
}
@synthesize window;
@synthesize prototypeWebView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[self window] setDelegate:self];

    //Determine isRetina
    CGFloat backingScaleFactor = self.window.screen.backingScaleFactor;
    if (backingScaleFactor == 2) {
        isRetina = true;
    } else {
        isRetina = false;
    }

    _contentView = window.contentView;

    NSImage* iphoneImage = [NSImage imageNamed:@"iphone_white@2x"];
    NSSize iphoneImageSize = iphoneImage.size;
    _centerView = [[NSView alloc] initWithFrame:(NSRect){0,0,iphoneImageSize.width,iphoneImageSize.height}];
    _centerView.wantsLayer = YES;
    CALayer* centerLayer = _centerView.layer;
    _phoneImageLayer = [CALayer layer];
    _phoneImageLayer.contents = [iphoneImage layerContentsForContentsScale:backingScaleFactor];
    _phoneImageLayer.contentsGravity = kCAGravityResizeAspect;
    _phoneImageLayer.frame = (CGRect){0,0,iphoneImageSize.width,iphoneImageSize.height};
    [centerLayer addSublayer:_phoneImageLayer];
    [_contentView addSubview:_centerView];

    NSRect webViewBounds = (NSRect){0,0,320,568};
    webViewBounds.origin.x = (iphoneImageSize.width - webViewBounds.size.width) / 2;
    webViewBounds.origin.y = (iphoneImageSize.height - webViewBounds.size.height) / 2;
    prototypeWebView = [[WebView alloc] initWithFrame:webViewBounds];
    [_centerView addSubview:prototypeWebView];


    //Set up my web view to hold the prototypes
    NSString *urlAddress = @"file:///Users/puckett/Dropbox%20(Dropbox)/Public/lightbox/lightbox/index.html";
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
    [_centerView scaleUnitSquareToSize:[_centerView convertSize:(NSSize){1.0, 1.0} fromView:nil]];

    NSSize contentSize = _contentView.frame.size;
    NSRect centerViewBounds = _centerView.bounds;

    CGFloat centerViewScale = (contentSize.height / centerViewBounds.size.height) * 0.8;
    CGFloat aspectRatio = centerViewBounds.size.width / centerViewBounds.size.height;
    NSLog(@"Center View Height  is :%f", centerViewBounds.size.height);
    CGSize scaledSize;
    scaledSize.height = (centerViewBounds.size.height * centerViewScale);
    scaledSize.width = scaledSize.height * aspectRatio;

    [_centerView setFrameOrigin:(NSPoint){
        (contentSize.width - scaledSize.width) / 2,
        (contentSize.height - scaledSize.height) / 2
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

@end