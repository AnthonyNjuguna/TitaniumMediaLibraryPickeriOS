//
//  FileHelper.m
//  BehindMedia
//
//  Created by Werner Altewischer on 7/1/08.
//  Copyright 2008 BehindMedia. All rights reserved.
//

#import "BMMLPFileHelper.h"
#import "BMMLPStringHelper.h"
#import <Foundation/NSPathUtilities.h>

@implementation BMMLPFileHelper

+ (NSString *)tempDirectory {
	return NSTemporaryDirectory();
}

+ (NSString *)createTempFile {
	return [self createTempFileInDir:[BMMLPFileHelper tempDirectory] withExtension:@"tmp"];
}

+ (NSString *)uniqueFileNameWithExtension:(NSString *)extension {
    NSString *s = [BMMLPStringHelper stringWithUUID];
    if (![BMMLPStringHelper isEmpty:extension]) {
        s = [s stringByAppendingFormat:@".%@", extension];
    }
	return s;
}

+ (NSString *)uniqueTempFileWithExtension:(NSString *)extension {
	return [self uniqueFileInDir:[self tempDirectory] withExtension:extension];
}

+ (NSString *)uniqueFileInDir:(NSString *)dir withExtension:(NSString *)extension {
	NSString *uniqueFileName = [BMMLPFileHelper uniqueFileNameWithExtension:extension];
	NSString *tempFile = [dir stringByAppendingPathComponent:uniqueFileName];
	return tempFile;
}

+ (NSString *)createTempFileInDir:(NSString *)dir withExtension:(NSString *)extension {
	NSString *tempFile = [BMMLPFileHelper uniqueFileInDir:dir withExtension:extension];
	if ([[NSFileManager defaultManager] createFileAtPath:tempFile contents:nil attributes:nil]) {
		return tempFile;
	} else {
		LogError(@"Could not create temp file");
		return nil;
	}
}

+ (NSString *)documentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* dir = [paths count] > 0 ? [paths objectAtIndex:0] : nil;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:dir]) {
		[fileManager createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil];  
	}
	return dir;
}

+ (NSString *)cachesDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString* dir = [paths count] > 0 ? [paths objectAtIndex:0] : nil;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:dir]) {
		[fileManager createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil];
	}
	return dir;
}

+ (NSString *)fullDocumentPath:(NSString *)fileName inSubDir:(NSString *)subDir {
	NSString *documentsDirectory = [BMMLPFileHelper documentsDirectory];
    if (subDir) {
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:subDir];
    }
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
	return path;
}

+ (NSString *)fullDocumentPath:(NSString *)fileName {
	NSString *documentsDirectory = [BMMLPFileHelper documentsDirectory];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
	return path;
}

+ (NSData *)applicationDataFromFile:(NSString *)fileName {
	
    NSString *appFile = [BMMLPFileHelper fullDocumentPath:fileName];
	
    NSData *myData = [[NSData alloc] initWithContentsOfFile:appFile];
	
    return myData;
	
}

+ (NSString *)writeApplicationData:(NSData *)data toFile:(NSString *)fileName {
	
    return [self writeApplicationData:data toFile:fileName inSubDir:nil];
}

+ (NSString *)writeApplicationData:(NSData *)data toFile:(NSString *)fileName inSubDir:(NSString *)subDir {
	
    NSString *documentsDirectory = [BMMLPFileHelper documentsDirectory];
	
    if (!documentsDirectory) {
		
        LogError(@"Documents directory not found!");
		
        return nil;
    }
    
    if (subDir) {
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:subDir];
    }
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];		
    BOOL result = ([data writeToFile:appFile atomically:YES]);	
    
    if (result) {
        return appFile;
    } else {
        return nil;
    }
}


+ (NSArray *)listDocumentsInDir:(NSString *)directory {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *files = [fileManager contentsOfDirectoryAtPath:directory error:&error];
	
	if (!files) {
		LogError(@"Could not list directory %@: %@", directory, [error localizedDescription]);
	}
	
	return files;
}

+ (NSArray *)listDocumentsInDir:(NSString *)directory withExtension:(NSString *)extension {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *files = [fileManager contentsOfDirectoryAtPath:directory error:&error];
	
	if (!files) {
		LogError(@"Could not list directory %@: %@", directory, [error localizedDescription]);
	}
	
	if (![BMMLPStringHelper isEmpty:extension]) {
        NSString *theExtension = [@"." stringByAppendingString:extension];
		NSMutableArray *filteredFiles = [NSMutableArray arrayWithCapacity:files.count];
		for (int i = 0; i < files.count; ++i) {
			NSString *file = [files objectAtIndex:i];
			if ([file hasSuffix:theExtension]) {
				[filteredFiles addObject:file];
			}
		}
		files = filteredFiles;
	}
	
	return files;
}

+ (NSArray *)listApplicationDocuments {
	NSString *documentsDirectory = [BMMLPFileHelper documentsDirectory];
	return [BMMLPFileHelper listDocumentsInDir:documentsDirectory];
}

+ (NSArray *)listApplicationDocumentsWithExtension:(NSString *)extension inSubDir:(NSString *)subDir {
	NSString *documentsDirectory = [BMMLPFileHelper documentsDirectory];
    if (subDir) {
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:subDir];
    }
	return [BMMLPFileHelper listDocumentsInDir:documentsDirectory withExtension:extension];
}


+ (NSArray *)listApplicationDocumentsWithExtension:(NSString *)extension {
    return [self listApplicationDocumentsWithExtension:extension inSubDir:nil];
}

+ (void)cleanDirectory:(NSString *)dir {
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *error;
	NSArray *list = [fm contentsOfDirectoryAtPath:dir error:&error];
	
	for (NSString *file in list) {
		if (![fm removeItemAtPath:[dir stringByAppendingPathComponent:file] error:&error]) {
			LogError(@"Could not remove item: %@", [error localizedDescription]);
		}
	}
}

+ (BOOL)removeApplicationFile:(NSString *)fileName {
    
    if ([BMMLPStringHelper isEmpty:fileName]) {
        LogInfo(@"No file specified for removal");
        return NO;
    }
    
	NSString *documentsDirectory = [BMMLPFileHelper documentsDirectory];
	
    if (!documentsDirectory) {
		
        LogError(@"Documents directory not found!");
		
        return NO;
    }
	
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSFileManager *fm = [NSFileManager defaultManager];
	
	NSError *error = nil;
	BOOL ret = [fm removeItemAtPath:appFile error:&error];
	if (!ret) {
		LogError(@"Could not remove document '%@': %@", appFile, error);
	}
	return ret;
}

+ (NSString *)uniqueLocalURL {
	return [self uniqueLocalURLWithExtension:nil];
}

+ (NSString *)uniqueLocalURLWithExtension:(NSString *)extension {
    if ([BMMLPStringHelper isEmpty:extension]) {
        return [NSString stringWithFormat:@"http://local/%@", [BMMLPStringHelper stringWithUUID]];    
    } else {
        return [NSString stringWithFormat:@"http://local/%@.%@", [BMMLPStringHelper stringWithUUID], extension];
    }
	
}

+ (BOOL)isLocalURL:(NSString *)url {
    return [url hasPrefix:@"http://local/"];
}

@end
