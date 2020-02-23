//
//  AttachmentDTO.h
//  BehindMediaCommons
//
//  Generated Class
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMMLPMediaContainer.h"

@interface BMMLPMediaItem : NSObject<BMMLPMediaContainer> {
    NSString *filePath;
    NSString *midsizeImageFilePath;
    NSString *thumbnailImageFilePath;
    NSDictionary *metaData;
    ALAsset *asset;
    NSURL *sourceURL;
}

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *midSizeImageFilePath;
@property (nonatomic, strong) NSString *thumbnailImageFilePath;
@property (nonatomic, strong) NSURL *sourceURL;

//Helper method
- (NSData *)dataFromImage:(UIImage *)image;

@end