//
//  AlbumPickerController.h
//
//  Created by Werner Altewischer on 2/15/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "BMMLPAssetTablePicker.h"

@class BMMLPAlbumPickerController;

@protocol BMMLPAlbumPickerControllerDelegate <NSObject>

/**
 Return the index of the album to open
 */
- (void)albumPicker:(BMMLPAlbumPickerController *)picker didFinishLoadingAssetGroups:(NSArray *)assetGroups;

@end

@interface BMMLPAlbumPickerController : UITableViewController {
	NSMutableArray *assetGroups;
	NSOperationQueue *queue;
	id<BMMLPAssetTablePickerDelegate> __weak delegate;
    ALAssetsLibrary *library;
}

@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, weak) id<BMMLPAssetTablePickerDelegate> delegate;
@property (nonatomic, weak) id<BMMLPAlbumPickerControllerDelegate> albumPickerDelegate;
@property (nonatomic, strong) NSMutableArray *assetGroups;

- (void)openAssetsGroupAtIndex:(NSUInteger)index;

@end

