//
//  MediaThumbnailView.m
//  GMCommon
//
//  Created by Werner Altewischer on 26/02/10.
//  Copyright 2010 Everytrail. All rights reserved.
//

#import "BMMLPMediaThumbnailView.h"
#import "BMMLPVideoOverlayView.h"
#import "BMMLPAudioOverlayView.h"

@interface BMMLPMediaThumbnailView(Private)

- (void)setDisplayOverlay:(BOOL)overlayEnabled withViewClass:(Class)theClass;

@end

@implementation BMMLPMediaThumbnailView

@synthesize mediaKind;


- (void)setImageFromMedia:(id <BMMLPMediaContainer>)media {
    self.image = media.thumbnailImage;
	self.mediaKind = media.mediaKind;
}

- (void)setMediaKind:(BMMediaKind)theMediaKind {
	mediaKind = theMediaKind;
	Class overlayClass = nil;
	BOOL overlayEnabled = YES;
	if (mediaKind == BMMediaKindVideo) {
		overlayClass = [BMMLPVideoOverlayView class];
	} else if (mediaKind == BMMediaKindAudio) {
		// audio overlay disabled for now...
		overlayClass = [BMMLPAudioOverlayView class];
	} else {
		overlayEnabled = NO;
	}
	[self setDisplayOverlay:overlayEnabled withViewClass:overlayClass];
}

@end

@implementation BMMLPMediaThumbnailView(Private)

- (void)setDisplayOverlay:(BOOL)overlayEnabled withViewClass:(Class)theClass {
	if (theClass && overlayEnabled && ![self.overlayView isKindOfClass:theClass]) {
		self.overlayView = [[theClass alloc] 
							 initWithFrame:self.bounds];
		self.overlayView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		self.overlayView.hidden = (self.image == nil);
	} else if (!overlayEnabled && self.overlayView) {
		self.overlayView = nil;
	}
}

@end
