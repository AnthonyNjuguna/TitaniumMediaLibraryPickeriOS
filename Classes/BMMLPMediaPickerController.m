//
//  MediaPickerController.m
//  BTFD
//
//  Created by Werner Altewischer on 14/07/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import "BMMLPMediaPickerController.h"
#import "BMMLPVideo.h"
#import "BMMLPPicture.h"

@implementation BMMLPMediaPickerController

@synthesize delegate;

@synthesize maxSelectableMedia, maxSelectablePictures, maxSelectableVideos, allowMixedMediaTypes;
@synthesize pictureContainerClass, videoContainerClass, media, acceptableUTIs;

- (id)init {
	if ((self = [super init])) {
		media = [NSMutableArray new];
        pictureContainerClass = [BMMLPPicture class];
        videoContainerClass = [BMMLPVideo class];
	}
	return self;
}

- (void)dealloc {
    BM_RELEASE_SAFELY(acceptableUTIs);
    BM_RELEASE_SAFELY(media);
}

- (void)present {
    //Start fresh
	[media removeAllObjects];
}

- (BOOL)isPresented {
    return NO;
}

- (void)dismiss:(BOOL)cancelled {
    if (cancelled) {
        [self.delegate mediaPickerControllerWasCancelled:self];
    } else {
        [self.delegate mediaPickerControllerWasDismissed:self withMedia:self.media];
    }
    [media removeAllObjects];
}

- (void)maxSelectableMediaReached {
    [self.delegate mediaPickerControllerReachedMaxSelectableMedia:self];
}

- (NSArray *)media {
    return [NSArray arrayWithArray:media];
}

- (NSUInteger)mediaCount {
    return media.count;
}

- (NSUInteger)pictureCount {
    NSUInteger i = 0;
    for (id <BMMLPMediaContainer> m in media) {
        if (m.mediaKind == BMMediaKindPicture) {
            i++;
        }
    }
    return i;
}

- (NSUInteger)videoCount {
    NSUInteger i = 0;
    for (id <BMMLPMediaContainer> m in media) {
        if (m.mediaKind == BMMediaKindVideo) {
            i++;
        }
    }
    return i;
}

- (BOOL)checkSelectionLimitsForNewMediaOfKind:(BMMediaKind)kind {
    NSUInteger pictureCount = [self pictureCount];
    NSUInteger videoCount = [self videoCount];
    NSUInteger mediaCount = [self mediaCount];
    
    if ((pictureCount >= self.maxSelectablePictures && kind == BMMediaKindPicture) ||
        (videoCount >= self.maxSelectableVideos && kind == BMMediaKindVideo) ||
        (mediaCount >= self.maxSelectableMedia) ||
        (!self.allowMixedMediaTypes && pictureCount > 0 && kind == BMMediaKindVideo) ||
        (!self.allowMixedMediaTypes && videoCount > 0 && kind == BMMediaKindPicture)) {
        [self maxSelectableMediaReached];
        return NO;
    } else {
        return YES;
    }
}

@end
