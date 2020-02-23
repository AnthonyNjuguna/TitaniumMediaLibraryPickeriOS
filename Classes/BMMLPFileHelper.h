//
//  FileHelper.h
//  BehindMedia
//
//  Created by Werner Altewischer on 7/1/08.
//  Copyright 2008 BehindMedia. All rights reserved.
//

/**
 @brief Class with file utility methods
 */
@interface BMMLPFileHelper : NSObject {

}

/**
 @brief Returns the application's documents directory.
 */
+ (NSString *)documentsDirectory;

+ (NSString *)cachesDirectory;

/**
 @brief Returns the temporary directory.
 */
+ (NSString *)tempDirectory;

/**
 @brief Creates a unique file with extension "tmp" in the temp dir.
 @returns The file path of the created file
 */
+ (NSString *)createTempFile;

/**
 @brief Creates a unique file with specified extension in the specified dir
 @param dir The directory to create the file in
 @param extension The extension of the file to create. Extension should not include the "."
 @returns The file path of the created file
 */
+ (NSString *)createTempFileInDir:(NSString *)dir withExtension:(NSString *)extension;

/**
 @brief Prepends the document dir to the specified filename giving the full path to the file.
 */
+ (NSString *)fullDocumentPath:(NSString *)fileName;

+ (NSString *)fullDocumentPath:(NSString *)fileName inSubDir:(NSString *)subDir;

/**
 @brief Reads in the file with the specified filename from the documents dir and returns the data contained within it.
 */
+ (NSData *)applicationDataFromFile:(NSString *)fileName;

/**
 @brief Writes application date to the file with the specified filename in the documents dir. 
 @returns true if successful, false otherwise. Error is logged.
 */
+ (NSString *)writeApplicationData:(NSData *)data toFile:(NSString *)fileName;

+ (NSString *)writeApplicationData:(NSData *)data toFile:(NSString *)fileName inSubDir:(NSString *)subDir;

/**
 @brief Removes the file with the specified filename from the documents dir.
 @returns true if successful, false otherwise
 */
+ (BOOL)removeApplicationFile:(NSString *)fileName;

/**
 @brief Returns an array of filenames of the the files in the specified directory.
 */
+ (NSArray *)listDocumentsInDir:(NSString *)directory;

/**
 @brief Returns an array of filenames of the the files in the specified directory with the specified extension.
 */
+ (NSArray *)listDocumentsInDir:(NSString *)directory withExtension:(NSString *)extension;

/**
 @brief Returns an array of filenames of the the files in the documents directory.
 */
+ (NSArray *)listApplicationDocuments;

/**
 @brief Returns an array of filenames of the the files in the documents directory with the specified extension.
 */
+ (NSArray *)listApplicationDocumentsWithExtension:(NSString *)extension;

+ (NSArray *)listApplicationDocumentsWithExtension:(NSString *)extension inSubDir:(NSString *)subDir;

/**
 @brief Removes all files from the specified directory.
 */
+ (void)cleanDirectory:(NSString *)dir;

/**
 @brief Returns a unique file path to a file in the temp directory with the specified extension. File is not created.
 */
+ (NSString *)uniqueTempFileWithExtension:(NSString *)extension;

/**
 @brief Returns a unique file path to a file in the specified directory with the specified extension. File is not created.
 */
+ (NSString *)uniqueFileInDir:(NSString *)dir withExtension:(NSString *)extension;

/**
 @brief Returns a unique file name with the specified extension.
 */
+ (NSString *)uniqueFileNameWithExtension:(NSString *)extension;

/**
 @brief Returns a unique URL with http://localhost prefix, handy for storing local files in the url cache.
 */
+ (NSString *)uniqueLocalURL;

+ (NSString *)uniqueLocalURLWithExtension:(NSString *)extension;

+ (BOOL)isLocalURL:(NSString *)url;

@end
