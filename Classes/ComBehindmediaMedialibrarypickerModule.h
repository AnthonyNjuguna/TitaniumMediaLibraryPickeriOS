/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"
#import "BMMLPMediaLibraryPickerController.h"
#import <CoreLocation/CoreLocation.h>

#define MEDIAPICKER_DISMISSED_EVENT @"MediaPickerWasDismissed"
#define MEDIAPICKER_REACHED_LIMIT_EVENT @"MediaPickerReachedMaxSelectableMedia"
#define MEDIAPICKER_CANCELLED_EVENT @"MediaPickerWasCancelled"
#define MEDIAPICKER_LOCATION_SERVICES_SUCCEEDED_EVENT @"MediaPickerLocationServicesSucceeded"
#define MEDIAPICKER_LOCATION_SERVICES_DENIED_EVENT @"MediaPickerLocationServicesDenied"
#define MEDIAPICKER_DID_LOAD_ALBUMS_EVENT @"MediaPickerDidLoadAlbums"

@interface ComBehindmediaMedialibrarypickerModule : TiModule<BMMLPMediaPickerControllerDelegate, CLLocationManagerDelegate>
{
    BMMLPMediaLibraryPickerController *controller;
    CLLocationManager *locationManager;
}

- (void)setMaxSelectableMedia:(id)arg;
- (void)setMaxSelectablePictures:(id)arg;
- (void)setMaxSelectableVideos:(id)arg;
- (void)setAllowMixedMediaTypes:(id)arg;
- (void)setNavigationBarTintColor:(id)arg;
- (void)setNavigationBarStyle:(id)arg;
- (void)setNavigationBarButtonTextColor:(id)arg;
- (void)setCopyReferencesOnly:(id)arg;
- (void)setDisabledItemIdentifiers:(id)arg;
- (void)setSwipeSelectionMode:(id)args;

- (void)presentMediaLibraryPicker:(id)args;
- (void)dismissMediaLibraryPicker:(id)args;

- (id)isGlobalLocationServicesEnabled:(id)arg;
- (void)tryActivateLocationServices:(id)arg;

- (void)openAlbumAtIndex:(id)args;

@end
