//
//  StringHelper.h
//  BehindMedia
//
//  Created by Werner Altewischer on 23/09/08.
//  Copyright 2008 BehindMedia. All rights reserved.
//

/**
 @brief Class with string utility methods
 */
#import <Foundation/Foundation.h>

@interface BMMLPStringHelper : NSObject {
	
}

/**
 @brief Returns true if and only if a string is nil or equal to the empty string.
 */
+ (BOOL)isEmpty:(NSString *)string;

/**
 @brief Extracts a substring by looking for the specified begin and end markers.
 */
+ (NSString *)getSubStringFromString:(NSString *)string beginMarker:(NSString *)beginMarker endMarker:(NSString *)endMarker;

/**
 @brief Parses integers from strings by using the specified sscanf pattern and subsequently compares them. UTF8 encoding is used.
 @param s1 String containing the first int number to compare
 @param s2 String containing the second int number to compare
 @param thePattern sscanf pattern for parsing the int number from the supplied strings
 @returns the comparison result
 */
+ (NSComparisonResult)numericPatternCompareString:(NSString *)s1 withString:(NSString *)s2 usingPattern:(NSString *)thePattern;

/**
 @brief Checks if the supplied string is nil. If so it is converted to the empty string, otherwise the string is returned unmodified
 */
+ (NSString *)filterNilString:(NSString *)s;

/**
 @brief Checks if the supplied string is the empty string. If so it is converted to nil, otherwise the string is returned unmodified
 */
+ (NSString *)filterEmptyString:(NSString *)s;

/**
 @brief Returns a string containing a Universal Unique Identifier. The identifier is in the form: 68753A44-4D6F-1226-9C60-0050E4C00067
 */
+ (NSString*) stringWithUUID;

/**
 @brief Returns the specified string as URL where all special characters are replaced with percentage escapes.
 */
+ (NSURL *)stringAsEscapedURL:(NSString *)s;

/**
 @brief Returns the UTF8 string representation of the specified data.
 */
+ (NSString *)stringRepresentationOfData:(NSData *)data;

/**
 @brief Returns the UTF8 data representation of the specified string.
 */
+ (NSData *)dataRepresentationOfString:(NSString *)string;

/**
 @brief Returns a formatted string with the kCFNumberFormatterDecimalStyle by parsing the supplied double.
 */
+ (NSString *)decimalStringFromDouble:(double)d;

/**
 @brief Returns a copy of the string with the first char converted to lowercase.
 */
+ (NSString *)stringByConvertingFirstCharToLowercase:(NSString *)s;

/**
 @brief Converts a filePath to a URL or returns nil if the path is nil.
 */
+ (NSURL *)urlFromFilePath:(NSString *)filePath;

+ (NSDictionary *)parametersFromQueryString:(NSString *)query;

@end
