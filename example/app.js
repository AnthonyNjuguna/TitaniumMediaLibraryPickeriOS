// This is a test harness for your module
// You should do something interesting in this harness
// to test out the module and to provide instructions
// to users on how to use it by example.


// open a single window
var win = Ti.UI.createWindow({
                             backgroundColor:'white'
                             });
win.open();

// Insert a test button
var testButton = Titanium.UI.createButton({
                                          title: 'Show picker',
                                          image:'',
                                          width:200,
                                          height:40,
                                          top:60
                                          });


//Instantiate the library
var medialibrarypicker = require('com.behindmedia.medialibrarypicker');
Ti.API.info("module is => " + medialibrarypicker);

testButton.addEventListener('click',function(e)
                            {
                            medialibrarypicker.presentMediaLibraryPicker();
                            });

win.add(testButton);


//Default is to allow unlimited media selections (videos and/or photos), you can set limits which will allow you to receive a callback event named 'MediaPickerReachedMaxSelectableMedia' if the user is trying to select more than the maximum allowed.
//If you set the maxSelectable count to 0 for either video or pictures, you won't see the filter selection control in the navigation bar to filter the shown media.

//Total max number of items, default is unlimited (NSIntegerMax)
//medialibrarypicker.maxSelectableMedia = 3;

//Max number of videos, default is unlimited
//medialibrarypicker.maxSelectableVideos = 0;

//Max number of pictures, default is unlimited
medialibrarypicker.maxSelectablePictures = 10;

//Whether to allow both video and pictures to be selected together or only one of the two. Default is true.
//medialibrarypicker.allowMixedMediaTypes = false;

//See UINavigationBarStyle enum for possible values:

//UIBarStyleDefault          = 0,
//UIBarStyleBlack            = 1,
//UIBarStyleBlackTranslucent = 2,

//Set to 0 or 1 for non translucent bar or 2 for translucent
medialibrarypicker.navigationBarStyle = 2;

//Set the background color for the navigation bar (and tint color for buttons for iOS < 7.0).
//medialibrarypicker.navigationBarTintColor = "#888888";

//Set custom images. The following are pretty ugly but you get the idea ;-)
//medialibrarypicker.navigationBarBackgroundImage = "modules/com.behindmedia.medialibrarypicker/navbar-background.png";

//medialibrarypicker.selectionOverlayImage = "modules/com.behindmedia.medialibrarypicker/Overlay-green.png";

//medialibrarypicker.disabledOverlayImage = "modules/com.behindmedia.medialibrarypicker/DisabledOverlay.png";

//medialibrarypicker.videoOverlayImage = "modules/com.behindmedia.medialibrarypicker/icon_cam_green.png";

//Customize the color styling for the tableviews of the album picker and the media picker
//medialibrarypicker.tableViewBackgroundColor = "#333333";
//medialibrarypicker.tableViewCellTextColor = "#AAAAAA";
//medialibrarypicker.tableViewSummaryTextColor = "#FFFFFF";
//medialibrarypicker.tableViewSeparatorColor = "#000000";
//medialibrarypicker.navigationBarTitleTextColor = "#FF0000";

//iOS 7 only: represents the color for buttons on the navigation bar (e.g. for back buttons, segmented control, etc)
medialibrarypicker.navigationBarButtonTextColor = "#FFFFFF";

//UITableViewCellSelectionStyleNone=0
//UITableViewCellSelectionStyleBlue=1
//UITableViewCellSelectionStyleGray=2

//Customize the selection style for the tableview cells
//medialibrarypicker.tableViewCellSelectionStyle = 2;

//Set this to true to copy the raw picture data from the asset library (so any EXIF data will be retained)
medialibrarypicker.copyRawImageData = true;

//Set this to 0 to use no swiping to select, 1 to use immediate swipe to select and 2 using a longpress/swipe combination to select multiple media, 3 to enable all modes.
medialibrarypicker.swipeSelectionMode = 3;

//Set this to true to copy the asset by reference. The dataFile will be null so you have to handle the data yourself by calling readData() on each item repeatedly.
//Copy speed will be a lot faster because no data has to be copied, but once the original asset is removed the selected item will be invald.
//This takes precedence above copyRawImageData.
//medialibrarypicker.copyReferencesOnly = true;

//See :http://developer.apple.com/library/ios/#documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html#//apple_ref/doc/uid/TP40009259-SW1 for a full list of UTIs. You may filter the assets displayed by UTI type. Only assets that contain at least one of the specified UTI types will be displayed. Defaults to all.
//medialibrarypicker.acceptableUTIs = ['public.png', 'public.jpeg'];

