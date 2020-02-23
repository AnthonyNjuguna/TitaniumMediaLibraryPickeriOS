Version 1.12
-------------

- Added 64 bit support.

Version 1.11
-------------

- Crash fixes on some iOS versions.
- Added swipe to select mode immediate horizontal pan gesture.

Version 1.10
-------------

- Added swipe to select mode long-press + pan gesture.

Version 1.9.2
-------------

- Improved speed of copying when copyReferencesOnly is set to true.
- Added midSizeImage and thumbnailImage properties to media item to retrieve a blob containing the respective image for that media item. Compare with midSizeImageFile and thumbnailImageFile which returns a file object.

Version 1.9.1
-------------

- Bugfix for issue where dismiss event is not always called.

Version 1.9
-------------

- Added event 'MediaPickerDidLoadAlbums' to get a callback when albums are loaded.
- Added method 'openAlbumAtIndex(int)' to open an album by default

Version 1.8
-------------

- Added width and height properties on media item.
- Built for iOS 7.
- Added property navigationBarButtonTextColor to change the color of the buttons in the navigation bar under iOS 7.x

Version 1.7
-------------

- Added the possibility to disable items for selection using the disabledItemIdentifiers property.

Version 1.6.2
-------------

- Fixed the content type in the blobs returned from mediaItem.data and mediaItem.readData to reflect the content type of the underlying asset. Before this version the content type was always "application/octet-stream".


Version 1.6.1
-------------

- Added a .data method on mediaItem which returns all of the data of that item in a single blob. Compare with readData which returns only part of the data to avoid running into memory problems. View app.js for an example.


Version 1.6
-------------

- Support for reading the raw asset data in chunks without having to copy it via the boolean copyReferencesOnly. This is the prefered mode if the data doesn't have to be valid beyond the lifetime of the original asset since it will save a lot of time copying data.


Version 1.5
-------------

- Support for copying raw images to retain EXIF data via the boolean copyRawImageData.


Version 1.4
-------------

- Support for customizable styling.

Version 1.3
-------------

- Support for landscape orientation and iPad resolution.


Version 1.2
------------

- Support for customizing the navigation bar.


