//
//  OverlayImageView.h
//  GMCommon
//
//  Created by paulo on 6/21/10.
//  Copyright 2010 GlobalMotion Media, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BMMLPOverlayImageView : UIImageView {
	UIView *overlayView;
}

@property (nonatomic, strong) UIView *overlayView;

- (void)setImage:(UIImage *)theImage withOverlayView:(UIView *)theOverlayView;

@end
