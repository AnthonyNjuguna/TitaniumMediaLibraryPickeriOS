//
//  AlbumPickerController.m
//
//  Created by Werner Altewischer on 2/15/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import "BMMLPAlbumPickerController.h"
#import "BMMLPImagePickerController.h"
#import "BMMLPAssetTablePicker.h"
#import "BMMLPStyle.h"

@interface BMMLPAlbumPickerController(Private)

-(void)loadAlbums;
-(void)reloadTableView;

@end

@implementation BMMLPAlbumPickerController

@synthesize delegate, assetGroups, library;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"Loading...", nil)];
    
    self.tableView.rowHeight = 57;
	
    if (!library) {
        library = [[ALAssetsLibrary alloc] init];
    }
    
	self.assetGroups = [NSMutableArray array];
    
    self.tableView.backgroundColor = [[BMMLPStyle instance] tableViewBackgroundColor];
    
    if ([[BMMLPStyle instance] tableViewSeparatorColor]) {
        self.tableView.separatorColor = [[BMMLPStyle instance] tableViewSeparatorColor];
    }

    [self loadAlbums];
}

- (void)viewDidUnload {
	self.assetGroups = nil;
    BM_RELEASE_SAFELY(library);
    [super viewDidUnload];
}

- (void)dealloc {	
    if ([self isViewLoaded]) {
        [self viewDidUnload];
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [assetGroups count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get count
    ALAssetsGroup *g = (ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row];
    NSInteger gCount = [g numberOfAssets];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[g valueForProperty:ALAssetsGroupPropertyName], gCount];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row] posterImage]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:[BMMLPStyle instance].tableViewCellSelectionStyle];
    
    if ([[BMMLPStyle instance] tableViewCellTextColor]) {
        cell.textLabel.textColor = [[BMMLPStyle instance] tableViewCellTextColor];
    }
    
    return cell;
}

- (void)openAssetsGroupAtIndex:(NSUInteger)index {
    if (index < assetGroups.count && self.navigationController.topViewController == self) {
        ALAssetsGroup *assetGroup = [assetGroups objectAtIndex:index];
 
        BMMLPAssetTablePicker *picker = [[BMMLPAssetTablePicker alloc] initWithNibName:ASSET(@"BMAssetTablePicker") bundle:nil];
        picker.delegate = self.delegate;
        
        picker.assetGroup = assetGroup;
        [self.navigationController pushViewController:picker animated:YES];
    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self openAssetsGroupAtIndex:indexPath.row];
}

@end

@implementation BMMLPAlbumPickerController(Private)

- (void)finishLoading {
    [self reloadTableView];
    if ([self.albumPickerDelegate respondsToSelector:@selector(albumPicker:didFinishLoadingAssetGroups:)]) {
        [self.albumPickerDelegate albumPicker:self didFinishLoadingAssetGroups:self.assetGroups];
    }
}

- (void)loadAlbums {
    @autoreleasepool {
    
    // Group enumerator Block
        void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
        {
            if (group == nil) 
            {
                // Reload albums
                [self performSelectorOnMainThread:@selector(finishLoading) withObject:nil waitUntilDone:NO];
                *stop = YES;
            } else {
                [self.assetGroups addObject:group];
                
                // Keep this line!  w/o it the asset count is broken for some reason.  Makes no sense
                [group numberOfAssets];
            }
        };
        
        // Group Enumerator Failure Block
        void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Album error", nil),[error localizedDescription]] delegate:nil
                                                   cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alert show];
            
            LogWarn(@"A problem occured %@", [error description]);	                                 
        };	
        
        // Enumerate Albums
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:assetGroupEnumerator 
                             failureBlock:assetGroupEnumberatorFailure];
    
    }
}

-(void)reloadTableView {
	[self setTitle:NSLocalizedString(@"Albums", nil)];
	[self.tableView reloadData];
}


@end