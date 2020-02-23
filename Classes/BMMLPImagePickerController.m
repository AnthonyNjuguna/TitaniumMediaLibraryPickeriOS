//
//  ELCImagePickerController.m
//  ELCImagePickerDemo
//
//  Created by Werner Altewischer on 9/9/10.
//  Copyright 2010 BehindMedia. All rights reserved.
//

#import "BMMLPImagePickerController.h"
#import "BMMLPAssetThumbnailView.h"
#import "BMMLPAssetCell.h"
#import "BMMLPAssetTablePicker.h"
#import "BMMLPNavigationBar.h"

@implementation BMMLPImagePickerController {
    BMMLPAlbumPickerController *albumController;
}

@synthesize delegate, allowMixedMediaTypes, supportedUTIs;

- (id)initWithAssetsLibrary:(ALAssetsLibrary *)library {
    if ((self = [self initWithNavigationBarClass:[BMMLPNavigationBar class] toolbarClass:nil])) {
        
        albumController = [[BMMLPAlbumPickerController alloc] initWithNibName:ASSET(@"BMAlbumPickerController") bundle:nil];
        albumController.library = library;
        albumController.delegate = self;
        albumController.albumPickerDelegate = self;
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelImagePicker)];
        [albumController.navigationItem setRightBarButtonItem:cancelButton];
        
		self.navigationBar.barStyle = UIBarStyleBlack;
		self.navigationBar.translucent = YES;
                
		[self setViewControllers:[NSArray arrayWithObject:albumController]];
    }
    return self;
}

- (void)viewDidUnload {
    albumController = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    if ([self isViewLoaded]) {
        [self viewDidUnload];
    }
}

#pragma mark - Public methods

-(void)cancelImagePicker {
	if([delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
		[delegate performSelector:@selector(imagePickerControllerDidCancel:) withObject:self];
	}
}

- (void)setMaxNumberOfSelectableAssets:(NSUInteger)count ofKind:(BMMediaKind)mediaKind {
    if (!maxSelectableAssets) {
        maxSelectableAssets = [NSMutableDictionary new];
    }
    [maxSelectableAssets setObject:[NSNumber numberWithUnsignedInteger:count] forKey:[NSNumber numberWithInt:mediaKind]];
}

- (NSUInteger)maxNumberOfSelectableAssetsOfKind:(BMMediaKind)mediaKind {
    NSNumber *n = [maxSelectableAssets objectForKey:[NSNumber numberWithInt:mediaKind]];
    if (n) {
        return [n unsignedIntegerValue];
    } else {
        return NSUIntegerMax;
    }
}

- (void)openAssetsGroupAtIndex:(NSInteger)index {
    [albumController openAssetsGroupAtIndex:index];
}

#pragma mark - BMAlbumPickerControllerDelegate implementation

- (void)albumPicker:(BMMLPAlbumPickerController *)picker didFinishLoadingAssetGroups:(NSArray *)assetGroups {
    if ([self.delegate respondsToSelector:@selector(imagePickerController:didLoadAssetsGroups:)]) {
        [self.delegate imagePickerController:self didLoadAssetsGroups:assetGroups];
    }
}

#pragma mark - BMAssetTablePickerDelegate

- (void)assetTablePicker:(BMMLPAssetTablePicker *)picker didFinishWithSelectedAssets:(NSArray *)assets {
    if([delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithAssets:)]) {
		[delegate performSelector:@selector(imagePickerController:didFinishPickingMediaWithAssets:) withObject:self withObject:assets];
	}
}

- (NSUInteger)assetTablePicker:(BMMLPAssetTablePicker *)picker maxNumberOfSelectableAssetsOfKind:(BMMediaKind)kind {
    return [self maxNumberOfSelectableAssetsOfKind:kind];
}

- (BOOL)assetTablePicker:(BMMLPAssetTablePicker *)picker allowSelectionOfAsset:(ALAsset *)asset {
    return [self.delegate imagePickerController:self shouldAllowSelectionOfAsset:asset];
}

- (BOOL)assetTablePicker:(BMMLPAssetTablePicker *)picker allowNewSelectionOfKind:(BMMediaKind)kind {
    
    NSUInteger selectedVideoAssets = [picker totalSelectedAssetsOfKind:BMMediaKindVideo];
    NSUInteger selectedPictureAssets = [picker totalSelectedAssetsOfKind:BMMediaKindPicture];
    NSUInteger totalSelectedAssets = selectedVideoAssets + selectedPictureAssets;
    
    NSUInteger maxVideos = [self maxNumberOfSelectableAssetsOfKind:BMMediaKindVideo];
    NSUInteger maxPictures = [self maxNumberOfSelectableAssetsOfKind:BMMediaKindPicture];
    NSUInteger maxTotal = [self maxNumberOfSelectableAssetsOfKind:BMMediaKindUnknown];
    
    BOOL ret = YES;
    
    if ((selectedVideoAssets >= maxVideos && kind == BMMediaKindVideo) ||
        (selectedPictureAssets >= maxPictures && kind == BMMediaKindPicture) ||
        totalSelectedAssets >= maxTotal ||
        (!self.allowMixedMediaTypes && selectedPictureAssets > 0 && kind == BMMediaKindVideo) ||
        (!self.allowMixedMediaTypes && selectedVideoAssets > 0 && kind == BMMediaKindPicture)) {
        ret = NO;
    }
    
    if (!ret && [delegate respondsToSelector:@selector(imagePickerControllerReachedMaxSelectableAssets:)]) {
        [delegate imagePickerControllerReachedMaxSelectableAssets:self];
    }
    return ret;
}

- (NSArray *)supportedUTIsForAssetTablePicker:(BMMLPAssetTablePicker *)picker {
    return self.supportedUTIs;
}

@end
