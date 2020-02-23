//
//  ComBehindmediaAssetsGroupProxy.h
//  medialibrarypicker
//
//  Created by Werner Altewischer on 24/04/14.
//
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TiProxy.h"

@interface ComBehindmediaAssetsGroupProxy : TiProxy

+ (ComBehindmediaAssetsGroupProxy *)assetsGroupProxyWithAssetsGroup:(ALAssetsGroup *)group;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *type;
@property (nonatomic, retain) NSString *persistentID;
@property (nonatomic, retain) NSURL *url;



@end
