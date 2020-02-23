//
//  BMCommonsDialogHelper.h
//  BehindMedia
//
//  Created by Werner Altewischer on 7/10/08.
//  Copyright 2010 BehindMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 @brief Helper methods to create common alerts/actionsheets.
 */
@interface BMMLPDialogHelper : NSObject {

}

+ (UIActionSheet *)dialogOKCancelWithTitle:(NSString *)title withDelegate:(id <UIActionSheetDelegate>)delegate withView:(UIView *)view;
+ (UIActionSheet *)dialogYesNoWithTitle:(NSString *)title withDelegate:(id <UIActionSheetDelegate>)delegate withView:(UIView *)view;
+ (UIActionSheet *)dialogWithTitle:(NSString *)title 
						  delegate:(id <UIActionSheetDelegate>)delegate 
				 cancelButtonTitle:(NSString *)cancelTitle
			destructiveButtonTitle:(NSString *)destructiveTitle
				 otherButtonTitles:(NSArray *)otherTitles 
						   forView:(UIView *)theView
						   withTag:(NSUInteger)tag;

+ (UIAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;
+ (UIAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
@end
