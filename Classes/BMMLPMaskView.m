//
//  MaskView.m
//  FlyingBlue
//
//  Created by Werner Altewischer on 01/10/09.
//  Copyright 2010 BehindMedia. All rights reserved.
//

#import "BMMLPMaskView.h"


@implementation BMMLPMaskView

@synthesize imageView;

- (id)init {
	if ((self = [self initWithFrame:[[UIScreen mainScreen] bounds]])) {
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
		[self hide];
	}
	return self;
}

- (void)dealloc {
	[self.imageView removeFromSuperview];
}

- (void)hide {
	if (self.imageView) {
		[self.imageView removeFromSuperview];
	} else {
		self.alpha = 0.0;
	}
}

- (void)show {
	if (self.imageView) {
		[self addSubview:self.imageView];
	} else {
		self.alpha = 1.0;
	}
}

@end
