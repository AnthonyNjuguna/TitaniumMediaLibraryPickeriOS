//
//  AttachmentDTO.m
//  BehindMediaCommons
//
//  Generated Class
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMMLPMediaItem.h"

#import "BMMLPStringHelper.h"
#import "BMMLPFileHelper.h"
#import "BMMLPPropertyDescriptor.h"
#import "BMMLPUIImageToJPEGDataTransformer.h"

#define DATA_DIRECTORY @"MediaLibraryPicker"

@interface BMMLPMediaItem(Private)

- (void)setData:(NSData *)theData withExtension:(NSString *)extension andURLPropertyDescriptor:(BMMLPPropertyDescriptor *)pd;
- (NSString *)dataDirectory;

@end

@implementation BMMLPMediaItem

@synthesize filePath, midSizeImageFilePath, thumbnailImageFilePath, metaData, asset, sourceURL;
@synthesize dimensions;

#pragma mark -
#pragma mark Overridden methods


- (id)init {
    if ((self = [super init])) {
        dimensions = CGSizeZero;
    }
    return self;
}

#pragma mark -
#pragma mark MediaContainer implementation

- (void)setData:(NSData *)theData withExtension:(NSString *)extension {
    [self setData:theData withExtension:extension andURLPropertyDescriptor:[BMMLPPropertyDescriptor propertyDescriptorFromKeyPath:@"filePath" withTarget:self]];
}

- (void)setData:(NSData *)theData {
    [self setData:theData withExtension:[[self class] fileExtension]];
}

- (void)setThumbnailImageData:(NSData *)data {
    [self setThumbnailImageData:data withExtension:BM_THUMBNAIL_FILE_EXTENSION];
}

- (void)setMidSizeImageData:(NSData *)theData {
    [self setMidSizeImageData:theData withExtension:BM_THUMBNAIL_FILE_EXTENSION];
}

- (void)setDataFromFile:(NSString *)sourcePath {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *fp = self.filePath;
    if (fp) {
        if (![fm removeItemAtPath:fp error:&error]) {
            LogWarn(@"Could not remove file at path %@: %@", fp, error);
        }
        self.filePath = nil;
    }
    NSString *extension = [sourcePath pathExtension];
    fp = [BMMLPFileHelper uniqueFileInDir:[self dataDirectory] withExtension:extension];
    if (![fm moveItemAtPath:sourcePath toPath:fp error:&error]) {
        LogWarn(@"Could not move file to destination: %@", error);
    } else {
        self.filePath = fp;
    }
}

- (NSData *)data {
    if (self.filePath) {
        return [NSData dataWithContentsOfFile:self.filePath];
    }
    return nil;
}

- (void)setThumbnailImageData:(NSData *)theData withExtension:(NSString *)extension {
    [self setData:theData withExtension:extension andURLPropertyDescriptor:[BMMLPPropertyDescriptor propertyDescriptorFromKeyPath:@"thumbnailImageFilePath" withTarget:self]];
}

- (NSData *)thumbnailImageData {
    return [NSData dataWithContentsOfFile:self.thumbnailImageFilePath];
}

- (void)setMidSizeImageData:(NSData *)theData withExtension:(NSString *)extension {
	[self setData:theData withExtension:extension andURLPropertyDescriptor:[BMMLPPropertyDescriptor propertyDescriptorFromKeyPath:@"midSizeImageFilePath" withTarget:self]];
}

- (NSData *)midSizeImageData {
    return [NSData dataWithContentsOfFile:self.midSizeImageFilePath];
}

- (UIImage *)thumbnailImage {
    if (self.thumbnailImageFilePath) {
        return [UIImage imageWithContentsOfFile:self.thumbnailImageFilePath];
    } else if (self.asset) {
        return [UIImage imageWithCGImage:self.asset.thumbnail];
    }
    return nil;
}

- (void)setThumbnailImage:(UIImage *)theImage {
	[self setThumbnailImageData:[self dataFromImage:theImage]];
}

- (UIImage *)midSizeImage {
    if (self.midSizeImageFilePath) {
        return [UIImage imageWithContentsOfFile:self.midSizeImageFilePath];
    } else if (self.asset) {
        return [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
    }
    return nil;
}

- (void)setMidSizeImage:(UIImage *)theImage {
	[self setMidSizeImageData:[self dataFromImage:theImage]];
}

- (BMMediaKind)mediaKind {
	return BMMediaKindUnknown;
}

- (void)deleteObject {
	//Delete the associated files for this object
    [self setData:nil];
    [self setMidSizeImageData:nil];
    [self setThumbnailImageData:nil];
}

- (NSData *)dataFromImage:(UIImage *)image {
    if (!image) {
        return nil;
    }
    BMMLPUIImageToJPEGDataTransformer *transformer = [BMMLPUIImageToJPEGDataTransformer new];
	NSData *theData = [transformer transformedValue:image];
    return theData;
}

#pragma mark -
#pragma mark Public methods

+ (NSString *)fileExtension {
	return @"bin";
}

@end

@implementation BMMLPMediaItem(Private)

- (NSString *)dataDirectory {
    return [BMMLPFileHelper tempDirectory];
}

- (void)setData:(NSData *)theData withExtension:(NSString *)extension andURLPropertyDescriptor:(BMMLPPropertyDescriptor *)pd {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *fp = [pd callGetter];
    if (fp) {
        if (![fm removeItemAtPath:fp error:&error]) {
            LogWarn(@"Could not remove file at path %@: %@", fp, error);
        }
        [pd callSetter:nil];
    }
    fp = [BMMLPFileHelper uniqueFileInDir:[self dataDirectory] withExtension:extension];
    if ([theData writeToFile:fp atomically:YES]) {
        [pd callSetter:fp];
    }
}

@end	 
