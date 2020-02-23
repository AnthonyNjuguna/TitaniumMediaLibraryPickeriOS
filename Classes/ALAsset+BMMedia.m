//
//  ALAsset+BTFD.m
//  BTFD
//
//  Created by Werner Altewischer on 16/07/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import "ALAsset+BMMedia.h"


@implementation ALAsset(Media)

- (BMMediaKind)mediaKind {
    NSString *typeString = [self valueForProperty:ALAssetPropertyType];
    BMMediaKind mediaKind = BMMediaKindUnknown;
    if ([typeString isEqual:ALAssetTypePhoto]) {
        mediaKind = BMMediaKindPicture;
    } else if ([typeString isEqual:ALAssetTypeVideo]) {
        mediaKind = BMMediaKindVideo;
    }
	return mediaKind;
}

- (BMMLPMIMEType *)mimeType {
    NSString *extension = [[self class] extensionFromAssetRepresentation:[self defaultRepresentation] withDefault:@"bin"];
    return [BMMLPMIMEType mimeTypeForFileExtension:extension];
}

+ (NSString *)extensionFromAssetRepresentation:(ALAssetRepresentation *)assetRepresentation withDefault:(NSString *)defaultExt {
    //Extract the extension from the asset URL
    //e.g.: assets-library://asset/asset.MOV?id=1000000132&ext=MOV
    NSString *assetUrl = [[[assetRepresentation url] absoluteString] lowercaseString];
    
    NSRange range = [assetUrl rangeOfString:@"ext="];
    
    NSString *ext= defaultExt;
    
    if (range.location != NSNotFound) {
        NSUInteger pos = range.location + range.length;
        NSUInteger startPos = pos;
        while (pos < assetUrl.length) {
            unichar c = [assetUrl characterAtIndex:pos];
            if (c == '&') {
                break;
            }
            pos++;
        }
        ext = [assetUrl substringWithRange:NSMakeRange(startPos, pos - startPos)];
    }
    
    return ext;
}

@end
