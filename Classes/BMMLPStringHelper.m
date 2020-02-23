//
//  StringHelper.m
//  BehindMedia
//
//  Created by Werner Altewischer on 23/09/08.
//  Copyright 2008 BehindMedia. All rights reserved.
//

#import "BMMLPStringHelper.h"

@implementation BMMLPStringHelper

+ (BOOL)isEmpty:(NSString *)string {
	return string == nil || [string isEqual:@""];
}

+ (NSString *)getSubStringFromString:(NSString *)string beginMarker:(NSString *)beginMarker endMarker:(NSString *)endMarker {
	NSRange range = [string rangeOfString:beginMarker];
	NSString *ret = nil;
	
	if (range.location != NSNotFound) {
		NSUInteger start = range.location + range.length;
		range.length += 10;
		range = [string rangeOfString:endMarker options:NSLiteralSearch range:range];
		if (range.location != NSNotFound) {
			NSUInteger end = range.location;
			range.location = start;
			range.length = end - start;
			ret = [string substringWithRange:range];
		}
	} 
	return ret;
}


+ (NSComparisonResult)numericPatternCompareString:(NSString *)s1 withString:(NSString *)s2 usingPattern:(NSString *)thePattern {
	NSString *fileName1 = (NSString *)s1;
	NSString *fileName2 = (NSString *)s2;
	NSInteger v1 = 0;
	NSInteger v2 = 0;
	const char *pattern = [thePattern cStringUsingEncoding:NSUTF8StringEncoding];
	
	sscanf([fileName1 cStringUsingEncoding:NSUTF8StringEncoding], pattern, &v1);
	sscanf([fileName2 cStringUsingEncoding:NSUTF8StringEncoding], pattern, &v2);
	
	if (v1 < v2)
		return NSOrderedAscending;
	else if (v1 > v2)
		return NSOrderedDescending;
	else
		return NSOrderedSame;
}

+ (NSString *)filterNilString:(NSString *)s {
	return s ? s : @"";
}

+ (NSString *)filterEmptyString:(NSString *)s {
    return [@"" isEqual:s] ? nil : s; 
}

+ (NSString*) stringWithUUID {
	CFUUIDRef uuidObj = CFUUIDCreate(nil);//create a new UUID
										  //get the string representation of the UUID
	NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
	CFRelease(uuidObj);
	return uuidString;
}

+ (NSString *)stringRepresentationOfData:(NSData *)data	{
	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}	  

+ (NSData *)dataRepresentationOfString:(NSString *)string {
	return [string dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSURL *)stringAsEscapedURL:(NSString *)s {
	if (!s) return nil;
	s = [s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return [NSURL URLWithString:s];
}

+ (NSString *)decimalStringFromDouble:(double)d {
	// convert the double to an NSNumber
	NSNumber *number = [NSNumber numberWithDouble: d];
	
	// create a number formatter object
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle: NSNumberFormatterDecimalStyle];
	
	// convert the number to a string
	NSString *string = [formatter stringFromNumber: number];
	
	// release just the formatter (the number will be release in the autorelease pool)
	
	// return the string
	return string;
}

+ (NSString *)stringByConvertingFirstCharToLowercase:(NSString *)s {

	NSString *ret = s;

	if (s.length > 0) {
		NSString *firstChar = [s substringWithRange:NSMakeRange(0,1)];
		ret = [firstChar lowercaseString];
		if (s.length > 1) {
			ret = [ret stringByAppendingString:[s substringFromIndex:1]];
		}
	}
	return ret;
}

+ (NSURL *)urlFromFilePath:(NSString *)filePath {
    return filePath ? [NSURL fileURLWithPath:filePath] : nil;
}

+ (NSDictionary *)parametersFromQueryString:(NSString *)query {
    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    NSArray	*tuples = [query componentsSeparatedByString: @"&"];
	for (NSString *tuple in tuples) {
		NSArray *keyValueArray = [tuple componentsSeparatedByString: @"="];
		if (keyValueArray.count == 2) {
			NSString *key = [keyValueArray objectAtIndex:0];
			NSString *value = [keyValueArray objectAtIndex:1];
			[ret setObject:value forKey:key];
		}
	}
    return ret;
}

@end
