//
//  AssetCell.h
//
//  Created by Werner Altewischer on 2/15/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMMLPAssetThumbnailView.h"

@interface BMMLPAssetCell : UITableViewCell
{
	NSMutableArray *thumbnailViews;
}

+ (NSInteger)numberOfThumbnailsForWidth:(CGFloat)width;
-(id)initWithReuseIdentifier:(NSString*)_identifier numberOfThumbnails:(NSInteger)numberOfThumbnails;

@property (nonatomic,readonly) NSArray *thumbnailViews;

@end
