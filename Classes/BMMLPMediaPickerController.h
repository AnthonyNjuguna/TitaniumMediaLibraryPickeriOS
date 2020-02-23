//
//  MediaPickerController.h
//  BTFD
//
//  Created by Werner Altewischer on 14/07/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMMLPMediaContainer.h"

@class BMMLPMediaPickerController;

@protocol BMMLPMediaPickerControllerDelegate<NSObject>

- (void)mediaPickerControllerWasDismissed:(BMMLPMediaPickerController *)controller withMedia:(NSArray *)media;
- (void)mediaPickerControllerWasCancelled:(BMMLPMediaPickerController *)controller;
- (void)mediaPickerControllerReachedMaxSelectableMedia:(BMMLPMediaPickerController *)controller;

//Implement this method to present the view controller in a way which is to your liking.
//e.g. [self presentModalViewController:vc] if the delegate is another view controller.
- (void)mediaPickerController:(BMMLPMediaPickerController *)controller presentViewController:(UIViewController *)vc;
- (void)mediaPickerController:(BMMLPMediaPickerController *)controller dismissViewController:(UIViewController *)vc;

- (BOOL)mediaPickerController:(BMMLPMediaPickerController *)controller shouldAllowSelectionOfMediaWithSourceURL:(NSURL *)sourceURL;

- (void)mediaPickerController:(BMMLPMediaPickerController *)c didLoadAssetsGroups:(NSArray *)groups;

@end


@interface BMMLPMediaPickerController : NSObject {
	NSMutableArray *media;
	id <BMMLPMediaPickerControllerDelegate> __weak delegate;
    NSUInteger maxSelectablePictures;
    NSUInteger maxSelectableVideos;
    NSUInteger maxSelectableMedia;
    Class pictureContainerClass;
    Class videoContainerClass;
    BOOL allowMixedMediaTypes;
    NSArray *acceptableUTIs;
}

@property (nonatomic, weak) id <BMMLPMediaPickerControllerDelegate> delegate;

@property (nonatomic, assign) NSUInteger maxSelectablePictures;
@property (nonatomic, assign) NSUInteger maxSelectableVideos;
@property (nonatomic, assign) NSUInteger maxSelectableMedia;
@property (nonatomic, assign) BOOL allowMixedMediaTypes;

@property (nonatomic, assign) Class pictureContainerClass;
@property (nonatomic, assign) Class videoContainerClass;
@property (nonatomic, readonly) NSArray *media;
@property (nonatomic, strong) NSArray *acceptableUTIs;

- (void)dismiss:(BOOL)cancelled;
- (void)present;
- (BOOL)isPresented;
- (void)maxSelectableMediaReached;
- (BOOL)checkSelectionLimitsForNewMediaOfKind:(BMMediaKind)kind;

- (NSUInteger)videoCount;
- (NSUInteger)pictureCount;
- (NSUInteger)mediaCount;

@end
