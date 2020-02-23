//
//  BMAppDelegate.m
//  BMCommons
//
//  Created by Werner Altewischer on 21/02/12.
//  Copyright (c) 2012 BehindMedia. All rights reserved.
//

#import "BMMLPAppDelegate.h"


@implementation BMMLPAppDelegate

static BMMLPAppDelegate *instance = nil;

#pragma mark -
#pragma mark Initialization and deallocation

+ (BMMLPAppDelegate *)instance {
    if (instance == nil) {
        instance = [BMMLPAppDelegate new];
    }
    return instance;
}

- (id)init {
	if ((self = [super init])) {
	}
	return self;
}

- (void)dealloc {
    BM_RELEASE_SAFELY(window);
}

#pragma mark -
#pragma mark BusyView

- (BMMLPBusyView *)showBusyViewAnimated:(BOOL)animated cancelEnabled:(BOOL)cancelEnabled {
    BMMLPBusyView *bv = [self showBusyViewAnimated:animated];
    bv.cancelEnabled = cancelEnabled;
    if (cancelEnabled) {
        bv.delegate = self;
    }
    return bv;
}

- (BMMLPBusyView *)showBusyView {
    return [self showBusyViewAnimated:YES];
}

- (BMMLPBusyView *)showBusyViewAnimated:(BOOL)animated {
    return [self showBusyViewWithMessage:NSLocalizedString(@"Loading...", nil) animated:animated];
}

- (BMMLPBusyView *)showBusyViewWithMessage:(NSString *)message {
    return [self showBusyViewWithMessage:message animated:YES];
}

- (BMMLPBusyView *)showBusyViewWithMessage:(NSString *)message animated:(BOOL)animated {
    if (!busyView) {
        UIWindow *theWindow = [[UIApplication sharedApplication] keyWindow];
        if (theWindow != window) {
            window = theWindow;
        }
		busyView = [[BMMLPBusyView alloc] init];
		busyView.label.text = message;
        busyView.cancelLabel.text = NSLocalizedString(@"Tap to cancel", nil);
		[busyView showAnimated:animated];
	} else {
		busyView.label.text = message;
		busyView.progressView.hidden = YES;
	}
	return busyView;
}

- (BMMLPBusyView *)showBusyViewWithMessage:(NSString *)message andProgress:(CGFloat)progress {
    if (message == nil) {
        message = self.busyView.label.text;
    }
    BMMLPBusyView *bv = [self showBusyViewWithMessage:message];
	[bv setProgress:progress];
	return bv;
}

- (BMMLPBusyView *)busyView {
    return busyView;
}

- (void)hideBusyView {
	[self hideBusyViewAnimated:YES];
}

- (void)hideBusyViewAnimated:(BOOL)animated {
	if (busyView) {
		[busyView hideAnimated:animated];
		BM_RELEASE_SAFELY(busyView);
	}
    [window makeKeyWindow];
    BM_RELEASE_SAFELY(window);
}

- (void)busyViewWasCancelled:(BMMLPBusyView *)theBusyView {
}

/*
+ (void)installTestVideo {
    NSData *imageData = [NSData dataWithContentsOfFile:@"/Users/werneraltewischer/Downloads/sample_iTunes.mov"];
    NSString *tempPath = [NSString stringWithFormat:@"%@/temp.mov", NSTemporaryDirectory()];
    [imageData writeToFile:tempPath atomically:NO];
    UISaveVideoAtPathToSavedPhotosAlbum (tempPath, self, @selector(video:didFinishSavingWithError: contextInfo:), nil);
    
}

+ (void) video: (NSString *) videoPath
didFinishSavingWithError: (NSError *) error
   contextInfo: (void *) contextInfo {
    NSLog(@"Finished saving video with error: %@", error);
}
*/

@end
