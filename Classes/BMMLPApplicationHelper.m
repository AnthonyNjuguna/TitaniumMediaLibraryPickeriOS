//
//  BMApplicationHelper.m
//  BMCommons
//
//  Created by Werner Altewischer on 12/06/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import "BMMLPApplicationHelper.h"

@implementation BMMLPApplicationHelper

+ (void)doEvents {
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
}

@end
