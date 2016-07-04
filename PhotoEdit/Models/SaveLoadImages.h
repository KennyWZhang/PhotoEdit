//
//  SaveLoadImages.h
//  PhotoEdit
//
//  Created by Artur Sahakyan on 6/21/16.
//  Copyright © 2016 Feghal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SaveLoadImages : NSObject

/**
 * Deleting all images and saving an array of images in directory
 * @param photos must be NSMutableArray of images
 * @return void
 */
- (void)saveImages:(NSMutableArray *)photos;

/**
 * Add image to Directory
 * @param photos must be NSMutableArray of images
 * @param  i last index of array
 * @return void
 * @warning You must give an array of photos , that's last item will be added
 */
- (void)addImageToDocuments:(NSMutableArray *)photos ByIndex:(int)i;

/**
 * Replaacing image in directory
 * @param generatedPhoto new photo to replace
 * @param  imageToreplace the photo that must be replaced
 * @param  rewriteIndex index of photo that must be replaced
 * @return void
 */
- (void)rewriteImage:(UIImage *)generatedPhoto imageToReplace:(UIImage *)imageToreplace ByIndex:(int)rewriteIndex;

/**
 * Load all images from directory
 * @return NSMutableArray
 */
- (NSMutableArray *)loadImages;

@end
