//
//  ComBehindmediaAssetsGroupProxy.m
//  medialibrarypicker
//
//  Created by Werner Altewischer on 24/04/14.
//
//

#import "ComBehindmediaAssetsGroupProxy.h"

@implementation ComBehindmediaAssetsGroupProxy

+ (ComBehindmediaAssetsGroupProxy *)assetsGroupProxyWithAssetsGroup:(ALAssetsGroup *)group {
    ComBehindmediaAssetsGroupProxy *proxy = [ComBehindmediaAssetsGroupProxy new];
    proxy.name = [group valueForProperty:ALAssetsGroupPropertyName];
    proxy.type = [group valueForProperty:ALAssetsGroupPropertyType];
    proxy.persistentID = [group valueForProperty:ALAssetsGroupPropertyPersistentID];
    proxy.url = [group valueForProperty:ALAssetsGroupPropertyURL];
    return proxy;
}

@end
