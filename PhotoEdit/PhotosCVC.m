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


@interface PhotosCVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) NSMutableArray * photos;
@property (assign, nonatomic) BOOL showDelete;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end

@implementation PhotosCVC

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - ViewController Lifecycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.toolbar setHidden: YES];
    self.photos = [NSMutableArray new];
    [self loadImages];
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
    [self saveImages];
    [self.collectionView reloadData];
}

#pragma mark - Actions -

- (IBAction)editButtontapped:(UIBarButtonItem *)sender {
    self.showDelete = !self.showDelete;
    if(self.collectionView.backgroundColor == [UIColor whiteColor]) {
        [self.editButton setTitle: @"Cancel"];
        self.collectionView.backgroundColor = [UIColor colorWithRed:200.f/255.f green:100.f/255.f blue:150.f/255.f alpha:1];
    } else {
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

/// - saving images into directory -

- (void)saveImages {
    UIView *opacityView = [[UIView alloc] initWithFrame:self.collectionView.frame];
    opacityView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
    [self.collectionView addSubview:opacityView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self.addButton setEnabled:NO];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSArray *fileArray = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
        for (NSString *filename in fileArray)  {
            [fileMgr removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
        
        int i = 0;
        for(UIImage *image in self.photos) {
            NSString *imageName = [NSString stringWithFormat:@"%d.jpeg", i++];
            NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
            NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];
            [data writeToFile:imagePath atomically:YES];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.addButton setEnabled:YES];
            [opacityView removeFromSuperview];
        });
    });
}

- (void)loadImages {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *docFiles = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    for (NSString *fileName in docFiles) {
        if([fileName hasSuffix:@".jpeg"]) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:fileName];
            NSData *imgData = [NSData dataWithContentsOfFile:fullPath];
            UIImage *loadedImage = [[UIImage alloc] initWithData:imgData];
            if(loadedImage) {
                [self.photos addObject:loadedImage];
            }
        }
    }
}


#pragma mark - UIImagePickerControllerDelegate -

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self.photos addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [picker dismissViewControllerAnimated:YES completion:nil];
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
        [self.photos removeObjectAtIndex:indexPath.row];
        [self saveImages];
        [collectionView reloadData];
    } else {
        EditVC *evc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"EditVC"];
        evc.photo = self.photos[indexPath.row];
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
