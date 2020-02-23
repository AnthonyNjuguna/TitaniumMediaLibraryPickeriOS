# Com.Behindmedia.Medialibrarypicker Module

## Description

This module may be used to present a Media library picker in the style used by the native Photo library app.
Features include:

* Multiple selection of media items in thumbnail style using an overlay for selected items (checkmark)
* Filter on media type (video/photo/all) using a segmented control in the navigation bar
* Support for a maximum number of selectable media items for either videos, photos or overall. A callback is triggered when the maximum is reached which may be used to present the user with an alert.
* Support for showing only specific types of media (types specified by UTIs as used by Apple: [http://developer.apple.com/library/ios/#documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html#//apple_ref/doc/uid/TP40009259-SW1])
* Optimized performance for large media libraries (asynchronous loading, memory optimizations)
* Automatic scroll to the bottom on appear to show the most recent items first.
* Support for testing whether location services are enabled (unfortunately accessing the AssetLibrary requires location services to be enabled by Apple's policy).
* Support for customizing the navigation bar (since 1.2)
* Support for landscape orientation and iPad resolution (since 1.3)
* Support for customized images, e.g. for the background of the navigation bar and selection overlays (since 1.4)
* Support for copying raw images to retain EXIF data (since 1.5)
* Support for reading the raw asset data in chunks without having to copy it (since 1.6). This is the prefered mode if the data doesn't have to be valid beyond the lifetime of the original asset since it will save a lot of time copying data. See copyReferencesOnly.
* Support for disabling selection for some items using the disabledItemIdentifiers property (since 1.7).
* Support for getting width/height directorly from media items (since 1.8).
* Support for opening albums by default (since 1.9).
* Support for swipe to select mode to quickly select multiple images (since 1.10).

##Change log

See the CHANGELOG file included in this module.

## Accessing the medialibrarypicker Module

To access this module from JavaScript, you would do the following:

	var medialibrarypicker = require("com.behindmedia.medialibrarypicker");

The medialibrarypicker variable is a reference to the Module object.	

## Properties

### Com.Behindmedia.Medialibrarypicker.maxSelectableMedia

The maximum number of media (videos+photos) that the user may select. A 'MediaPickerReachedMaxSelectableMedia' event is transmitted if the user tries to select more media than this number. Default is unlimited (-1).

### Com.Behindmedia.Medialibrarypicker.maxSelectableVideos

The maximum number of videos that the user may select. A 'MediaPickerReachedMaxSelectableMedia' event is transmitted if the user tries to select more videos than this number. Default is unlimited (-1).

### Com.Behindmedia.Medialibrarypicker.maxSelectablePictures

The maximum number of pictures that the user may select. A 'MediaPickerReachedMaxSelectableMedia' event is transmitted if the user tries to select more pictures than this number. Default is unlimited (-1).

### Com.Behindmedia.Medialibrarypicker.allowMixedMediaTypes

Whether to allow both video and pictures to be selected together or only one of the two. Default is true.

### Com.Behindmedia.Medialibrarypicker.acceptableUTIs

See :http://developer.apple.com/library/ios/#documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html#//apple_ref/doc/uid/TP40009259-SW1 for a full list of UTIs. You may filter the assets displayed by UTI type. Only assets that contain at least one of the specified UTI types will be displayed. Defaults to all.
e.g. medialibrarypicker.acceptableUTIs = ['public.png', 'public.jpeg'];

### Com.Behindmedia.Medialibrarypicker.navigationBarTintColor

The tint color to use for the navigation bar in the picker, e.g. "#112233"

### Com.Behindmedia.Medialibrarypicker.navigationBarStyle

The style for the navigation bar to use, 0 = default, 1 = black opaque, 2 = black translucent

### Com.Behindmedia.Medialibrarypicker.navigationBarBackgroundImage

The name of the image to use for a custom background for the navigation bar. The image is scaled to the frame of the navigation bar.

### Com.Behindmedia.Medialibrarypicker.selectionOverlayImage

The name of the image to use for a custom selection overlay image for selected media items (set to nil to use the default which is a red checkmark).

### Com.Behindmedia.Medialibrarypicker.videoOverlayImage

The name of the image to use for a custom video overlay image for video items (set to nil to use the default which is a white camera icon).

### Com.Behindmedia.Medialibrarypicker.tableViewBackgroundColor

Color to use to customize the background for the tableviews (album and media pickers). Default is white.

### Com.Behindmedia.Medialibrarypicker.tableViewCellTextColor

Color to use to customize the text of the cells for the tableviews. Default is black.

### Com.Behindmedia.Medialibrarypicker.tableViewSummaryTextColor

Color to use to customize the text for the summary (showing the number of photos and videos present). Default is gray.

### Com.Behindmedia.Medialibrarypicker.tableViewSeparatorColor

Color to use for the tableview cell separators. Default is Apple default.

### Com.Behindmedia.Medialibrarypicker.navigationBarTitleTextColor

Color to use for the navigation bar title. Default is Apple default.

### Com.Behindmedia.Medialibrarypicker.navigationBarButtonTextColor

Color to use for the navigation bar buttons (iOS 7 only). Default is Apple default.

### Com.Behindmedia.Medialibrarypicker.tableViewCellSelectionStyle

The selection style to use for the tableview cells. Default is blue. Possible values are:

* UITableViewCellSelectionStyleNone=0
* UITableViewCellSelectionStyleBlue=1
* UITableViewCellSelectionStyleGray=2

### Com.Behindmedia.Medialibrarypicker.copyRawImageData

If set to true, the raw image data is copied from the asset library for pictures (video is always copied raw), so any EXIF data is retained (for the full size image).

### Com.Behindmedia.Medialibrarypicker.copyReferencesOnly

If set to true, the data of the asset is not copied, but readData should be used on the media item to read the data manually from the original asset to copy the data in chunks (see example code). The 'data' method can also be used, but this method loads all data into memory at once, so beware of excessive memory usage.
Use this mode if the data doesn't have to be valid beyond the lifetime of the original asset. The thumbnail and midsize images are still accessible.
This flag takes precedence over 'copyRawImageData'.

### Com.Behindmedia.Medialibrarypicker.swipeSelectionMode

Set to 0 to disable swiping to select multiple media with one gesture (only tapping).
Set to 1 to be able to select media in one row with a pan gesture interactively.
Set to 2 to be able to use a long press-pan gesture combination to select media in multiple rows in one go.
Set to 3 to use both selection modes 1 and 2.

## Methods

### Com.Behindmedia.Medialibrarypicker.isGlobalLocationServicesEnabled()

Returns a boolean. True if location services are enabled globally for the device, false otherwise.

### Com.Behindmedia.Medialibrarypicker.tryActivateLocationServices(string message)

This method will create an iOS CLLocationManager with the purpose set to the message argument supplied. It will try to start the location manager, thereby triggering the location services dialog. Upon denial of this dialog a 'MediaPickerLocationServicesDenied' event will be emitted.
If the current location could be successfully retrieved a 'MediaPickerLocationServicesSucceeded' event will be emitted.

### Com.Behindmedia.Medialibrarypicker.presentMediaLibraryPicker()

This method will present the media library picker modally.

### Com.Behindmedia.Medialibrarypicker.dismissMediaLibraryPicker()

This method will dismiss the modal media library picker through code. The picker can also be dismissed by the user using the Cancel or Done button.
The difference is that using this method no event is transmitted. When the user taps the Cancel button a 'MediaPickerWasCancelled' event is transmitted and when the user taps the Done button a 'MediaPickerWasDismissed' event is transmitted. 

### Com.Behindmedia.Medialibrarypicker.openAlbumAtIndex(int index)

If the index is within the bounds of albums loaded by the album table view controller and no album is currently selected, this method will open the album at the specified index.

## Events

### MediaPickerWasDismissed

This event is transmitted when the user hits the done button of the picker.
The event contains a custom property 'media' which contains an array of the media items selected.
Each media item has the following properties:

* mediaKind: integer which is 1 for photos and 2 for videos.
* thumbnailImageFile: TiFileProxy for the file that contains the thumbnail image for the media. Only valid when copyReferencesOnly is false.
* midSizeImageFile: TiFileProxy for the file that contains the mid size image for the media, which is suitable for still fullscreen display. Only valid when copyReferencesOnly is false.
* thumbnailImage: TiBlobProxy for the thumbnail image for the media.
* midSizeImage: TiBlobProxy for the mid size image for the media, which is suitable for still fullscreen display.
* dataFile: TiFileProxy for the file that contains the full size data for the media (full size picture, or video data).
* metaData: A dictionary describing the metaData containing EXIF info (is only filled for pictures).

### MediaPickerWasCancelled

This event is transmitted when the user hits the cancel button of the picker. The event object does not contain additional properties.

### MediaPickerReachedMaxSelectableMedia

This event is transmitted when the max number of selectable media has been reached and the user tries to select yet another media object. The event object does not contain additional properties.

### MediaPickerLocationServicesSucceeded

This event is transmitted when a location update was successfully received. The event object does not contain additional properties.

### MediaPickerLocationServicesDenied

This event is transmitted when the location update failed because the user denied the location dialog. The event object does not contain additional properties.

### MediaPickerDidLoadAlbums

This event is transmitted when the album table view controller has loaded its albums. The array of albums that were loaded is supplied to this callbacks in the custom 'albums' property.
Each album contains the following properties (see Apple's ALAssetsGroup documentation for the description of these properties):

* name: name of the album
* type: type of the album
* persistentID: persistent ID of the album
* url: URL of the album

## Localized strings

This module uses the following NSLocalizedStrings which may be translated to other languages by adding "<message>" = "<translation>"; to a localizable.strings file in the bundle. See iOS documentation on localizable strings for more info.

* "Loading..."
* "Album error"
* "Albums"
* "Tap to cancel"
* "All"
* "Photos"
* "Videos"
* "Pick Media"
* "photos"
* "videos"
* "Continue in background"
* "Cancel"
* "OK"
* "Yes"
* "No"
* "Copying media..."

## Usage

See example app.js included in this module.

## Author

Created by Werner Altewischer, werner@behindmedia.com.

## License

Copyright(c) 2012 by BehindMedia, Inc. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.
