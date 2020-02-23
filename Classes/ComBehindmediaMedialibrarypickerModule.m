/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComBehindmediaMedialibrarypickerModule.h"
#import "ComBehindmediaMediaItemProxy.h"
#import "ComBehindmediaAssetsGroupProxy.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiApp.h"
#import "TiUtils.h"
#import "BMMLPMediaLibraryPickerController.h"
#import "BMMLPNavigationBar.h"
#import "BMMLPStyle.h"

@implementation ComBehindmediaMedialibrarypickerModule

#pragma mark Private

- (NSUInteger)correctedNumericValue:(id)arg {
    int value = [TiUtils intValue:arg def:-1];
    NSUInteger correctedValue = value < 0 ? NSUIntegerMax : (NSUInteger)value;
    return correctedValue;
}

- (NSArray *)convertedMediaArray:(NSArray *)media withAssetLibrary:(ALAssetsLibrary *)library {
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:media.count];
    for (id <BMMLPMediaContainer> mc in media) {
        ComBehindmediaMediaItemProxy *proxy = [ComBehindmediaMediaItemProxy mediaItemProxyWithMediaItem:mc];
        proxy.assetLibrary = library;
        [ret addObject:proxy];
    }
    return ret;
}

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"9984509f-88ea-4f8f-9ba3-d041b6733c79";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.behindmedia.medialibrarypicker";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
    NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
    [self dismissMediaLibraryPicker:nil];
    
    locationManager.delegate = nil;
    BM_RELEASE_SAFELY(locationManager);
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
    BM_RELEASE_SAFELY(controller);
    BM_RELEASE_SAFELY(locationManager);
	// release any resources that have been retained by the module
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma Public APIs

- (void)setCopyRawImageData:(id)arg {
    ENSURE_SINGLE_ARG(arg, NSNumber);
    [self replaceValue:arg forKey:@"copyRawImageData" notification:NO];
    [self updateControllerConfig];
}

- (void)setCopyReferencesOnly:(id)arg {
    ENSURE_SINGLE_ARG(arg, NSNumber);
    [self replaceValue:arg forKey:@"copyReferencesOnly" notification:NO];
    [self updateControllerConfig];
}

- (void)setMaxSelectableMedia:(id)arg {
    
    ENSURE_SINGLE_ARG(arg, NSNumber);
    [self replaceValue:arg forKey:@"maxSelectableMedia" notification:NO];
    [self updateControllerConfig];
}

- (void)setMaxSelectablePictures:(id)arg {
    
    ENSURE_SINGLE_ARG(arg, NSNumber);
    [self replaceValue:arg forKey:@"maxSelectablePictures" notification:NO];
    [self updateControllerConfig];
}

- (void)setMaxSelectableVideos:(id)arg {
    
    ENSURE_SINGLE_ARG(arg, NSNumber);
    [self replaceValue:arg forKey:@"maxSelectableVideos" notification:NO];
    [self updateControllerConfig];
}

- (void)setAllowMixedMediaTypes:(id)arg {
    
    ENSURE_SINGLE_ARG(arg, NSNumber);
    [self replaceValue:arg forKey:@"allowMixedMediaTypes" notification:NO];
    [self updateControllerConfig];
}

- (void)setAcceptableUTIs:(id)args {
    
    ENSURE_TYPE_OR_NIL(args, NSArray);
    
    for (id arg in args) {
        ENSURE_TYPE(arg, NSString);
    }
    [self replaceValue:args forKey:@"acceptableUTIs" notification:NO];
    [self updateControllerConfig];
}

- (void)setNavigationBarTintColor:(id)arg {
    
    ENSURE_SINGLE_ARG(arg, NSObject);
    [self replaceValue:arg forKey:@"navigationBarTintColor" notification:NO];
    [self updateControllerConfig];
}

- (void)setSelectionOverlayImage:(id)arg {
    
    ENSURE_SINGLE_ARG(arg, NSString);
    
    [self replaceValue:arg forKey:@"selectionOverlayImage" notification:NO];
    
    NSString *imageName = [TiUtils stringValue:arg];
    [[BMMLPStyle instance] setSelectionOverlayImage:[UIImage imageNamed:imageName]];
}

