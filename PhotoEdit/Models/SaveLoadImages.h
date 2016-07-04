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
 * Delete all images and save an array of images in "Images" folder in documents directory
 * @param photos must be array of images
 *
 */
- (void)saveImages:(NSMutableArray *)photos;

/**
 * Add image to "Images" folder in documents directory
 * @param photos must be array of images
 * @param  i last index of array
 *
 * @warning You must give an array of photos , that's last item will be added
 */
- (void)addImageToDocuments:(NSMutableArray *)photos ByIndex:(int)i;

/**
 * Replaacing image in "Images" folder in documents directory
 * @param generatedPhoto new photo to replace
 * @param  imageToreplace the photo that must be replaced
 * @param  rewriteIndex index of photo that must be replaced
 */
- (void)rewriteImage:(UIImage *)generatedPhoto imageToReplace:(UIImage *)imageToreplace ByIndex:(int)rewriteIndex;

/**
 * Load all images from "Images" folder in documents directory
 * @return fetched Images
 */
- (NSArray *)fetchImages;

@end
