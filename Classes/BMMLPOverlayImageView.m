//
//  OverlayImageView.m
//  GMCommon
//
//  Created by paulo on 6/21/10.
//  Copyright 2010 GlobalMotion Media, Inc. All rights reserved.
//

#import "BMMLPOverlayImageView.h"


@implementation BMMLPOverlayImageView
@synthesize overlayView;

- (void)dealloc {
	self.overlayView = nil;
}


- (void)setImage:(UIImage *)theImage {
	overlayView.hidden = (theImage == nil);
	[super setImage:theImage];
}

- (void)setOverlayView:(UIView *)theOverlayView {
	[overlayView removeFromSuperview];
	overlayView = nil;
	if (theOverlayView) {
		overlayView = theOverlayView;
		[self addSubview:overlayView];
	}
}

- (void)setImage:(UIImage *)theImage withOverlayView:(UIView *)theOverlayView {
	[self setImage:theImage];
	[self setOverlayView:theOverlayView];
}


@end
