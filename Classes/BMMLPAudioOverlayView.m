//
//  AudioOverlayView.m
//  GMCommon
//
//  Created by paulo on 9/21/10.
//  Copyright 2010 GlobalMotion Media, Inc. All rights reserved.
//

#import "BMMLPAudioOverlayView.h"
#import "BMMLPStyle.h"

@implementation BMMLPAudioOverlayView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	int numOverlayRows = 4;
	int fillHeight = rect.size.height / numOverlayRows;
	
	UIColor *fillColor = [UIColor colorWithWhite:0.1 alpha:0.7];
	CGContextSetFillColorWithColor(context, [fillColor CGColor]);
	
	CGRect overlayRect = CGRectMake(0, rect.size.height - fillHeight, rect.size.width, fillHeight);
	CGContextFillRect(context, overlayRect);
	
	UIImage *image = [[BMMLPStyle instance] audioIconImage];
	
	CGFloat imageHeight = (int)(fillHeight * 2.0 / 3.0);
	CGFloat imageWidth = (int)(image.size.width * imageHeight / image.size.height);
	CGFloat x = (int)(rect.size.width / 16);
	CGFloat y = (int)(rect.size.height - (fillHeight + imageHeight)/2);
	
	CGContextDrawImage(context, CGRectMake(x, y, imageWidth, imageHeight), [image CGImage]);
}

@end
