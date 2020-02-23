//
//  BMMLPCommon.h
//  medialibrarypicker
//
//  Created by Werner Altewischer on 5/23/13.
//
//

#import <Foundation/Foundation.h>

#define LogError(fmt, ...) NSLog(fmt, ##__VA_ARGS__)
#define LogWarn(fmt, ...) NSLog(fmt, ##__VA_ARGS__)
#define LogInfo(...)
#define LogDebug(...)

#if __has_feature(objc_arc)
#define BM_RELEASE_SAFELY(__POINTER) { __POINTER = nil; }
#define BM_AUTORELEASE_SAFELY(__POINTER) { __POINTER = nil; }
#else
#define BM_RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
#define BM_AUTORELEASE_SAFELY(__POINTER) { [__POINTER autorelease]; __POINTER = nil; }
#endif

