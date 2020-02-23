//
//  AssetTablePicker.m
//
//  Created by Werner Altewischer on 2/15/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import "BMMLPAssetTablePicker.h"
#import "BMMLPAssetCell.h"
#import "BMMLPAlbumPickerController.h"
#import "ALAsset+BMMedia.h"
#import "BMMLPImagePickerController.h"
#import "BMMLPStyle.h"
#import "BMMLPDirectionalPanGestureRecognizer.h"

@interface BMMLPAssetTablePicker()<UIGestureRecognizerDelegate>

@end

@interface BMMLPAssetTablePicker(Private)

-(NSArray*)assetsForIndexPath:(NSIndexPath*)_indexPath;
-(void)updateView;
-(void)setAssets:(NSArray *)theAssets;
-(BMMediaKind)supportedMediaKinds;
-(void)preparePhotos:(NSArray *)args;
- (void)updateSelectableAssets:(BMMediaKind)mediaKinds;
- (NSInteger)numberOfCellsPerRow;

@end

@implementation BMMLPAssetTablePicker {
    BOOL _swipeSelectionState;
    BOOL _shouldAllowPan;
    
    UILongPressGestureRecognizer *_longPressGestureRecognizer;
    UIPanGestureRecognizer *_panGestureRecognizer;
    BMMLPDirectionalPanGestureRecognizer *_horizontalPanGestureRecognizer;
}

@synthesize delegate;
@synthesize assetGroup;
@synthesize selectedAssets;

static BMMLPSwipeSelectionMode defaultSwipeSelectionMode = BMMLPSwipeSelectionModePan | BMMLPSwipeSelectionModeLongPressPan;

+ (void)setDefaultSwipeSelectionMode:(BMMLPSwipeSelectionMode)mode {
    defaultSwipeSelectionMode = mode;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        selectedAssets = [NSMutableArray new];
        filteredMediaKinds = BMMediaKindAll;
        self.swipeSelectionMode = defaultSwipeSelectionMode;
    }
    return self;
}

- (void)dealloc {
    if ([self isViewLoaded]) {
        [self viewDidUnload];
    }
}

#pragma mark - UIViewController methods

-(void)viewDidLoad {
    [super viewDidLoad];
    
    _shouldAllowPan = NO;
    self.tableView.backgroundColor = [[BMMLPStyle instance] tableViewBackgroundColor];
    
    assets = [NSMutableArray new];
    photoAssets = [NSMutableArray new];
    videoAssets = [NSMutableArray new];
    
    self.tableView.rowHeight = 79;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView setSeparatorColor:[UIColor clearColor]];
	[self.tableView setAllowsSelection:NO];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,45)];
    
    footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    footerView.backgroundColor = [UIColor clearColor];
    footerLabel = [[UILabel alloc] initWithFrame:footerView.bounds];
    footerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    footerLabel.textColor = [[BMMLPStyle instance] tableViewSummaryTextColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.backgroundColor = [UIColor clearColor];
    [footerView addSubview:footerLabel];
    
    self.tableView.tableFooterView = footerView;
    
    
    selectionControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"All", nil), 
                                                                                       NSLocalizedString(@"Photos", nil),
                                                                                       NSLocalizedString(@"Videos", nil), nil]];
    selectionControl.segmentedControlStyle = UISegmentedControlStyleBar;
    
    if (filteredMediaKinds == BMMediaKindAll) {
        selectionControl.selectedSegmentIndex = 0;
    } else if (filteredMediaKinds == BMMediaKindPicture) {
        selectionControl.selectedSegmentIndex = 1;
    } else {
        selectionControl.selectedSegmentIndex = 2;
    }
    [selectionControl addTarget:self action:@selector(onSelectionChanged:) forControlEvents:UIControlEventValueChanged];
    
    BMMediaKind supportedMediaKinds = self.supportedMediaKinds;
    if ((supportedMediaKinds & BMMediaKindVideo) &&  (supportedMediaKinds & BMMediaKindPicture)) {
        self.navigationItem.titleView = selectionControl;
    } else {
        self.navigationItem.titleView = nil;
    }
    
	UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
	[self.navigationItem setRightBarButtonItem:doneButtonItem];
	[self setTitle:NSLocalizedString(@"Loading...", nil)];
        
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    NSMutableArray *args = [NSMutableArray arrayWithCapacity:2];
    [args addObject:[NSNumber numberWithInt:self.supportedMediaKinds]];
    NSArray *supportedUTIs = [self.delegate supportedUTIsForAssetTablePicker:self];
    if (supportedUTIs) {
        [args addObject:supportedUTIs];
    }
    [self performSelectorInBackground:@selector(preparePhotos:) withObject:args];
    
    UILongPressGestureRecognizer *lgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressGesture:)];
    lgr.delegate = self;
    lgr.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:lgr];
    
    UIPanGestureRecognizer *gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
    gr.minimumNumberOfTouches = 1;
    gr.maximumNumberOfTouches = 1;
    gr.delegate = self;
    gr.cancelsTouchesInView = YES;
    [self.tableView addGestureRecognizer:gr];
    
    BMMLPDirectionalPanGestureRecognizer *dgr = [[BMMLPDirectionalPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
    dgr.minimumNumberOfTouches = 1;
    dgr.maximumNumberOfTouches = 1;
    dgr.direction = BMMLPPanGestureRecognizerHorizontalDirection;
    dgr.delegate = self;
    dgr.cancelsTouchesInView = YES;
    [self.tableView addGestureRecognizer:dgr];
    
    _longPressGestureRecognizer = lgr;
    _panGestureRecognizer = gr;
    _horizontalPanGestureRecognizer = dgr;
}

- (void)viewDidUnload {
    selectableAssets = nil;
    BM_RELEASE_SAFELY(selectionControl);
    BM_RELEASE_SAFELY(footerLabel);
    BM_RELEASE_SAFELY(assets);
    BM_RELEASE_SAFELY(photoAssets);
    BM_RELEASE_SAFELY(videoAssets);
    BM_RELEASE_SAFELY(activityIndicator);
    [super viewDidUnload];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.tableView reloadData];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
}