- (void)setVideoOverlayImage:(id)arg {
    
    ENSURE_SINGLE_ARG(arg, NSString);
    
    [self replaceValue:arg forKey:@"videoOverlayImage" notification:NO];
    
    NSString *imageName = [TiUtils stringValue:arg];
    [[BMMLPStyle instance] setCameraIconImage:[UIImage imageNamed:imageName]];
}

- (void)setNavigationBarBackgroundImage:(id)arg {
    
    ENSURE_SINGLE_ARG(arg, NSString);
    
    [self replaceValue:arg forKey:@"navigationBarBackgroundImage" notification:NO];
    
    NSString *imageName = [TiUtils stringValue:arg];
    [[BMMLPStyle instance] setNavbarBackgroundImage:[UIImage imageNamed:imageName]];
    
    [self updateControllerConfig];
}

- (void)setNavigationBarStyle:(id)arg {
    
    ENSURE_SINGLE_ARG(arg, NSNumber);
    [self replaceValue:arg forKey:@"navigationBarStyle" notification:NO];
    [self updateControllerConfig];
}

- (void)setTableViewCellTextColor:(id)arg {
    ENSURE_SINGLE_ARG(arg, NSObject);
    [self replaceValue:arg forKey:@"tableViewCellTextColor" notification:NO];
    
    UIColor *c = [[TiUtils colorValue:arg] _color];
    if (c) {
        [[BMMLPStyle instance] setTableViewCellTextColor:c];
    }
}

- (void)setTableViewSummaryTextColor:(id)arg {
    ENSURE_SINGLE_ARG(arg, NSObject);
    [self replaceValue:arg forKey:@"tableViewSummaryTextColor" notification:NO];
    
    UIColor *c = [[TiUtils colorValue:arg] _color];
    if (c) {
        [[BMMLPStyle instance] setTableViewSummaryTextColor:c];
    }
}

- (void)setTableViewSeparatorColor:(id)arg {
    ENSURE_SINGLE_ARG(arg, NSObject);
    [self replaceValue:arg forKey:@"tableViewSeparatorColor" notification:NO];
    
    UIColor *c = [[TiUtils colorValue:arg] _color];
    if (c) {
        [[BMMLPStyle instance] setTableViewSeparatorColor:c];
    }
}

- (void)setTableViewBackgroundColor:(id)arg {
    ENSURE_SINGLE_ARG(arg, NSObject);
    [self replaceValue:arg forKey:@"tableViewBackgroundColor" notification:NO];
    
    UIColor *c = [[TiUtils colorValue:arg] _color];
    if (c) {
        [[BMMLPStyle instance] setTableViewBackgroundColor:c];
    }
}

- (void)setTableViewCellSelectionStyle:(id)arg {
    ENSURE_SINGLE_ARG(arg, NSNumber);
    [self replaceValue:arg forKey:@"tableViewCellSelectionStyle" notification:NO];
    
    int value = [TiUtils intValue:arg def:UITableViewCellSelectionStyleBlue];
    
    [[BMMLPStyle instance] setTableViewCellSelectionStyle:(UITableViewCellSelectionStyle)value];
}

- (void)setNavigationBarTitleTextColor:(id)arg {
    ENSURE_SINGLE_ARG(arg, NSObject);
    [self replaceValue:arg forKey:@"navigationBarTitleTextColor" notification:NO];
    [self updateControllerConfig];
}

- (void)setNavigationBarButtonTextColor:(id)arg {
    ENSURE_SINGLE_ARG(arg, NSObject);
    [self replaceValue:arg forKey:@"navigationBarButtonTextColor" notification:NO];
    [self updateControllerConfig];
}

- (void)setDisabledItemIdentifiers:(id)args {
    
    ENSURE_TYPE_OR_NIL(args, NSArray);
    
    for (id arg in args) {
        ENSURE_TYPE(arg, NSString);
    }
    [self replaceValue:args forKey:@"disabledItemIdentifiers" notification:NO];
}

- (void)setSwipeSelectionMode:(id)args {
    ENSURE_SINGLE_ARG(args, NSNumber);
    [self replaceValue:args forKey:@"swipeSelectionMode" notification:NO];
    [self updateControllerConfig];
}

