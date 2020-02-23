//
//  PictureDTO.h
//  BehindMediaCommons
//
//  Generated Class
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMMLPMediaItem.h"

@interface BMMLPPicture : BMMLPMediaItem<BMMLPPictureContainer> {
}

- (void)setImage:(UIImage *)theImage;
- (UIImage *)image;

@end