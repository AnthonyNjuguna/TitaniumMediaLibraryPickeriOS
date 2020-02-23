//
//  BMMLPNavigationBar.m
//  medialibrarypicker
//
//  Created by Werner Altewischer on 5/17/13.
//
//

#import "BMMLPNavigationBar.h"

@implementation BMMLPNavigationBar

@synthesize backgroundImage;

- (void)setBackgroundImage:(UIImage *)theImage {
    if (backgroundImage != theImage) {
        backgroundImage = theImage;
        
        if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [self setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        }
    }
}


@end
