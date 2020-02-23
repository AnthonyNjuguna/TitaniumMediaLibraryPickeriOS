//
//  MediaLibraryPickerController.m
//  BTFD
//
//  Created by Werner Altewischer on 14/07/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import "BMMLPMediaLibraryPickerController.h"
#import "BMMLPAlbumPickerController.h"
#import "ALAsset+BMMedia.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BMMLPFileHelper.h"
#import "BMMLPApplicationHelper.h"
#import "BMMLPDialogHelper.h"
#import "BMMLPAppDelegate.h"
#import "BMMLPImagePickerController.h"

@interface BMMLPMediaLibraryPickerController(Private)

+ (NSArray *)copyAssets:(NSArray *)assets withPictureContainerClass:(Class)pictureContainerClass videoContainerClass:(Class)videoContainerClass copyReferencesOnly:(BOOL)copyReferencesOnly copyRawPictures:(BOOL)copyRawPictures includeThumbnails:(BOOL)includeThumbnails includeFullScreenImages:(BOOL)includeFullScreenImages progressBlock:(void (^)(float progress))progressBlock;

- (void)addMedia:(NSArray *)theMedia;

@end

@implementation BMMLPMediaLibraryPickerController {
    ALAssetsLibrary *assetLibrary;
}

@synthesize imagePickerController, copyRawPictures, copyReferencesOnly, assetLibrary, includeThumbnails, includeFullScreenImages;

- (id)init {
    if ((self = [super init])) {
        self.includeThumbnails = YES;
        self.includeFullScreenImages = YES;
	}
	return self;
}

- (void)dealloc {
	imagePickerController.delegate = nil;
	BM_RELEASE_SAFELY(imagePickerController);
    BM_RELEASE_SAFELY(assetLibrary);
    
}

- (void)present {
	if (!imagePickerController) {
		[super present];
		
        if (!assetLibrary) {
            assetLibrary = [[ALAssetsLibrary alloc] init];
        }
        
		imagePickerController = [[BMMLPImagePickerController alloc] initWithAssetsLibrary:assetLibrary];
		imagePickerController.delegate = self;
        
        [imagePickerController setMaxNumberOfSelectableAssets:self.maxSelectablePictures ofKind:BMMediaKindPicture];
        [imagePickerController setMaxNumberOfSelectableAssets:self.maxSelectableVideos ofKind:BMMediaKindVideo];
        [imagePickerController setMaxNumberOfSelectableAssets:self.maxSelectableMedia ofKind:BMMediaKindUnknown];
        imagePickerController.allowMixedMediaTypes = self.allowMixedMediaTypes;
        imagePickerController.supportedUTIs = self.acceptableUTIs;
        [self.delegate mediaPickerController:self presentViewController:imagePickerController];
	}
}

- (BOOL)isPresented {
    return imagePickerController != nil;
}

- (void)dismiss:(BOOL)cancelled {
    [self.delegate mediaPickerController:self dismissViewController:imagePickerController];
	imagePickerController.delegate = nil;
	BM_RELEASE_SAFELY(imagePickerController);
	[super dismiss:cancelled];
}

#pragma mark -
#pragma mark BMImagePickerControllerDelegate implementation

- (void)imagePickerController:(BMMLPImagePickerController *)picker didFinishPickingMediaWithAssets:(NSArray *)assets {
	[[BMMLPAppDelegate instance] showBusyViewWithMessage:NSLocalizedString(@"Copying media...", nil) andProgress:0];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *copiedMedia = [[self class] copyAssets:assets withPictureContainerClass:self.pictureContainerClass videoContainerClass:self.videoContainerClass
                                         copyReferencesOnly:self.copyReferencesOnly copyRawPictures:self.copyRawPictures includeThumbnails:self.includeThumbnails includeFullScreenImages:self.includeFullScreenImages progressBlock:^(float progress) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [[BMMLPAppDelegate instance] showBusyViewWithMessage:NSLocalizedString(@"Copying media...", nil) andProgress:progress];
                                             });
                                         }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addMedia:copiedMedia];
            [[BMMLPAppDelegate instance] hideBusyView];
            [self dismiss:NO];
		});
    });
}

