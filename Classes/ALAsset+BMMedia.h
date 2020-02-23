//
//  ALAsset+BTFD.h
//  BTFD
//
//  Created by Werner Altewischer on 16/07/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "BMMLPMIMEType.h"
#import "BMMLPMediaContainer.h"

@interface ALAsset(BMMedia) 

- (BMMediaKind)mediaKind;
- (BMMLPMIMEType *)mimeType;

+ (NSString *)extensionFromAssetRepresentation:(ALAssetRepresentation *)assetRepresentation withDefault:(NSString *)defaultExt;


@end