- (void)updateControllerConfig {
    [self updateControllerConfig:NO];
}

- (void)updateControllerConfig:(BOOL)present {
    BOOL ios7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
    
    controller.maxSelectableMedia = [self correctedNumericValue:[self valueForKey:@"maxSelectableMedia"]];
    controller.maxSelectablePictures = [self correctedNumericValue:[self valueForKey:@"maxSelectablePictures"]];
    controller.maxSelectableVideos = [self correctedNumericValue:[self valueForKey:@"maxSelectableVideos"]];
    controller.allowMixedMediaTypes = [TiUtils boolValue:[self valueForKey:@"allowMixedMediaTypes"] def:YES];
    controller.acceptableUTIs = [self valueForKey:@"acceptableUTIs"];
    controller.copyRawPictures = [TiUtils boolValue:[self valueForKey:@"copyRawImageData"] def:NO];
    controller.copyReferencesOnly = [TiUtils boolValue:[self valueForKey:@"copyReferencesOnly"] def:NO];
    
    int swipeSelectionMode = [TiUtils intValue:[self valueForKey:@"swipeSelectionMode"] def:0];
    [BMMLPAssetTablePicker setDefaultSwipeSelectionMode:(BMMLPSwipeSelectionMode)swipeSelectionMode];
    
    if (present) {
        [controller present];
    }
    
    UIColor *c = [[TiUtils colorValue:[self valueForKey:@"navigationBarTintColor"]] _color];
    if (c) {
        if (ios7) {
            controller.imagePickerController.navigationBar.barTintColor = c;
        } else {
            controller.imagePickerController.navigationBar.tintColor = c;
        }
    }
    
    int barStyle = [TiUtils intValue:[self valueForKey:@"navigationBarStyle"] def:-1];
    if (barStyle >= 0) {
        controller.imagePickerController.navigationBar.barStyle = barStyle;
        controller.imagePickerController.navigationBar.translucent = (barStyle == UIBarStyleBlackTranslucent);
    }
    
    NSString *imageName = [TiUtils stringValue:[self valueForKey:@"navigationBarBackgroundImage"]];
    UIImage *image = [UIImage imageNamed:imageName];
    if (image) {
        ((BMMLPNavigationBar *)controller.imagePickerController.navigationBar).backgroundImage = image;
    }
    
    c = [[TiUtils colorValue:[self valueForKey:@"navigationBarTitleTextColor"]] _color];
    if (c) {
        if ([controller.imagePickerController.navigationBar respondsToSelector:@selector(setTitleTextAttributes:)]) {
            NSDictionary *attributes = @{UITextAttributeTextColor : c};
            controller.imagePickerController.navigationBar.titleTextAttributes = attributes;
        }
    }
    
    c = [[TiUtils colorValue:[self valueForKey:@"navigationBarButtonTextColor"]] _color];
    if (ios7) {
        controller.imagePickerController.navigationBar.tintColor = c;
    }
}

-(void)presentMediaLibraryPicker:(id)args {
    ENSURE_UI_THREAD_1_ARG(args);
    if (!controller) {
        controller = [BMMLPMediaLibraryPickerController new];
        controller.delegate = self;
        [self updateControllerConfig:YES];
    }
}

- (void)dismissMediaLibraryPicker:(id)args {
    ENSURE_UI_THREAD_1_ARG(args);
    if (controller) {
        controller.delegate = nil;
        [controller dismiss:NO];
        BM_AUTORELEASE_SAFELY(controller);
    }
}

- (void)openAlbumAtIndex:(id)arg {
    ENSURE_UI_THREAD_1_ARG(arg);
    if (controller) {
        ENSURE_SINGLE_ARG(arg, NSNumber);
        NSInteger index = [TiUtils intValue:arg];
        [controller.imagePickerController openAssetsGroupAtIndex:index];
    }
}

- (id)isGlobalLocationServicesEnabled:(id)arg {
    ENSURE_ARG_COUNT(arg, 0);
    BOOL ret = [CLLocationManager locationServicesEnabled];
    return [NSNumber numberWithBool:ret];
}

