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

@end

@implementation PhotosCVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photos = [NSMutableArray new];
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
    cell.imageView.image = self.photos[indexPath.row];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    EditVC *evc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"EditVC"];
    evc.photo = self.photos[indexPath.row];
    [self.navigationController pushViewController:evc animated:YES];
    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake (self.view.bounds.size.width / 2.03 , self.view.bounds.size.width /1.93 );
}







@end
