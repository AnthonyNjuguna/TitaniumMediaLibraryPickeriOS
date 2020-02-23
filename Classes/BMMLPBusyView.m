//
//  BusyView.m
//  FlyingBlue
//
//  Created by Werner Altewischer on 01/10/09.
//  Copyright 2010 BehindMedia. All rights reserved.
//

#import "BMMLPBusyView.h"
#import <QuartzCore/QuartzCore.h>
#import "BMMLPStyle.h"

#define BACKGROUND_VIEW_TAG 100
#define SEND_TO_BACKGROUND_BUTTON_TAG 101

@interface BMMLPBusyView(Private) 

- (void)performProgressBarAnimation;
- (void)startProgressBarAnimation;
- (void)stopProgressBarAnimation;

@end

@implementation BMMLPBusyView

@synthesize activityIndicator, label, cancelLabel, progressView, delegate, cancelEnabled, sendToBackgroundEnabled, sendToBackgroundButton;

- (void)updateLayoutForOrientation {
    CGFloat angle = 0.0;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationPortrait) {
        self.bounds = self.superview.bounds;
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        angle = M_PI;
        self.bounds = self.superview.bounds;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        angle = 3.0 * M_PI/2.0;
        self.bounds = CGRectMake(0, 0, self.superview.bounds.size.height, self.superview.bounds.size.width);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        angle = M_PI/2.0;
        self.bounds = CGRectMake(0, 0, self.superview.bounds.size.height, self.superview.bounds.size.width);
    }
    
    self.transform = CGAffineTransformMakeRotation(angle);    
    self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
}

- (void)dealloc {
    if (observeDeviceOrientation) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification 
													   object:nil];
    }
    
    if ([superView isKindOfClass:[UIWindow class]]) {
        UIWindow *window = (UIWindow *)superView;
        [window resignKeyWindow];
    }
    
}

- (id)init {
	UIWindow *modalWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	modalWindow.windowLevel = UIWindowLevelStatusBar;
	return [self initWithSuperView:modalWindow];
}

- (id)initWithSuperView:(UIView *)view {
	if ((self = [super initWithFrame:view.bounds])) {
		superView = view;
		self.alpha = 0.1;
		self.contentMode = UIViewContentModeScaleToFill;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 260, 100)];
        bgView.tag = BACKGROUND_VIEW_TAG;
		bgView.layer.cornerRadius = 8;
		bgView.clipsToBounds = NO;
		[bgView setBackgroundColor:[UIColor darkTextColor]];
		[bgView setAlpha:0.75f];
		
		bgView.contentMode = UIViewContentModeCenter;
		bgView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | 
									UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		
		//Activity indicator
		self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		self.activityIndicator.hidesWhenStopped = YES;
		self.activityIndicator.center = CGPointMake(bgView.frame.size.width/2, 20);
		
		//Label
		self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, bgView.frame.size.width, 20)];
		self.label.backgroundColor = [UIColor clearColor];
		self.label.textColor = [UIColor whiteColor];
		self.label.textAlignment = NSTextAlignmentCenter;
		[self.label setFont:[UIFont boldSystemFontOfSize:17]];
        
        self.cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, bgView.frame.size.width, 20)];
        self.cancelLabel.backgroundColor = [UIColor clearColor];
		self.cancelLabel.textColor = [UIColor grayColor];
		self.cancelLabel.textAlignment = NSTextAlignmentCenter;
		[self.cancelLabel setFont:[UIFont boldSystemFontOfSize:12]];
		
		//ProgressView
		self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
		self.progressView.hidden = YES;
		self.progressView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | 
											UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin; 
		self.progressView.center = CGPointMake(bgView.frame.size.width/2, 20);
        
        self.sendToBackgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendToBackgroundButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        
        UIImage *bgImage = [[BMMLPStyle instance] grayButtonImage];
        bgImage = [bgImage stretchableImageWithLeftCapWidth:(int)(bgImage.size.width/2) topCapHeight:(int)(bgImage.size.height/2)];

        [sendToBackgroundButton setBackgroundImage:bgImage forState:UIControlStateNormal];
        sendToBackgroundButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
        sendToBackgroundButton.tag = SEND_TO_BACKGROUND_BUTTON_TAG;
        CGFloat buttonWidth = 150;
        CGFloat buttonHeight = 30;
        [sendToBackgroundButton setFrame:CGRectMake(0,0, buttonWidth, buttonHeight)];
        [sendToBackgroundButton setTitle:NSLocalizedString(@"Continue in background", nil) forState:UIControlStateNormal];
        [sendToBackgroundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendToBackgroundButton addTarget:self action:@selector(onSendToBackground:) forControlEvents:UIControlEventTouchUpInside];
				
		CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
		bgView.center = centerPoint;
		[bgView addSubview:label];
        [bgView addSubview:cancelLabel];
		[bgView addSubview:activityIndicator];
		[bgView addSubview:progressView];
        [self addSubview:bgView];
        
        sendToBackgroundButton.center = CGPointMake(bgView.center.x, CGRectGetMaxY(bgView.frame) + 30);
        [self addSubview:sendToBackgroundButton];
        
        self.cancelEnabled = NO;
        self.sendToBackgroundEnabled = NO;
		
		[bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped:)]];
		
		observeDeviceOrientation = [superView isKindOfClass:[UIWindow class]];
		if (observeDeviceOrientation) {
		    [[NSNotificationCenter defaultCenter] addObserver:self
		                                             selector:@selector(didRotate:)
		                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
		}
	}
	return self;
}

