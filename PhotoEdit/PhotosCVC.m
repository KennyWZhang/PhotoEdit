//
//  PhotosCVC.m
//  PhotoEdit
//
//  Created by Artur Sahakyan on 6/9/16.
//  Copyright © 2016 Feghal. All rights reserved.
//

#import "PhotosCVC.h"

#import "PhotosCVCell.h"
#import "EditVC.h"
#import "HelpPageVC.h"
#import "SaveLoadImages.h"

@interface PhotosCVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    SaveLoadImages *sli;
    NSMutableArray *photos;
    int lastIndex;
    int rewriteIndex;
    BOOL showDelete;
    BOOL add;
    BOOL firstAppear;
    BOOL deleteTapped;
    BOOL notFirstTimeinApp;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end

@implementation PhotosCVC

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - ViewController Lifecycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    lastIndex = (int)photos.count;
    for(UIView *temp in self.navigationController.navigationBar.subviews) {
        [temp setExclusiveTouch:YES];
    }
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"firstTime"]) {
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstTime"];
        notFirstTimeinApp = [[NSKeyedUnarchiver unarchiveObjectWithData:data] boolValue];
    }
    if(!notFirstTimeinApp) {
        notFirstTimeinApp = YES;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSData* userData = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithBool:notFirstTimeinApp]];
        [prefs setObject:userData forKey:@"firstTime"];
        [prefs synchronize];
        HelpPageVC *hp = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HelpPageVC"];
        [self.navigationController pushViewController:hp animated:YES];
    }
    firstAppear = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.toolbar setHidden: YES];
    
    photos = [NSMutableArray new];
    sli = [SaveLoadImages new];
    
    photos = [sli loadImages];
    [self.collectionView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:YES];
    for(int i = 0; i < photos.count; i++) {
        if([photos[i] isEqual:self.imageToReplace] && self.generatedImage) {
            photos[i] = self.generatedImage;
        }
    }
    if(add) {
        lastIndex = (int)photos.count - 1;
        [sli addImageToDocuments:photos ByIndex:lastIndex];
        add = NO;
    } else if(!firstAppear) {
        [sli rewriteImage:self.generatedImage imageToReplace:self.imageToReplace ByIndex:rewriteIndex];
    }
    firstAppear = NO;
    [self.collectionView reloadData];
}


#pragma mark - Actions -

- (IBAction)editButtontapped:(UIBarButtonItem *)sender {
    showDelete = !showDelete;
    if(self.collectionView.backgroundColor == [UIColor whiteColor]) {
        self.navigationItem.rightBarButtonItem = nil;
        [self.editButton setTitle: @"Cancel"];
        self.collectionView.backgroundColor = [UIColor colorWithRed:200.f/255.f green:100.f/255.f blue:150.f/255.f alpha:1];
    } else {
        if(deleteTapped) {
            UIView *opacityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.collectionView.contentSize.width,self.collectionView.contentSize.height)];
            opacityView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
            [self.collectionView addSubview:opacityView];
            self.collectionView.userInteractionEnabled = NO;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [self.editButton setEnabled:NO];
                [self.addButton setEnabled:NO];
                [sli saveImages:photos];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.addButton setEnabled:YES];
                    [self.editButton setEnabled:YES];
                    self.collectionView.userInteractionEnabled = YES;
                    [opacityView removeFromSuperview];
                });
            });
            deleteTapped = NO;
        }
        self.navigationItem.rightBarButtonItem = self.addButton;
        [self.editButton setTitle: @"Edit"];
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    [self.collectionView reloadData];
}

- (IBAction)addButtonTapped:(UIBarButtonItem *)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate -

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [photos addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [picker dismissViewControllerAnimated:YES completion:nil];
    add = YES;
}

#pragma mark - UICollectionViewDataSource -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotosCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setExclusiveTouch:YES];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.image = photos[indexPath.row];
    
    if(showDelete) {
        [cell.deleteImageView.layer removeAllAnimations];
        [cell.imageView.layer removeAllAnimations];
        [cell.deleteImageView setHidden:NO];
        CGRect dFrame = cell.deleteImageView.frame;
        [UIView transitionWithView:cell.deleteImageView duration:0.15 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
            cell.deleteImageView.frame = CGRectMake(dFrame.origin.x, dFrame.origin.y , dFrame.size.width + 3,dFrame.size.height + 3);
            cell.deleteImageView.frame = CGRectMake(dFrame.origin.x , dFrame.origin.y , dFrame.size.width - 3, dFrame.size.height - 3);
        }completion:^(BOOL finished) {
            if(finished) {
                cell.deleteImageView.frame = dFrame;
            }
        }];
        CGRect frame = cell.imageView.frame;
        [UIView transitionWithView:cell.imageView duration:0.5 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
            cell.imageView.frame = CGRectMake(frame.origin.x , frame.origin.y, frame.size.width + 8, frame.size.height + 8);
            cell.imageView.frame = CGRectMake(frame.origin.x , frame.origin.y, frame.size.width - 8, frame.size.height - 8);
        } completion:^(BOOL finished) {
            if(finished) {
                cell.imageView.frame = frame;
            }
        }];
        cell.deleteImageView.frame = dFrame;
        cell.imageView.frame = frame;
    } else {
        [cell.deleteImageView.layer removeAllAnimations];
        [cell.deleteImageView setHidden:YES];
        [cell.imageView.layer removeAllAnimations];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate -

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(showDelete) {
        deleteTapped = YES;
        [photos removeObjectAtIndex:indexPath.row];
        [collectionView reloadData];
    } else {
        EditVC *evc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"EditVC"];
        evc.photo = photos[indexPath.row];
        rewriteIndex = (int)indexPath.row;
        [self.navigationController pushViewController:evc animated:YES];
    }
    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake (self.view.bounds.size.width / 2.03 , self.view.bounds.size.width /1.93 );
}

@end
