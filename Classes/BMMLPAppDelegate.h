//
//  BMAppDelegate.h
//  BMCommons
//
//  Created by Werner Altewischer on 21/02/12.
//  Copyright (c) 2012 BehindMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMMLPBusyView.h"

@interface BMMLPAppDelegate : NSObject<BMMLPBusyViewDelegate> {
    UIWindow *window;
	BMMLPBusyView *busyView;
}

+ (BMMLPAppDelegate *)instance;

//Modal semi-transparent busy view
- (BMMLPBusyView *)showBusyView;
- (BMMLPBusyView *)showBusyViewAnimated:(BOOL)animated cancelEnabled:(BOOL)cancelEnabled;
- (BMMLPBusyView *)showBusyViewWithMessage:(NSString *)message;
- (BMMLPBusyView *)showBusyViewWithMessage:(NSString *)message andProgress:(CGFloat)progress;
- (BMMLPBusyView *)showBusyViewAnimated:(BOOL)animated;
- (BMMLPBusyView *)showBusyViewWithMessage:(NSString *)message animated:(BOOL)animated;
- (BMMLPBusyView *)busyView;
- (void)hideBusyView;
- (void)hideBusyViewAnimated:(BOOL)animated;

//+ (void)installTestVideo;

@end
