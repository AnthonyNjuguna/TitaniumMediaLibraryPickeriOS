//
//  PictureDTO.m
//  BehindMediaCommons
//
//  Generated Class
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMMLPPicture.h"
#import "BMMLPUIImageToJPEGDataTransformer.h"

@implementation BMMLPPicture

- (void)setImage:(UIImage *)theImage {
    [self setData:[self dataFromImage:theImage]];
}

- (UIImage *)image {
    if (self.filePath) {
        return [UIImage imageWithContentsOfFile:self.filePath];
    } else if (self.asset) {
        return [UIImage imageWithCGImage:[self.asset.defaultRepresentation fullResolutionImage]];
    }
    return nil;
}

+ (NSString *)fileExtension {
	return @"jpg";
}

- (BMMediaKind)mediaKind {
	return BMMediaKindPicture;
}

@end