#pragma mark UITableViewDataSource/Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfCellsPerRow = self.numberOfCellsPerRow;
    return selectableAssets.count / numberOfCellsPerRow + (selectableAssets.count % numberOfCellsPerRow > 0 ? 1 : 0);
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell-%d", self.numberOfCellsPerRow];
        
    BMMLPAssetCell *cell = (BMMLPAssetCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {	
        cell = [[BMMLPAssetCell alloc] initWithReuseIdentifier:CellIdentifier numberOfThumbnails:self.numberOfCellsPerRow];
        for (BMMLPAssetThumbnailView *v in cell.thumbnailViews) {
            v.delegate = self;
        }
    }
    
    NSArray *assetsForIndexPath = [self assetsForIndexPath:indexPath];
    int i = 0;
    for (BMMLPAssetThumbnailView *v in cell.thumbnailViews) {
        ALAsset *theAsset = i < assetsForIndexPath.count ? [assetsForIndexPath objectAtIndex:i++] : nil;
        [v setAsset:theAsset];
        v.selected = [selectedAssets containsObject:theAsset];
        v.enabled = [self.delegate assetTablePicker:self allowSelectionOfAsset:theAsset];
    }
    return cell;
}

#pragma mark - Actions

- (void) doneAction:(id)sender {	
    [self.delegate assetTablePicker:self didFinishWithSelectedAssets:selectedAssets];
}

- (void)onSelectionChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        //All
        filteredMediaKinds = BMMediaKindAll;
    } else if (sender.selectedSegmentIndex == 1) {
        //Photos
        filteredMediaKinds = BMMediaKindPicture;
    } else {
        //Videos
        filteredMediaKinds = BMMediaKindVideo;
    }
    [self updateView];
}

- (void)onLongPressGesture:(UILongPressGestureRecognizer *)gr {
    if(UIGestureRecognizerStateBegan == gr.state) {
        _shouldAllowPan = NO;
        for (BMMLPAssetCell *cell in [self.tableView visibleCells]) {
            for (BMMLPAssetThumbnailView *v in cell.thumbnailViews) {
                CGPoint point = [gr locationInView:v];
                if (CGRectContainsPoint(v.bounds, point) && v.asset != nil) {
                    _swipeSelectionState = !v.selected;
                    _shouldAllowPan = YES;
                    [v toggleSelection];
                    return;
                }
            }
        }
    }
}

