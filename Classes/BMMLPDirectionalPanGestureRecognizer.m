//
//  BMMLPDirectionalPanGestureRecognizer.m
//  medialibrarypicker
//
//  Created by Werner Altewischer on 16/09/14.
//
//

#import "BMMLPDirectionalPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

CGFloat const static kDirectionPanThreshold = 30;

@implementation BMMLPDirectionalPanGestureRecognizer {
    CGFloat _moveX;
    CGFloat _moveY;
}

@synthesize direction = _direction;

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    _moveX += prevPoint.x - nowPoint.x;
    _moveY += prevPoint.y - nowPoint.y;
    if (abs(_moveX) > kDirectionPanThreshold) {
        if (_direction == BMMLPPangestureRecognizerVerticalDirection) {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
    if (abs(_moveY) > kDirectionPanThreshold) {
        if (_direction == BMMLPPanGestureRecognizerHorizontalDirection) {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
}

- (void)reset {
    [super reset];
    _moveX = 0;
    _moveY = 0;
}

@end
