//
//  ViewController.m
//  MediaLibraryPickerTest
//
//  Created by Werner Altewischer on 5/23/13.
//
//

#import "ViewController.h"
#import "BMMLPMediaLibraryPickerController.h"
#import "BMMLPNavigationBar.h"
#import "BMMLPStyle.h"
#import "BMMLPDialogHelper.h"
#import "BMMLPPicture.h"
#import "BMMLPVideo.h"

@interface ViewController () <BMMLPMediaPickerControllerDelegate>

@end

@implementation ViewController {
    BMMLPMediaLibraryPickerController *_controller;
    IBOutlet UIImageView *_imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)onPickMedia:(id)sender {
    
    _controller = [[BMMLPMediaLibraryPickerController alloc] init];
    _controller.delegate = self;
    _controller.copyRawPictures = YES;
    
    /*
     @property (nonatomic, assign) NSUInteger maxSelectablePictures;
     @property (nonatomic, assign) NSUInteger maxSelectableVideos;
     @property (nonatomic, assign) NSUInteger maxSelectableMedia;
     @property (nonatomic, assign) BOOL allowMixedMediaTypes;
     
     @property (nonatomic, assign) Class pictureContainerClass;
     @property (nonatomic, assign) Class videoContainerClass;
     @property (nonatomic, readonly) NSArray *media;
     @property (nonatomic, retain) NSArray *acceptableUTIs;

     */
    
    _controller.maxSelectablePictures = 1000;
    _controller.maxSelectableVideos = 1000;
    _controller.maxSelectableMedia = 10;
    _controller.allowMixedMediaTypes = YES;
    _controller.copyReferencesOnly = YES;
    _controller.includeFullScreenImages = NO;
    _controller.includeThumbnails = NO;
    _controller.pictureContainerClass = [BMMLPPicture class];
    _controller.videoContainerClass = [BMMLPVideo class];
    
    [_controller present];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"Memory warning");
    // Dispose of any resources that can be recreated.
}

#pragma mark - BMMLPMediaPickerControllerDelegate

- (void)mediaPickerControllerWasDismissed:(BMMLPMediaPickerController *)controller withMedia:(NSArray *)media {
    
    NSMutableArray *images = [NSMutableArray array];
    for (id <BMMLPMediaContainer> mc in media) {
        if ([mc isKindOfClass:[BMMLPPicture class]]) {
            BMMLPPicture *pic = (BMMLPPicture *)mc;
            
            UIImage *image = pic.midSizeImage;
            
            [images addObject:image];
        }
    }
    
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_imageView setAnimationImages:images];
    [_imageView setAnimationDuration:3.0 * images.count];
    [_imageView startAnimating];
    
    BM_AUTORELEASE_SAFELY(_controller);
}

- (void)mediaPickerControllerWasCancelled:(BMMLPMediaPickerController *)controller {
    BM_AUTORELEASE_SAFELY(_controller);
}

- (void)mediaPickerControllerReachedMaxSelectableMedia:(BMMLPMediaPickerController *)controller {
    [BMMLPDialogHelper alertWithTitle:@"Max media reached" message:@"You reached the max number of selectable media" delegate:nil];
}

- (void)mediaPickerController:(BMMLPMediaPickerController *)controller presentViewController:(UIViewController *)vc {
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)mediaPickerController:(BMMLPMediaPickerController *)controller dismissViewController:(UIViewController *)vc {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)mediaPickerController:(BMMLPMediaPickerController *)controller shouldAllowSelectionOfMediaWithSourceURL:(NSURL *)sourceURL {
    return YES;
}

- (void)mediaPickerController:(BMMLPMediaPickerController *)c didLoadAssetsGroups:(NSArray *)groups {
    
}

@end
