//
//  MaskView.h
//  FlyingBlue
//
//  Created by Werner Altewischer on 01/10/09.
//  Copyright 2010 BehindMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BMMLPMaskView : UIView {
	UIImageView *imageView;
}

@property (nonatomic, strong) UIImageView *imageView;

- (void)hide;
- (void)show;

@end