- (void)tryActivateLocationServices:(id)arg {
    ENSURE_UI_THREAD_1_ARG(arg);
    ENSURE_SINGLE_ARG_OR_NIL(arg, NSString);
    NSString *message = arg;
    
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [locationManager setPurpose:message];
        [locationManager startUpdatingLocation];
    }
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (locationManager == manager) {
        [locationManager stopUpdatingLocation];
        NSString *eventName = MEDIAPICKER_LOCATION_SERVICES_SUCCEEDED_EVENT;
        if ([self _hasListeners:eventName]) {
            [self fireEvent:eventName];
        }
        BM_AUTORELEASE_SAFELY(locationManager);
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (locationManager == manager) {
        [locationManager stopUpdatingLocation];
        if ([error code] == kCLErrorDenied) {
            NSString *eventName = MEDIAPICKER_LOCATION_SERVICES_DENIED_EVENT;
            if ([self _hasListeners:eventName]) {
                [self fireEvent:eventName];
            }
        } else {
            //Other error: but location permission has been given
            NSString *eventName = MEDIAPICKER_LOCATION_SERVICES_SUCCEEDED_EVENT;
            if ([self _hasListeners:eventName]) {
                [self fireEvent:eventName];
            }
        }
        BM_AUTORELEASE_SAFELY(locationManager);
    }
}

#pragma mark BMMediaPickerControllerDelegate implementation

- (void)mediaPickerControllerWasDismissed:(BMMLPMediaLibraryPickerController *)c withMedia:(NSArray *)media {
    if (c == controller) {
        NSString *eventName = MEDIAPICKER_DISMISSED_EVENT;
        if ([self _hasListeners:eventName]) {
            NSArray *selectedMedia = [self convertedMediaArray:controller.media withAssetLibrary:c.assetLibrary];
            NSDictionary *properties = [NSDictionary dictionaryWithObject:selectedMedia forKey:@"media"];
            [self fireEvent:eventName withObject:properties];
        }
        BM_AUTORELEASE_SAFELY(controller);
    }
}

- (void)mediaPickerControllerWasCancelled:(BMMLPMediaPickerController *)c {
    if (c == controller) {
        NSString *eventName = MEDIAPICKER_CANCELLED_EVENT;
        if ([self _hasListeners:eventName]) {
            [self fireEvent:eventName];
        }
        BM_AUTORELEASE_SAFELY(controller);
    }
}

- (void)mediaPickerControllerReachedMaxSelectableMedia:(BMMLPMediaPickerController *)c {
    if (c == controller) {
        NSString *eventName = MEDIAPICKER_REACHED_LIMIT_EVENT;
        if ([self _hasListeners:eventName]) {
            [self fireEvent:eventName];
        }
    }
}

- (void)mediaPickerController:(BMMLPMediaPickerController *)controller presentViewController:(UIViewController *)vc {
    [[TiApp app] showModalController:vc animated:YES];
}

- (void)mediaPickerController:(BMMLPMediaPickerController *)controller dismissViewController:(UIViewController *)vc {
    [vc dismissModalViewControllerAnimated:YES];
}

- (BOOL)mediaPickerController:(BMMLPMediaPickerController *)c shouldAllowSelectionOfMediaWithSourceURL:(NSURL *)sourceURL {
    NSArray *disabledURLs = [self valueForKey:@"disabledItemIdentifiers"];
    if (c == controller) {
        return ![disabledURLs containsObject:[sourceURL absoluteString]];
    }
    return YES;
}

- (void)mediaPickerController:(BMMLPMediaPickerController *)c didLoadAssetsGroups:(NSArray *)groups {
    if (c == controller) {
        NSString *eventName = MEDIAPICKER_DID_LOAD_ALBUMS_EVENT;
        if ([self _hasListeners:eventName]) {
            
            NSMutableArray *albums = [NSMutableArray array];
            for (ALAssetsGroup *group in groups) {
                [albums addObject:[ComBehindmediaAssetsGroupProxy assetsGroupProxyWithAssetsGroup:group]];
            }
            NSDictionary *properties = [NSDictionary dictionaryWithObject:albums forKey:@"albums"];
            [self fireEvent:eventName withObject:properties];
        }
    }
}

@end
