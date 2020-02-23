//
//  BMMLPStyle.h
//  medialibrarypicker
//
//  Created by Werner Altewischer on 5/17/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BMMLPStyle : NSObject {
    UIImage *audioIconImage;
    UIImage *selectionOverlayImage;
    UIImage *disabledOverlayImage;
    UIImage *cameraIconImage;
    UIImage *grayButtonImage;
    UIImage *navbarBackgroundImage;
    UIColor *tableViewBackgroundColor;
    UIColor *tableViewSeparatorColor;
    UIColor *tableViewCellTextColor;
    UIColor *tableViewSummaryTextColor;
    UITableViewCellSelectionStyle tableViewCellSelectionStyle;
}

@property (nonatomic, strong) UIImage *disabledOverlayImage;
@property (nonatomic, strong) UIImage *audioIconImage;
@property (nonatomic, strong) UIImage *selectionOverlayImage;
@property (nonatomic, strong) UIImage *cameraIconImage;
@property (nonatomic, strong) UIImage *grayButtonImage;
@property (nonatomic, strong) UIImage *navbarBackgroundImage;
@property (nonatomic, strong) UIColor *tableViewBackgroundColor;
@property (nonatomic, strong) UIColor *tableViewSeparatorColor;
@property (nonatomic, strong) UIColor *tableViewCellTextColor;
@property (nonatomic, strong) UIColor *tableViewSummaryTextColor;
@property (nonatomic, assign) UITableViewCellSelectionStyle tableViewCellSelectionStyle;

+ (BMMLPStyle *)instance;

@end
