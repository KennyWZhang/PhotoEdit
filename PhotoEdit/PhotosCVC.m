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

@interface PhotosCVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

@property (strong, nonatomic) NSMutableArray * photos;
@property (strong, nonatomic) SaveLoadImages *sli;
@property (assign, nonatomic) int i;
@property (assign, nonatomic) int rewriteIndex;
@property (assign, nonatomic) BOOL showDelete;
@property (assign, nonatomic) BOOL add;
@property (assign, nonatomic) BOOL firstAppear;
@property (assign, nonatomic) BOOL deleteTapped;
@property (assign,nonatomic) BOOL notFirstTimeinApp;

@end

@implementation PhotosCVC

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - ViewController Lifecycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.i = (int)self.photos.count;
    for(UIView *temp in self.navigationController.navigationBar.subviews) {
        [temp setExclusiveTouch:YES];
    }
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"firstTime"]) {
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstTime"];
        self.notFirstTimeinApp = [[NSKeyedUnarchiver unarchiveObjectWithData:data] boolValue];
    }
    if(!self.notFirstTimeinApp) {
        self.notFirstTimeinApp = YES;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSData* userData = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithBool:self.notFirstTimeinApp]];
        [prefs setObject:userData forKey:@"firstTime"];
        [prefs synchronize];
        HelpPageVC *hp = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HelpPageVC"];
        [self.navigationController pushViewController:hp animated:YES];
    }
    self.firstAppear = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.toolbar setHidden: YES];
    
    self.photos = [NSMutableArray new];
    self.sli = [SaveLoadImages new];
    
    self.photos = [self.sli loadImages];
    [self.collectionView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:YES];
    for(int i = 0; i < self.photos.count; i++) {
        if([self.photos[i] isEqual:self.imageToReplace] && self.generatedImage) {
            self.photos[i] = self.generatedImage;
        }
    }
    if(self.add) {
        self.i = (int)self.photos.count - 1;
        [self.sli addImageToDocuments:self.photos ByIndex:self.i];
        self.add = NO;
    } else if(!self.firstAppear) {
        [self.sli rewriteImage:self.generatedImage imageToReplace:self.imageToReplace ByIndex:self.rewriteIndex];
    }
    self.firstAppear = NO;
    [self.collectionView reloadData];
}


#pragma mark - Actions -

- (IBAction)editButtontapped:(UIBarButtonItem *)sender {
    self.showDelete = !self.showDelete;
    if(self.collectionView.backgroundColor == [UIColor whiteColor]) {
        self.navigationItem.rightBarButtonItem = nil;
        [self.editButton setTitle: @"Cancel"];
        self.collectionView.backgroundColor = [UIColor colorWithRed:200.f/255.f green:100.f/255.f blue:150.f/255.f alpha:1];
    } else {
        if(self.deleteTapped) {
            UIView *opacityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.collectionView.contentSize.width,self.collectionView.contentSize.height)];
            opacityView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
            [self.collectionView addSubview:opacityView];
            self.collectionView.userInteractionEnabled = NO;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [self.editButton setEnabled:NO];
                [self.addButton setEnabled:NO];
                [self.sli saveImages:self.photos];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.addButton setEnabled:YES];
                    [self.editButton setEnabled:YES];
                    self.collectionView.userInteractionEnabled = YES;
                    [opacityView removeFromSuperview];
                });
            });
            self.deleteTapped = NO;
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
    [self.photos addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.add = YES;
}

#pragma mark - UICollectionViewDataSource -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotosCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setExclusiveTouch:YES];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.image = self.photos[indexPath.row];
    
    if(self.showDelete) {
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
    if(self.showDelete) {
        self.deleteTapped = YES;
        [self.photos removeObjectAtIndex:indexPath.row];
        [collectionView reloadData];
    } else {
        EditVC *evc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"EditVC"];
        evc.photo = self.photos[indexPath.row];
        self.rewriteIndex = (int)indexPath.row;
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