- (void)imagePickerControllerDidCancel:(BMMLPImagePickerController *)picker {
	[self dismiss:YES];
}

- (void)imagePickerControllerReachedMaxSelectableAssets:(BMMLPImagePickerController *)picker {
    [self maxSelectableMediaReached];
}

- (BOOL)imagePickerController:(BMMLPImagePickerController *)picker shouldAllowSelectionOfAsset:(ALAsset *)asset {
    BOOL ret = YES;
    if ([self.delegate respondsToSelector:@selector(mediaPickerController:shouldAllowSelectionOfMediaWithSourceURL:)]) {
        ret = [self.delegate mediaPickerController:self shouldAllowSelectionOfMediaWithSourceURL:[asset defaultRepresentation].url];
    }
    return ret;
}

- (void)imagePickerController:(BMMLPImagePickerController *)picker didLoadAssetsGroups:(NSArray *)groups {
    if ([self.delegate respondsToSelector:@selector(mediaPickerController:didLoadAssetsGroups:)]) {
        [self.delegate mediaPickerController:self didLoadAssetsGroups:groups];
    }
}

@end

@implementation BMMLPMediaLibraryPickerController(Private)

- (void)addMedia:(NSArray *)theMedia {
    [media addObjectsFromArray:theMedia];
}

+ (NSError *)copyAsset:(ALAssetRepresentation *)assetRepresentation toStream:(NSOutputStream *)fos withProgressBlock:(void (^)(NSUInteger doneCount, NSUInteger totalCount))block {
    NSUInteger totalLength = [assetRepresentation size];
    NSUInteger length = totalLength;
    NSUInteger bufferSize = 1024 * 1024;
    NSUInteger offset = 0;
    
    uint8_t *buffer = malloc(sizeof(uint8_t) * bufferSize);
    NSError *error = nil;
    
    [fos open];
    
    while (length > 0) {
        NSUInteger bytesRead = [assetRepresentation getBytes:buffer fromOffset:offset length:bufferSize error:&error];
        
        if (bytesRead == 0) {
            break;
        } else {
            [fos write:buffer maxLength:bytesRead];
        }
        
        offset += bytesRead;
        if (length > bytesRead) {
            length -= bytesRead;
        } else {
            length = 0;
        }
        
        if (block != nil) block(offset, totalLength);
    }
    [fos close];
    free(buffer);
    return error;
}

+ (NSString *)copyAssetToTempFile:(ALAssetRepresentation *)assetRepresentation withProgressBlock:(void (^)(float progress))progressBlock andProgress:(CGFloat)progress andCount:(NSUInteger)count defaultExtension:(NSString *)defaultExtension {
    NSString *ext = [ALAsset extensionFromAssetRepresentation:assetRepresentation withDefault:defaultExtension];
    NSString *tempFilePath = [BMMLPFileHelper uniqueTempFileWithExtension:ext];
    NSOutputStream *fos = [[NSOutputStream alloc] initToFileAtPath:tempFilePath append:NO];
    
    NSError *error = [self copyAsset:assetRepresentation toStream:fos withProgressBlock:^(NSUInteger offset, NSUInteger totalLength) {
        
        CGFloat incrementalProgress = offset;        
        incrementalProgress /= count;
        incrementalProgress /= totalLength;
        
        if (progressBlock) {
            progressBlock(progress + incrementalProgress);
        }
    }];
    
    if (error) {
        //Error occured
        LogWarn(@"Could not read bytes from asset: %@: %@", assetRepresentation, error);
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:tempFilePath error:nil];
        return nil;
    } else {
        return tempFilePath;
    }
}

