//
//  ComBehindmediaMediaItemProxy.m
//  medialibrarypicker
//
//  Created by Werner Altewischer on 06/09/12.
//
//

#import "ComBehindmediaMediaItemProxy.h"
#import "TiUtils.h"
#import "TiBlob.h"
#import "ALAsset+BMMedia.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ComBehindmediaMediaItemProxy {
    uint8_t *buffer;
    long long offset;
}

@synthesize mediaItem, assetLibrary;

+ (ComBehindmediaMediaItemProxy *)mediaItemProxyWithMediaItem:(BMMLPMediaItem *)item {
    ComBehindmediaMediaItemProxy *proxy = [ComBehindmediaMediaItemProxy new];
    proxy.mediaItem = item;
    return proxy;
}

- (void)resetReadBuffer {
    offset = 0L;
    if (buffer) {
        free(buffer);
        buffer = nil;
    }
}

- (void)dealloc {
    [self resetReadBuffer];
    [mediaItem deleteObject];
}

- (TiFile *)fileFromPath:(NSString *)path {
    return path ? [[TiFile alloc] initWithPath:path] : nil;
}

- (TiBlob *)blobFromImage:(UIImage *)image {
    return image ? [[TiBlob alloc] initWithImage:image] : nil;
}

- (id)dataFile {
    return [self fileFromPath:self.mediaItem.filePath];
}

- (id)midSizeImageFile {
    return [self fileFromPath:self.mediaItem.midSizeImageFilePath];
}

- (id)thumbnailImageFile {
    return [self fileFromPath:self.mediaItem.thumbnailImageFilePath];
}

- (id)midSizeImage {
    return [self blobFromImage:self.mediaItem.midSizeImage];
}

- (id)thumbnailImage {
    return [self blobFromImage:self.mediaItem.thumbnailImage];
}

- (NSString *)identifier {
    return [self.mediaItem.sourceURL absoluteString];
}

- (id)readData {
    static const NSUInteger length = 1 * 1024 * 1024;
    
    ALAsset *asset = self.mediaItem.asset;
    BMMLPMIMEType *mimeType = [asset mimeType];
    
    if (!buffer) {
        buffer = malloc(sizeof(uint8_t) * length);
        offset = 0L;
    }
    
    NSUInteger bytesRead = 0;
    if (asset) {
        bytesRead = [[asset defaultRepresentation] getBytes:buffer fromOffset:offset length:length error:nil];
    }
    if (bytesRead > 0) {
        offset += bytesRead;
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:bytesRead freeWhenDone:NO];
        return [[TiBlob alloc] initWithData:data mimetype:mimeType.contentType];
    } else {
        [self resetReadBuffer];
        return nil;
    }
}

- (id)data {
    static const NSUInteger length = 1 * 1024 * 1024;
    
    [self resetReadBuffer];
    
    ALAsset *asset = self.mediaItem.asset;
    BMMLPMIMEType *mimeType = [asset mimeType];
    
    if (!buffer) {
        buffer = malloc(sizeof(uint8_t) * length);
        offset = 0L;
    }
    
    NSMutableData *data = [NSMutableData data];
    NSUInteger bytesRead = 0;
    if (asset) {
        do {
            bytesRead = [[asset defaultRepresentation] getBytes:buffer fromOffset:offset length:length error:nil];
            offset += bytesRead;
            [data appendBytes:buffer length:bytesRead];
        } while (bytesRead > 0);
    }
    
    [self resetReadBuffer];
    return [[TiBlob alloc] initWithData:data mimetype:mimeType.contentType];
}

- (id)metaData {
    return self.mediaItem.metaData;
}

- (id)mediaKind {
    return [NSNumber numberWithInt:self.mediaItem.mediaKind];
}

- (id)width {
    return [NSNumber numberWithFloat:self.mediaItem.dimensions.width];
}

- (id)height {
    return [NSNumber numberWithFloat:self.mediaItem.dimensions.height];
}

@end
