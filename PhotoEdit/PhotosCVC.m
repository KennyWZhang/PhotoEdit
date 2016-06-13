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

@property (strong, nonatomic) NSMutableArray * photos;
@property (assign, nonatomic) BOOL showDelete;

@end

@implementation PhotosCVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.navigationController.toolbarHidden = NO;
    [super viewDidLoad];
    self.photos = [NSMutableArray new];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"Photos"]) {
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Photos"];
        self.photos = [[NSKeyedUnarchiver unarchiveObjectWithData:data]mutableCopy];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for(int i = 0; i < self.photos.count; i++) {
        if([self.photos[i] isEqual:self.imageToReplace]) {
            self.photos[i] = self.generatedImage;
        }
    }
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.photos];
    [prefs setObject:data forKey:@"Photos"];
    [prefs synchronize];
    
    [self.collectionView reloadData];
}

- (IBAction)editButtontapped:(UIBarButtonItem *)sender {
    self.showDelete = !self.showDelete;
    if(self.collectionView.backgroundColor == [UIColor whiteColor]) {
        self.collectionView.backgroundColor = [UIColor colorWithRed:200.f/255.f green:60.f/255.f blue:10.f/255.f alpha:1];
    } else {
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

#pragma mark <UIImagePickerControllerDelegate>

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    for(UIImage *image in self.photos) {
        if([UIImagePNGRepresentation(pickedImage) isEqualToData:UIImagePNGRepresentation(image)]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Erorr"
                                                                           message:@"This photo allways exist , please add another one"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
            [alert addAction:done];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
    [self.photos addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [self.collectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotosCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.image = self.photos[indexPath.row];
    
    if(self.showDelete) {
        [cell.deleteImageView setHidden:NO];
        [UIView transitionWithView:cell.deleteImageView duration:0.1 options:UIViewAnimationOptionRepeat animations:^{
            cell.deleteImageView.frame = CGRectMake(cell.deleteImageView.frame.origin.x + 3, cell.deleteImageView.frame.origin.y + 3, cell.deleteImageView.frame.size.width, cell.deleteImageView.frame.size.height);
        }completion:nil];
    } else {
        [cell.deleteImageView setHidden:YES];
        cell.deleteImageView.frame = CGRectMake(cell.deleteImageView.frame.origin.x - 3, cell.deleteImageView.frame.origin.y - 3, cell.deleteImageView.frame.size.width, cell.deleteImageView.frame.size.height);
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.showDelete) {
        [self.photos removeObjectAtIndex:indexPath.row];
        [self.collectionView reloadData];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.photos];
        [prefs setObject:data forKey:@"Photos"];
        [prefs synchronize];
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