+ (NSArray *)copyAssets:(NSArray *)assets withPictureContainerClass:(Class)pictureContainerClass videoContainerClass:(Class)videoContainerClass copyReferencesOnly:(BOOL)copyReferencesOnly copyRawPictures:(BOOL)copyRawPictures includeThumbnails:(BOOL)includeThumbnails includeFullScreenImages:(BOOL)includeFullScreenImages progressBlock:(void (^)(float progress))progressBlock {
    
    NSMutableArray *media = [NSMutableArray array];
    CGFloat progress = 0.0;
    NSUInteger count = assets.count;
    NSUInteger counter = 0;
    for (ALAsset *asset in assets) {
        @autoreleasepool {
            ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
            NSDictionary *metaData = [assetRepresentation metadata];
            
            id <BMMLPMediaContainer> theMedia = nil;
            
            if (asset.mediaKind == BMMediaKindPicture) {
                
                //Following code enables saving of full size image
                
                theMedia = [pictureContainerClass new];
                
                if (copyReferencesOnly) {
                    
                    id <BMMLPPictureContainer> picture = [pictureContainerClass new];
                    theMedia = picture;
                    
                } else if (copyRawPictures) {
                    
                    NSString *tempFilePath = [self copyAssetToTempFile:assetRepresentation
                                                          withProgressBlock:progressBlock
                                                            andProgress:progress
                                                              andCount:count
                                                      defaultExtension:@"jpg"];
                    
                    if (tempFilePath) {
                        id <BMMLPPictureContainer> picture = [pictureContainerClass new];
                        [picture setDataFromFile:tempFilePath];
                        theMedia = picture;
                    }
                    
                } else {
                    UIImageOrientation assetOrientation = (UIImageOrientation) [[asset valueForProperty:ALAssetPropertyOrientation] intValue];
                    UIImage *fullResImage = [[UIImage alloc] initWithCGImage:[assetRepresentation fullResolutionImage] scale:1.0 orientation:assetOrientation];
                    
                    if (!fullResImage){
                        LogWarn(@"Could not read bytes from picture asset: %@", asset);
                    } else {
                        id <BMMLPPictureContainer> pic = [pictureContainerClass new];
                        [pic setImage:fullResImage];
                        theMedia = pic;
                    }
                }
                
            } else if (asset.mediaKind == BMMediaKindVideo) {
                
                id <BMMLPVideoContainer> video = [videoContainerClass new];
                if (!copyReferencesOnly) {
                    NSString *tempFilePath = [self copyAssetToTempFile:assetRepresentation
                                                          withProgressBlock:progressBlock
                                                           andProgress:progress
                                                              andCount:count
                                                      defaultExtension:@"mov"];
                    
                    if (tempFilePath) {
                        [video setDataFromFile:tempFilePath];
                    } else {
                        video = nil;
                    }
                }
                NSNumber *duration = [asset valueForProperty:ALAssetPropertyDuration];
                video.duration = duration;
                theMedia = video;
            }
            
            if (theMedia) {
                theMedia.asset = asset;
                theMedia.sourceURL = assetRepresentation.url;
                theMedia.metaData = metaData;
                
                CGSize dimensions = CGSizeZero;
                UIImage *fullscreenImage = nil;
                
                if (includeFullScreenImages && !copyReferencesOnly) {
                    fullscreenImage = [[UIImage alloc] initWithCGImage:[assetRepresentation fullScreenImage] scale:[assetRepresentation scale] orientation:(UIImageOrientation)[assetRepresentation orientation]];
                    
                    //TODO: the line below was needed for iOS 4 but results in a rotated image in iOS 5: figure out what the deal is there
                    //UIImage *rotatedImage = [BMImageHelper rotateImage:fullscreenImage];
                    
                    UIImage *rotatedImage = fullscreenImage;
                    
                    [theMedia setMidSizeImage:rotatedImage];
                }
                
                if (includeThumbnails && !copyReferencesOnly) {
                    UIImage *thumbnailImage = [[UIImage alloc] initWithCGImage:[asset thumbnail]];
                    [theMedia setThumbnailImage:thumbnailImage];
                }
                
                if ([assetRepresentation respondsToSelector:@selector(dimensions)]) {
                    dimensions = assetRepresentation.dimensions;
                } else if (fullscreenImage) {
                    dimensions = fullscreenImage.size;
                }
                
                theMedia.dimensions = dimensions;
                [media addObject:theMedia];
            }
            counter++;
            progress = counter/((CGFloat)count);
            
            if (progressBlock) {
                progressBlock(progress);
            }
        
        }
    }
    return media;
}

@end


