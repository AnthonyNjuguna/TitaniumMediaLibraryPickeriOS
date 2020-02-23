//
//  MediaLibraryPickerController.h
//  BTFD
//
//  Created by Werner Altewischer on 14/07/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMMLPMediaPickerController.h"
#import "BMMLPImagePickerController.h"

@interface BMMLPMediaLibraryPickerController : BMMLPMediaPickerController<BMMLPImagePickerControllerDelegate> {
	BMMLPImagePickerController *imagePickerController;
    BOOL copyRawPictures;
    BOOL copyReferencesOnly;
}

@property (nonatomic, readonly) BMMLPImagePickerController *imagePickerController;
@property (nonatomic, readonly) ALAssetsLibrary *assetLibrary;
@property (nonatomic, assign) BOOL copyRawPictures;
@property (nonatomic, assign) BOOL copyReferencesOnly;
@property (nonatomic, assign) BOOL includeThumbnails;
@property (nonatomic, assign) BOOL includeFullScreenImages;

@end
