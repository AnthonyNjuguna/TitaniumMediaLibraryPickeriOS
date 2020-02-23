//
//  MediaThumbnailView.h
//  GMCommon
//
//  Created by Werner Altewischer on 26/02/10.
//  Copyright 2010 Everytrail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMMLPOverlayImageView.h"
#import "BMMLPMediaContainer.h"

@interface BMMLPMediaThumbnailView : BMMLPOverlayImageView {
	BMMediaKind mediaKind;
}

@property (nonatomic, assign) BMMediaKind mediaKind;

- (void)setImageFromMedia:(id <BMMLPMediaContainer>)media;


@end
