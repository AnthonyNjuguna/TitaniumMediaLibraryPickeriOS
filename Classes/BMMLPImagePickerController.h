//
//  ELCImagePickerController.h
//  ELCImagePickerDemo
//
//  Created by Werner Altewischer on 9/9/10.
//  Copyright 2010 BehindMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "BMMLPMediaContainer.h"
#import "BMMLPAssetTablePicker.h"
#import "BMMLPAlbumPickerController.h"

@interface BMMLPImagePickerController : UINavigationController<BMMLPAssetTablePickerDelegate, BMMLPAlbumPickerControllerDelegate> {
    NSMutableDictionary *maxSelectableAssets;
	id __weak delegate;
    BOOL allowMixedMediaTypes;
    NSArray *supportedUTIs;
}

@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) BOOL allowMixedMediaTypes;
@property (nonatomic, strong) NSArray *supportedUTIs;

- (id)initWithAssetsLibrary:(ALAssetsLibrary *)library;

- (void)cancelImagePicker;
- (void)setMaxNumberOfSelectableAssets:(NSUInteger)count ofKind:(BMMediaKind)mediaKind;
- (NSUInteger)maxNumberOfSelectableAssetsOfKind:(BMMediaKind)mediaKind;
- (void)openAssetsGroupAtIndex:(NSInteger)index;

@end

@protocol BMMLPImagePickerControllerDelegate

- (void)imagePickerController:(BMMLPImagePickerController *)picker didFinishPickingMediaWithAssets:(NSArray *)assets;
- (void)imagePickerControllerDidCancel:(BMMLPImagePickerController *)picker;
- (BOOL)imagePickerController:(BMMLPImagePickerController *)picker shouldAllowSelectionOfAsset:(ALAsset *)asset;

@optional
- (void)imagePickerControllerReachedMaxSelectableAssets:(BMMLPImagePickerController *)picker;
- (void)imagePickerController:(BMMLPImagePickerController *)picker didLoadAssetsGroups:(NSArray *)groups;

@end

