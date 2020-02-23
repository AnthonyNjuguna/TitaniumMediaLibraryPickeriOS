//
//  ComBehindmediaMediaItemProxy.h
//  medialibrarypicker
//
//  Created by Werner Altewischer on 06/09/12.
//
//

#import "TiProxy.h"
#import "TiFile.h"
#import "BMMLPMediaItem.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ComBehindmediaMediaItemProxy : TiProxy {
    BMMLPMediaItem *mediaItem;
    ALAssetsLibrary *assetLibrary;
}

@property (nonatomic, retain) BMMLPMediaItem *mediaItem;
@property (nonatomic, retain) ALAssetsLibrary *assetLibrary;

+ (ComBehindmediaMediaItemProxy *)mediaItemProxyWithMediaItem:(BMMLPMediaItem *)item;

@property (nonatomic, readonly) id dataFile;
@property (nonatomic, readonly) id thumbnailImageFile;
@property (nonatomic, readonly) id midSizeImageFile;
@property (nonatomic, readonly) id mediaKind;
@property (nonatomic, readonly) id metaData;
@property (nonatomic, readonly) id identifier;
@property (nonatomic, readonly) id width;
@property (nonatomic, readonly) id height;
@property (nonatomic, readonly) id thumbnailImage;
@property (nonatomic, readonly) id midSizeImage;

- (void)resetReadBuffer;
- (id)readData;

@end
