//
//  BusyView.h
//  FlyingBlue
//
//  Created by Werner Altewischer on 01/10/09.
//  Copyright 2010 BehindMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BMMLPMaskView.h"

@class BMMLPBusyView;

@protocol BMMLPBusyViewDelegate<NSObject>

- (void)busyViewWasCancelled:(BMMLPBusyView *)view;

@optional

- (void)busyViewWasSentToBackground:(BMMLPBusyView *)view;

@end

@interface BMMLPBusyView : BMMLPMaskView {
	UIActivityIndicatorView *activityIndicator;
	UIView *superView;
    UILabel *cancelLabel;
	UILabel *label;
	BOOL observeDeviceOrientation;
	UIProgressView *progressView;
	BOOL cancelEnabled;
	id <BMMLPBusyViewDelegate> __weak delegate;
    BOOL animateProgressBar;
    BOOL sendToBackgroundEnabled;
    UIButton *sendToBackgroundButton;
}

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UILabel *cancelLabel;
@property(nonatomic, strong) UIProgressView *progressView;
@property(nonatomic, weak) id <BMMLPBusyViewDelegate> delegate;
@property(nonatomic, assign) BOOL cancelEnabled;
@property(nonatomic, assign) BOOL sendToBackgroundEnabled;
@property(nonatomic, strong) UIButton *sendToBackgroundButton;

- (id)initWithSuperView:(UIView *)view;

- (void)setProgress:(CGFloat)progress;
- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;

@end