- (void)onPanGesture:(UIPanGestureRecognizer *)gr {
    if (gr.state != UIGestureRecognizerStateCancelled) {
        if (_shouldAllowPan || gr == _horizontalPanGestureRecognizer) {
            for (BMMLPAssetCell *cell in [self.tableView visibleCells]) {
                for (BMMLPAssetThumbnailView *v in cell.thumbnailViews) {
                    CGPoint point = [gr locationInView:v];
                    if (CGRectContainsPoint(v.bounds, point) && (_swipeSelectionState != v.selected) && v.asset != nil) {
                        if (![v toggleSelection]) {
                            //Cancel gesture
                            gr.enabled = NO;
                            gr.enabled = YES;
                        }
                    }
                }
            }
        }
    }
    if(gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateFailed || gr.state == UIGestureRecognizerStateCancelled) {
        _shouldAllowPan = NO;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gr {
    if ((self.swipeSelectionMode & BMMLPSwipeSelectionModePan) != BMMLPSwipeSelectionModePan && gr == _horizontalPanGestureRecognizer) {
        return NO;
    } else if ((self.swipeSelectionMode & BMMLPSwipeSelectionModeLongPressPan) != BMMLPSwipeSelectionModeLongPressPan && gr != _horizontalPanGestureRecognizer) {
        return NO;
    } else if(gr == _panGestureRecognizer && !_shouldAllowPan) {
        return NO;
    } else if (gr != _panGestureRecognizer && _shouldAllowPan) {
        return NO;
    }
    if (gr == _horizontalPanGestureRecognizer) {
        for (BMMLPAssetCell *cell in [self.tableView visibleCells]) {
            for (BMMLPAssetThumbnailView *v in cell.thumbnailViews) {
                CGPoint point = [gr locationInView:v];
                if (CGRectContainsPoint(v.bounds, point)) {
                    if (v.asset == nil) {
                        return NO;
                    } else {
                        _swipeSelectionState = !v.selected;
                    }
                }
            }
        }
    }
    return YES;
}

#pragma mark BMAssetDelegate implementation

- (BOOL)assetThumbnailView:(BMMLPAssetThumbnailView *)assetView shouldChangeSelectionStatus:(BOOL)selected {
    
    NSUInteger maxTotal = [self.delegate assetTablePicker:self maxNumberOfSelectableAssetsOfKind:BMMediaKindUnknown];
    
    if (selected) {
        if (![self.delegate assetTablePicker:self allowNewSelectionOfKind:assetView.asset.mediaKind]) {
            return NO;
        }
        
        if (maxTotal == 1) {
            [self performSelector:@selector(doneAction:) withObject:nil afterDelay:0.0];
        }
    }
    return YES;
}

- (void)assetThumbnailView:(BMMLPAssetThumbnailView *)assetView didChangeSelectionStatus:(BOOL)selected {
    if (selected && assetView.asset && ![selectedAssets containsObject:assetView.asset]) {
        [selectedAssets addObject:assetView.asset];
    } else if (!selected) {
        [selectedAssets removeObject:assetView.asset];
    }
}

#pragma mark - Other methods

- (int)totalSelectedAssetsOfKind:(BMMediaKind)mediaKind {
    int count = 0;
    for (ALAsset *asset in selectedAssets) {
		if((asset.mediaKind & mediaKind)) 
        {            
            count++;	
		}
	}
    return count;
}

- (int)totalSelectedAssets {
    return [self totalSelectedAssetsOfKind:(BMMediaKindPicture | BMMediaKindVideo)];
}

@end

@implementation BMMLPAssetTablePicker(Private)

- (BMMediaKind)supportedMediaKinds {
    BMMediaKind supportedMediaKinds = BMMediaKindUnknown;
    if ([self.delegate assetTablePicker:self maxNumberOfSelectableAssetsOfKind:BMMediaKindPicture] > (NSUInteger)0) {
        supportedMediaKinds |= BMMediaKindPicture;
    }
    if ([self.delegate assetTablePicker:self maxNumberOfSelectableAssetsOfKind:BMMediaKindVideo] > (NSUInteger)0) {
        supportedMediaKinds |= BMMediaKindVideo;
    }
    return supportedMediaKinds;
}

- (NSInteger)numberOfCellsPerRow {
    return [BMMLPAssetCell numberOfThumbnailsForWidth:self.view.frame.size.width];
}

-(NSArray*)assetsForIndexPath:(NSIndexPath*)_indexPath {
    
    NSInteger numberOfCellsPerRow = self.numberOfCellsPerRow;
    int index = (_indexPath.row * numberOfCellsPerRow);
    int maxIndex = MIN(index + numberOfCellsPerRow, selectableAssets.count);
    
    NSMutableArray *ret = [NSMutableArray array];
    for (int i = index; i < maxIndex; ++i) {
        [ret addObject:[selectableAssets objectAtIndex:i]];
    }
    return ret;    
}

- (void)updateView {
    BMMediaKind supportedMediaKinds = self.supportedMediaKinds;
    BMMediaKind effectiveSupportedMediaKinds = (supportedMediaKinds & filteredMediaKinds);
    [self updateSelectableAssets:effectiveSupportedMediaKinds];
    [self.tableView reloadData];
    NSInteger maxRow = [self tableView:self.tableView numberOfRowsInSection:0] - 1;
    if (maxRow >= 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:maxRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];    
    }
    
    NSInteger photoCount = photoAssets.count;
    NSInteger videoCount = videoAssets.count;
    [self setTitle:NSLocalizedString(@"Pick Media", nil)];
    
    if ((effectiveSupportedMediaKinds & BMMediaKindVideo) &&  (effectiveSupportedMediaKinds & BMMediaKindPicture)) {
        footerLabel.text = [NSString stringWithFormat:@"%d %@, %d %@", photoCount, NSLocalizedString(@"photos", nil), videoCount, NSLocalizedString(@"videos", nil)];
    } else if ((effectiveSupportedMediaKinds & BMMediaKindVideo)) {
        footerLabel.text = [NSString stringWithFormat:@"%d %@", videoCount, NSLocalizedString(@"videos", nil)];
    } else {
        footerLabel.text = [NSString stringWithFormat:@"%d %@", photoCount, NSLocalizedString(@"photos", nil)];
    }
}

- (void)setAssets:(NSArray *)theAssets {
    [activityIndicator stopAnimating];
    [assets removeAllObjects];
    for (ALAsset *asset in theAssets) {
        BMMediaKind mediaKind = asset.mediaKind;
        if (mediaKind == BMMediaKindVideo) {
            [videoAssets addObject:asset];
        } else if (asset.mediaKind == BMMediaKindPicture) {
            [photoAssets addObject:asset];
        }
        [assets addObject:asset];
    }
    [self updateView];
}

-(void)preparePhotos:(NSArray *)args {
    @autoreleasepool {
    
        NSNumber *n = [args objectAtIndex:0];
        
        BMMediaKind supportedMediaKinds = [n intValue];
        
        NSArray *supUTIs = args.count > 1 ? [args objectAtIndex:1] : nil;
        
        NSMutableArray *theAssets = [NSMutableArray array];
        
        [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {         
            if(result == nil) {
                *stop = YES;
            } else if ((result.mediaKind & supportedMediaKinds)) {
                BOOL supportedUTI = NO;
                if (supUTIs) {
                    NSArray *utis = [result valueForProperty:ALAssetPropertyRepresentations];
                    for (NSString *uti in utis) {
                        if ([supUTIs containsObject:uti]) {
                            supportedUTI = YES;
                            break;
                        }
                    }
                } else {
                    supportedUTI = YES;
                }
                if (supportedUTI) {
                    [theAssets addObject:result];
                }
            }
        }];    
        
        [self performSelectorOnMainThread:@selector(setAssets:) withObject:theAssets waitUntilDone:NO];
    
    }
    
}

- (void)updateSelectableAssets:(BMMediaKind)mediaKinds {
    if ((mediaKinds & BMMediaKindVideo) && (mediaKinds & BMMediaKindPicture)) {
        selectableAssets = assets;
    } else if ((mediaKinds & BMMediaKindVideo)) {
        selectableAssets = videoAssets;
    } else {
        selectableAssets = photoAssets;
    }
}

@end