- (void)setProgress:(CGFloat)progress {
    progress = MAX(progress, 0.01);
    self.progressView.hidden = NO;
    self.activityIndicator.hidden = YES;    
    self.progressView.progress = progress;
    [self startProgressBarAnimation];
}

- (void)showAnimated:(BOOL)animated {
	if ([superView isKindOfClass:[UIWindow class]]) {
		[(UIWindow *)superView makeKeyAndVisible];
	}
	
	[superView addSubview:self];
	
	if (observeDeviceOrientation) {
	    [self updateLayoutForOrientation];
	}
	
	[activityIndicator startAnimating];
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
	}
	[super show];
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void)hideAnimated:(BOOL)animated {
    [self stopProgressBarAnimation];
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	} 
	[super hide];
	if (animated) {
		[UIView commitAnimations];
	} else {
		[self removeFromSuperview];
	}
}

- (void)viewWasTapped:(id)sender {
	if (self.cancelEnabled) {
		[self.delegate busyViewWasCancelled:self];
	}
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID isEqual:@"PulseProgressBar"]) {
        [self performProgressBarAnimation];
    } else {
        [activityIndicator stopAnimating];
        [self removeFromSuperview];    
    }
}

- (void)didRotate:(NSNotification *)notification {
    
    [UIView beginAnimations:@"Rotate" context:nil];
    [UIView setAnimationDuration:0.4];
    
    [self updateLayoutForOrientation];
    
    [UIView commitAnimations];
}

- (void)setCancelEnabled:(BOOL)enabled {
    self.cancelLabel.hidden = !enabled;
    cancelEnabled = enabled;
}

- (void)setSendToBackgroundEnabled:(BOOL)enabled {
    self.sendToBackgroundButton.hidden = !enabled;
    sendToBackgroundEnabled = enabled;
}

@end

@implementation BMMLPBusyView(Private) 

- (void)performProgressBarAnimation {
    if (animateProgressBar) {
        float destAlpha = progressView.alpha > 0.85 ? 0.7 : 1.0;
        
        [UIView beginAnimations:@"PulseProgressBar" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        progressView.alpha = destAlpha;
        [UIView commitAnimations];    
    }
}

- (void)startProgressBarAnimation {
    if (!animateProgressBar) {
        animateProgressBar = YES;
        [self performProgressBarAnimation];    
    }
}

- (void)stopProgressBarAnimation {
    animateProgressBar = NO;
}

- (void)onSendToBackground:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(busyViewWasSentToBackground:)]) {
        [self.delegate busyViewWasSentToBackground:self];
    }
}

@end