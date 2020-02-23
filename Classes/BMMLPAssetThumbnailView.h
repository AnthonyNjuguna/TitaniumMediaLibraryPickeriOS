//
//  Asset.h
//
//  Created by Werner Altewischer on 2/15/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class BMMLPAssetThumbnailView;
@class BMMLPMediaThumbnailView;

@protocol BMMLPAssetThumbnailViewDelegate <NSObject>

@optional
- (BOOL)assetThumbnailView:(BMMLPAssetThumbnailView *)asset shouldChangeSelectionStatus:(BOOL)selected;
- (void)assetThumbnailView:(BMMLPAssetThumbnailView *)asset didChangeSelectionStatus:(BOOL)selected;

@end

@interface BMMLPAssetThumbnailView : UIView {
	ALAsset *asset;
	UIImageView *overlayView;
    UIImageView *disabledOverlayView;
    BMMLPMediaThumbnailView *assetImageView;
    id <BMMLPAssetThumbnailViewDelegate> __weak delegate;
}

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, weak) id<BMMLPAssetThumbnailViewDelegate> delegate;

-(BOOL)selected;
-(void)setSelected:(BOOL)_selected;

-(BOOL)toggleSelection;

@end