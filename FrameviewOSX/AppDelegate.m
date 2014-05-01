//
//  AppDelegate.m
//  FrameviewOSX
//
//  Created by Josh Puckett on 4/1/14.
//  Copyright (c) 2014 Josh Puckett. All rights reserved.
//

#import "AppDelegate.h"
#import <WebKit/WebKit.h>
#import "CustomWebView.h"

@implementation AppDelegate
{
    BOOL isRetina;
    BOOL hasHand;
    NSImage *phoneImage;
    NSView* _centerView;
    NSView* _contentView;
    CALayer* _phoneImageLayer;
    CALayer* _centerLayer;
    NSView* _handView;
    CALayer* _handLayer;
    CALayer* _handImageLayer;
    long currentSegment;
    NSCursor* _bobble;
    
}
@synthesize window;
@synthesize prototypeWebView;
@synthesize device;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    hasHand = YES;



    //Determine isRetina
    CGFloat backingScaleFactor = self.window.screen.backingScaleFactor;
    if (backingScaleFactor == 2) {
        isRetina = true;
    } else {
        isRetina = false;
    }

    _contentView = window.contentView;

    _contentView.layer.backgroundColor = [[NSColor whiteColor] CGColor];



    //Set up the hand view
    NSImage *handImage = [NSImage imageNamed:@"hand@2x"];
    NSSize handImageSize = handImage.size;
    _handView = [[NSView alloc] initWithFrame:(NSRect){0,0,(isRetina ? handImageSize.width : handImageSize.width*2), (isRetina ? handImageSize.height : handImageSize.height * 2)}];
    _handView.wantsLayer = YES;
    _handLayer = _handView.layer;
    _handImageLayer = [CALayer layer];
    _handImageLayer.contents = [handImage layerContentsForContentsScale:backingScaleFactor];
    _handImageLayer.frame = (CGRect){0,0,(isRetina ? handImageSize.width : handImageSize.width *2), (isRetina ? handImageSize.height : handImageSize.height * 2)};
    [_handLayer addSublayer:_handImageLayer];
    [_contentView addSubview:_handView];

    //Set up the phone view
    phoneImage = [NSImage imageNamed:@"iphone_white@2x"];
    NSSize phoneImageSize = phoneImage.size;
    _centerView = [[NSView alloc] initWithFrame:(NSRect){0,0,(isRetina ? phoneImageSize.width : phoneImageSize.width*2),(isRetina ? phoneImageSize.height : phoneImageSize.height*2)}];
    _centerView.wantsLayer = YES;
    _centerLayer = _centerView.layer;
    _phoneImageLayer = [CALayer layer];
    _phoneImageLayer.contents = [phoneImage layerContentsForContentsScale:backingScaleFactor];
   // _phoneImageLayer.contentsGravity = kCAGravityResizeAspect;
    _phoneImageLayer.frame = (CGRect){0,0,(isRetina ? phoneImageSize.width : phoneImageSize.width*2),(isRetina ? phoneImageSize.height : phoneImageSize.height*2)};
    [_centerLayer addSublayer:_phoneImageLayer];
    [_contentView addSubview:_centerView];

    NSRect webViewBounds = (NSRect){0,0,(isRetina ? 320 : 640),(isRetina ? 568 : 1136)};
    webViewBounds.origin.x = ((isRetina ? phoneImageSize.width : phoneImageSize.width*2) - webViewBounds.size.width) / 2;
    webViewBounds.origin.y = ((isRetina ? phoneImageSize.height : phoneImageSize.height*2) - webViewBounds.size.height) / 2;
    prototypeWebView = [[CustomWebView alloc] initWithFrame:webViewBounds];
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

    NSImage *iphoneImage = [NSImage imageNamed:@"apple_on@2x"];
    [self contentViewBoundsDidChange:nil];
    currentSegment = [device selectedSegment];
    [device setImage:iphoneImage forSegment:currentSegment];

}




