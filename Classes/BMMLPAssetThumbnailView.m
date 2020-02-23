//
//  Asset.m
//
//  Created by Werner Altewischer on 2/15/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import "BMMLPAssetThumbnailView.h"
#import "BMMLPAssetTablePicker.h"
#import "BMMLPMediaThumbnailView.h"
#import "ALAsset+BMMedia.h"
#import "BMMLPStyle.h"

@implementation BMMLPAssetThumbnailView

@synthesize asset;
@synthesize delegate;
@synthesize enabled;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        assetImageView = [[BMMLPMediaThumbnailView alloc] initWithFrame:self.bounds];
		[assetImageView setContentMode:UIViewContentModeScaleToFill];
        assetImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:assetImageView];
		
		overlayView = [[UIImageView alloc] initWithFrame:self.bounds];
		[overlayView setImage:[[BMMLPStyle instance] selectionOverlayImage]];
		[overlayView setHidden:YES];
        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:overlayView];
        
        disabledOverlayView = [[UIImageView alloc] initWithFrame:self.bounds];
		[disabledOverlayView setImage:[[BMMLPStyle instance] disabledOverlayImage]];
		[disabledOverlayView setHidden:YES];
        disabledOverlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:disabledOverlayView];
        
		[self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSelection)]];
        
        [self setEnabled:YES];
    }
    return self;
}

- (BOOL)enabled {
    return disabledOverlayView.hidden;
}

- (void)setEnabled:(BOOL)e {
    [disabledOverlayView setHidden:e];
}

-(BOOL)selected {	
	return !overlayView.hidden;
}

-(void)setSelected:(BOOL)_selected {
    [overlayView setHidden:!_selected];
}

-(BOOL)toggleSelection {
    BOOL ret = NO;
    if (asset && self.enabled) {
        BOOL newStatus = ![self selected];
        if ([self.delegate respondsToSelector:@selector(assetThumbnailView:shouldChangeSelectionStatus:)]) {
            if (![self.delegate assetThumbnailView:self shouldChangeSelectionStatus:newStatus]) {
                return NO;
            }
        }
        [self setSelected:newStatus];
        if ([self.delegate respondsToSelector:@selector(assetThumbnailView:didChangeSelectionStatus:)]) {
            [self.delegate assetThumbnailView:self didChangeSelectionStatus:newStatus];
        }
        ret = YES;
    }
    return ret;
}

- (void)setAsset:(ALAsset *)_asset {
    if (asset != _asset) {
        asset = _asset;
        if (asset) {
            [assetImageView setImage:[UIImage imageWithCGImage:[asset thumbnail]]];
            [assetImageView setMediaKind:asset.mediaKind];
        } else {
            [assetImageView setImage:nil];
            [self setSelected:NO];
        }
    }
}


@end

