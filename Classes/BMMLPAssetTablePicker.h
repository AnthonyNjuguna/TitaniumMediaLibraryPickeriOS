//
//  AssetTablePicker.h
//
//  Created by Werner Altewischer on 2/15/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "BMMLPMediaContainer.h"
#import "BMMLPAssetThumbnailView.h"

@class BMMLPAssetTablePicker;

@protocol BMMLPAssetTablePickerDelegate <NSObject>

- (void)assetTablePicker:(BMMLPAssetTablePicker *)picker didFinishWithSelectedAssets:(NSArray *)assets;
- (NSUInteger)assetTablePicker:(BMMLPAssetTablePicker *)picker maxNumberOfSelectableAssetsOfKind:(BMMediaKind)kind;
- (BOOL)assetTablePicker:(BMMLPAssetTablePicker *)picker allowNewSelectionOfKind:(BMMediaKind)kind;
- (NSArray *)supportedUTIsForAssetTablePicker:(BMMLPAssetTablePicker *)picker;
- (BOOL)assetTablePicker:(BMMLPAssetTablePicker *)picker allowSelectionOfAsset:(ALAsset *)asset;

@end

typedef enum {
    BMMLPSwipeSelectionModeNone = 0,
    BMMLPSwipeSelectionModePan = 1,
    BMMLPSwipeSelectionModeLongPressPan = 2
} BMMLPSwipeSelectionMode;


@interface BMMLPAssetTablePicker : UITableViewController<BMMLPAssetThumbnailViewDelegate> {
	ALAssetsGroup *assetGroup;
	NSMutableArray *assets;
    NSArray *selectableAssets;
    NSMutableArray *photoAssets;
    NSMutableArray *videoAssets;
    NSMutableArray *selectedAssets;
    UILabel *footerLabel;
	id<BMMLPAssetTablePickerDelegate> __weak delegate;
    BMMediaKind filteredMediaKinds;
    UISegmentedControl *selectionControl;
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, weak) id<BMMLPAssetTablePickerDelegate> delegate;
@property (nonatomic, strong) ALAssetsGroup *assetGroup;
@property (nonatomic, readonly) NSArray *selectedAssets;
@property (nonatomic, assign) BMMLPSwipeSelectionMode swipeSelectionMode;

-(int)totalSelectedAssets;
-(int)totalSelectedAssetsOfKind:(BMMediaKind)mediaKind;

+ (void)setDefaultSwipeSelectionMode:(BMMLPSwipeSelectionMode)defaultSwipeSelectionMode;

@end