- (void)contentViewBoundsDidChange:(NSNotification*)notification
{
    [_centerView scaleUnitSquareToSize:[_centerView convertSize:(NSSize){1, 1} fromView:nil]];
    [_handView scaleUnitSquareToSize:[_handView convertSize:(NSSize){1, 1} fromView:nil]];

    NSSize contentSize = _contentView.frame.size;
    NSRect centerViewBounds = _centerView.bounds;

    CGFloat centerViewScale = (contentSize.height / (centerViewBounds.size.height + 10)) * 0.8;
    CGFloat aspectRatio = centerViewBounds.size.width / centerViewBounds.size.height;
    CGSize scaledSize;
    scaledSize.height = (centerViewBounds.size.height * centerViewScale);
    scaledSize.width = scaledSize.height * aspectRatio;

    [_centerView setFrameOrigin:(NSPoint){
        (contentSize.width - scaledSize.width) / 2,
        (contentSize.height - scaledSize.height) / 2
    }];

    [_centerView scaleUnitSquareToSize:(NSSize){centerViewScale, centerViewScale}];

    NSRect handViewBounds = _handView.bounds;
    CGFloat handViewScale = (contentSize.height / (centerViewBounds.size.height)) * 1.05;
    aspectRatio = handViewBounds.size.width / handViewBounds.size.height;
    scaledSize.height = (handViewBounds.size.height * handViewScale);
    scaledSize.width = scaledSize.height * aspectRatio;


    [_handView setFrameOrigin:(NSPoint){
        (contentSize.width - scaledSize.width)/2,
         0
    }];
        [_handView scaleUnitSquareToSize:(NSSize){handViewScale, handViewScale}];
}


#pragma mark - WebFrameLoadDelegate

- (void)setupWebView {
    if (isRetina) {
        [prototypeWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.style.webkitTransformOrigin = '0 0'; document.body.style.webkitTransform = 'scale(%f)';", 0.5]];
    }


    [prototypeWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.style.cursor = \"url('https://s3-us-west-2.amazonaws.com/tweakapp.co/Framewebview/bobble.png') 32 32, default;\"	"]];


}


- (void)webView:(WebView *)webView didClearWindowObject:(WebScriptObject *)windowObject forFrame:(WebFrame *)frame {
    [self setupWebView];
}


- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    // Called when the web view's frame has its environment set up.
    [self setupWebView];
}


-(void)windowDidEnterFullScreen:(NSNotification *)notification {
    [self contentViewBoundsDidChange:nil];
}

- (IBAction)deviceDidChange:(NSSegmentedControl *)sender {

    NSImage *iphoneOn = [NSImage imageNamed:@"apple_on@2x"];
    NSImage *iphoneOff = [NSImage imageNamed:@"apple_off@2x"];
    NSImage *androidOn = [NSImage imageNamed:@"android_on@2x"];
    NSImage *androidOff = [NSImage imageNamed:@"android_off@2x"];



    long clickedSegment = [sender selectedSegment];
    CGFloat backingScaleFactor = self.window.screen.backingScaleFactor;

    if (clickedSegment == currentSegment) {

    } else {
        NSImage *androidPhoneImage;
        if (clickedSegment == 1) {
            androidPhoneImage = [NSImage imageNamed:@"nexus@2x"];
            [device setImage:iphoneOff forSegment:0];
            [device setImage:androidOn forSegment:1];
        }
        else {
            androidPhoneImage = [NSImage imageNamed:@"iphone_white@2x"];
            [device setImage:iphoneOn forSegment:0];
            [device setImage:androidOff forSegment:1];
        }
        NSSize phoneImageSize = androidPhoneImage.size;
        [_centerView setFrame:(CGRect){0,0,(isRetina ? phoneImageSize.width : phoneImageSize.width*2),(isRetina ? phoneImageSize.height : phoneImageSize.height*2)}];
        _phoneImageLayer.contents = [androidPhoneImage layerContentsForContentsScale:backingScaleFactor];
        [_phoneImageLayer setFrame:(CGRect){0,0,(isRetina ? phoneImageSize.width : phoneImageSize.width*2),(isRetina ? phoneImageSize.height : phoneImageSize.height*2)}];

        NSRect webViewBounds = (NSRect){0,0,((clickedSegment == 1) ? (isRetina ? 360 : 720) : (isRetina ? 320 : 640)),((clickedSegment == 1) ? (isRetina ? 640 : 1280) : (isRetina ? 568 : 1136))};
        webViewBounds.origin.x = ((isRetina ? phoneImageSize.width : phoneImageSize.width*2) - webViewBounds.size.width) / 2;
        webViewBounds.origin.y = ((isRetina ? phoneImageSize.height : phoneImageSize.height*2) - webViewBounds.size.height) / 2;
        prototypeWebView.frame = webViewBounds;
        
        [self contentViewBoundsDidChange:nil];

    }
    currentSegment = [device selectedSegment];
}



- (IBAction)menuItemLogClicked:(NSMenuItem *)sender {
    WebFrame *frame = [prototypeWebView mainFrame];

    NSString *url = [[[[frame dataSource] request] URL] absoluteString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [prototypeWebView.mainFrame loadRequest:requestObj];

}

- (IBAction)menuToggleHandClicked:(NSMenuItem *)sender {
    if (hasHand) {
        [_handImageLayer removeFromSuperlayer];
        hasHand = !hasHand;
    } else {
        [_handLayer addSublayer:_handImageLayer];
        hasHand = !hasHand;
    }

}






@end