/*
 *  MediaContainer.h
 *  BTFD
 *
 *  Created by Werner Altewischer on 17/09/09.
 *  Copyright 2009 BehindMedia. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define BM_THUMBNAIL_FILE_EXTENSION @"jpg"

@protocol BMMLPMediaContainer;

typedef enum BMMediaKind {
	BMMediaKindUnknown = 0x0,
	BMMediaKindPicture = 0x1,
	BMMediaKindVideo = 0x2,
	BMMediaKindAudio = 0x4,
    BMMediaKindAll = 0xFF
} BMMediaKind;

@protocol BMMLPMediaContainer<NSObject>

@property (nonatomic, retain) NSDictionary *metaData;
@property (nonatomic, retain) ALAsset *asset;
@property (nonatomic, retain) NSURL *sourceURL;
@property (nonatomic, assign) CGSize dimensions;

/**
 @brief The actual media data. Kind of data depends on media
 */
- (NSData *)data;

/**
 @brief Sets the data using the file extension returned by [[self class] fileExtension].
 */
- (void)setData:(NSData *)theData;

/**
 @brief Sets the data using a custom file extension.
 */
- (void)setData:(NSData *)theData withExtension:(NSString *)extension;

/**
 @brief Uses BM_THUMBNAIL_FILE_EXTENSION as file extension.
 */
- (void)setMidSizeImageData:(NSData *)theData;
- (void)setMidSizeImageData:(NSData *)theData withExtension:(NSString *)extension;
- (NSData *)midSizeImageData;


/**
 @brief Uses BM_THUMBNAIL_FILE_EXTENSION as file extension.
 */
- (void)setThumbnailImageData:(NSData *)data;
- (void)setThumbnailImageData:(NSData *)theData withExtension:(NSString *)extension;
- (NSData *)thumbnailImageData;

/**
 @brief Default file extension for the data if none is supplied.
 */
+ (NSString *)fileExtension;

/**
 @brief Thumbnail image to display for the media
 */
- (UIImage *)thumbnailImage;
- (void)setThumbnailImage:(UIImage *)image;

/**
 @brief Midsize image to display for the media
 */
- (UIImage *)midSizeImage;
- (void)setMidSizeImage:(UIImage *)image;

/**
 @brief The kind of media (video, audio, picture)
 */
- (BMMediaKind)mediaKind;

/**
 @brief The path to the locally stored data (if cached).
 */
- (NSString *)filePath;

- (void)setDataFromFile:(NSString *)filePath;

- (void)deleteObject;

@end

@protocol BMMLPPictureContainer <BMMLPMediaContainer>

- (UIImage *)image;
- (void)setImage:(UIImage *)image;

@end

@protocol BMMLPMediaWithDurationContainer <BMMLPMediaContainer>

@property (nonatomic, retain) NSNumber *duration;

@end

@protocol BMMLPVideoContainer <BMMLPMediaWithDurationContainer>

@end

@protocol BMMLPAudioContainer <BMMLPMediaWithDurationContainer>

@end