//Add event listener for dismissal
medialibrarypicker.addEventListener('MediaPickerWasDismissed', function(e) {
                                    
                                    //Upon dismissal you will receive this event. It contains an array of media items, exposing the properties:
                                    //-mediaKind (1 is photo, 2 is video)
                                    //-thumbnailImageFile (File proxy to the temp file which contains the thumbnail image)
                                    //-midSizeImageFile (File proxy to the temp file which contains the mid size image, suitable for iPhone fullscreen display)
                                    //-dataFile (File proxy to the temp file which contains the data (fullsize image or video))
                                    //
                                    //You should move or copy the files or retain the data, because after this callback they will be cleaned up automatically.
                                    alert("media: " + e.media);
                                    
                                    for (var i = 0; i < e.media.length; ++i) {
                                    var mediaItem = e.media[i];
                                    alert("found: " + mediaItem.mediaKind + "," + mediaItem.thumbnailImageFile + ","  + mediaItem.midSizeImageFile + "," + mediaItem.dataFile);
                                    
                                    //Access the data with the blob method on TIFileProxy, e.g.: mediaItem.dataFile.blob;
                                    
                                    alert("blob: " + mediaItem.dataFile.blob);
                                    
                                    //Alternatively the original asset data may be read in chunks as follows:
                                    do {
                                    //readData remembers the offset untill all data has been read
                                    var blob = mediaItem.readData;
                                    if (blob == null) {
                                    //All data was read
                                    break;
                                    } else {
                                    //Handle the data in some way. Be advised that the buffer used by readData is reused so is invalid after the next call to readData.
                                    alert("blob length: " + blob.length);
                                    }
                                    } while (blob != null);
                                    
                                    //Or you can use mediaItem.data, but beware that this method loads all data into memory at once.
                                    //var blob = mediaItem.data;
                                    
                                    //Meta data, may be nil if it cannot be interpreted which may happen for some external media items.
                                    alert("meta data: " + mediaItem.metaData);
                                    alert("identifier: " + mediaItem.identifier);
                                    
                                    //Dimensions in pixels
                                    alert("width: " + mediaItem.width);
                                    alert("height: " + mediaItem.height);
                                    }
                                    
                                    
                                    });

medialibrarypicker.addEventListener('MediaPickerDidLoadAlbums', function(e) {
                                    
                                    for (var i = 0; i < e.albums.length; ++i) {
                                    var album = e.albums[i];
                                    //Valid properties: album.name, album.type, album.persistentID and album.url
                                    alert ("loaded album: " + album.name);
                                    }
                                    
                                    if (e.albums.length > 0) {
                                    //To open an album by default: uncomment the following
                                    //medialibrarypicker.openAlbumAtIndex(0);
                                    }
                                    
                                    });


medialibrarypicker.disabledItemIdentifiers = ['assets-library://asset/asset.JPG?id=37205BB9-FC24-458A-A78A-52845C2C62AE&ext=JPG'];

//Location services should be enabled to be able to use the Asset library (Media library). This is unfortunately a requirement by Apple, since media meta-data may contain the user's location
//There are two methods to check for location service enabled, which can be used:
//1. medialibrarypicker.isGlobalLocationServicesEnabled(); --> checks whether location services are enabled on the device
//2. medialibrarypicker.tryActivateLocationServices("Some message"); --> tries to activate location services for this app (requests the current location): this will result in either the 'MediaPickerLocationServicesDenied' or 'MediaPickerLocationServicesSucceeded' events being called.

//Add event listener for location services denied event, triggered by medialibrarypicker.tryActivateLocationServices() after user denies the request.
medialibrarypicker.addEventListener('MediaPickerLocationServicesDenied', function(e) {
                                    alert("User denied location services use, it is needed to access the Asset library");
                                    }
                                    );

//Add event listener for location services succeeded event, triggered by medialibrarypicker.tryActivateLocationServices() after the location is successfully retrieved.
medialibrarypicker.addEventListener('MediaPickerLocationServicesSucceeded', function(e) {
                                    alert("Successfully retrieved location");
                                    }
                                    );

//Add event listener for cancel event
medialibrarypicker.addEventListener('MediaPickerWasCancelled', function(e) {
                                    alert("Picker was cancelled");
                                    });

//Add event listener for max media items reached event
medialibrarypicker.addEventListener('MediaPickerReachedMaxSelectableMedia', function(e) {
                                    alert("Sorry you reached the maximum number of selectable media items!");
                                    });


//Test whether location services are globally
//var isLocationEnabled = medialibrarypicker.isGlobalLocationServicesEnabled();

//Try to activate location services: will result in one of the two events above to be triggered.
//var locationEnabled = medialibrarypicker.tryActivateLocationServices("Location services are needed to access the Asset library");

//Present the picker modally
//medialibrarypicker.presentMediaLibraryPicker();

//You can also dismiss the picker from code. If dismissed with this method, there will be no event transmitted (use this to dismiss the picker if needed beyond the user's control).
//medialibrarypicker.dismissMediaLibraryPicker();
