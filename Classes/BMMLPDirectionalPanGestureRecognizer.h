//
//  BMMLPDirectionalPanGestureRecognizer.h
//  medialibrarypicker
//
//  Created by Werner Altewischer on 16/09/14.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    BMMLPPangestureRecognizerVerticalDirection,
    BMMLPPanGestureRecognizerHorizontalDirection
} BMMLPPangestureRecognizerDirection;

@interface BMMLPDirectionalPanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, assign) BMMLPPangestureRecognizerDirection direction;

@end
