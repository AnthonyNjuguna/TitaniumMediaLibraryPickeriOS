//
//  BMMLPStyle.m
//  medialibrarypicker
//
//  Created by Werner Altewischer on 5/17/13.
//
//

#import "BMMLPStyle.h"

@implementation BMMLPStyle

static BMMLPStyle *instance = nil;

@synthesize audioIconImage, selectionOverlayImage, cameraIconImage, grayButtonImage, navbarBackgroundImage, tableViewBackgroundColor, tableViewCellTextColor, tableViewSummaryTextColor, tableViewSeparatorColor, tableViewCellSelectionStyle, disabledOverlayImage;

+ (BMMLPStyle *)instance {
    if (!instance) {
        instance = [BMMLPStyle new];
    }
    return instance;
}

- (id)init {
    if ((self = [super init])) {
        self.tableViewCellSelectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return self;
}

- (UIImage *)audioIconImage {
    if (audioIconImage) {
        return audioIconImage;
    } else {
        return [UIImage imageNamed:ASSET(@"icon_audio.png")];
    }
}

- (UIImage *)selectionOverlayImage {
    if (selectionOverlayImage) {
        return selectionOverlayImage;
    } else {
        return [UIImage imageNamed:ASSET(@"Overlay.png")];
    }
}

- (UIImage *)disabledOverlayImage {
    if (disabledOverlayImage) {
        return disabledOverlayImage;
    } else {
        return [UIImage imageNamed:ASSET(@"DisabledOverlay.png")];
    }
}

- (UIImage *)cameraIconImage {
    if (cameraIconImage) {
        return cameraIconImage;
    } else {
        return [UIImage imageNamed:ASSET(@"icon_cam.png")];
    }
}

- (UIImage *)grayButtonImage {
    if (grayButtonImage) {
        return grayButtonImage;
    } else {
        return [UIImage imageNamed:ASSET(@"buttonGray.png")];
    }
}

- (UIColor *)tableViewBackgroundColor {
    if (tableViewBackgroundColor) {
        return tableViewBackgroundColor;
    } else {
        return [UIColor whiteColor];
    }
}

- (UIColor *)tableViewSeparatorColor {
    if (tableViewSeparatorColor) {
        return tableViewSeparatorColor;
    } else {
        return nil;
    }
}

- (UIColor *)tableViewCellTextColor {
    if (tableViewCellTextColor) {
        return tableViewCellTextColor;
    } else {
        return [UIColor blackColor];
    }
}

- (UIColor *)tableViewSummaryTextColor {
    if (tableViewSummaryTextColor) {
        return tableViewSummaryTextColor;
    } else {
        return [UIColor grayColor];
    }
}

- (void)dealloc {
    BM_RELEASE_SAFELY(disabledOverlayImage);
    BM_RELEASE_SAFELY(audioIconImage);
    BM_RELEASE_SAFELY(selectionOverlayImage);
    BM_RELEASE_SAFELY(cameraIconImage);
    BM_RELEASE_SAFELY(grayButtonImage);
    BM_RELEASE_SAFELY(navbarBackgroundImage);
    BM_RELEASE_SAFELY(tableViewBackgroundColor);
    BM_RELEASE_SAFELY(tableViewCellTextColor);
    BM_RELEASE_SAFELY(tableViewSummaryTextColor);
    BM_RELEASE_SAFELY(tableViewSeparatorColor);
}

@end
