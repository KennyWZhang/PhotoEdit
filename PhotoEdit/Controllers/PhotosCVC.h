//
//  PhotosCVC.h
//  PhotoEdit
//
//  Created by Artur Sahakyan on 6/9/16.
//  Copyright © 2016 Feghal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosCVC : UICollectionViewController

/**
 *  must be edited image, that was generated after tapping fix button
 */
@property (strong, nonatomic) UIImage *generatedImage;

@end
