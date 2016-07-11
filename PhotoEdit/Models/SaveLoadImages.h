//
//  SaveLoadImages.h
//  PhotoEdit
//
//  Created by Artur Sahakyan on 6/21/16.
//  Copyright © 2016 Feghal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * SaveLoadImages is class to save, add, replace, and remove images in/from "Images" folder in documents directory
 * also methods crate folder if not exist
 */
@interface SaveLoadImages : NSObject

/**
 * Delete all images and save an array of images in "Images" folder in documents directory
 * @param photos must be array of images
 *
 * @warning this method removing all images from folder and add new array that wise use this method if you don't have
 * other choise , at first take a look to other methods of class
 *
 * @warning this method can block main queue for long time
 */
- (void)saveImages:(NSMutableArray *)photos;

/**
 * Add image to "Images" folder in documents directory
 * @param photo is image that must be added
 * @param  i last index of array
 *
 */
- (void)addImageToDocuments:(UIImage *)photo ByIndex:(int)i;

/**
 * Replaacing image in "Images" folder in documents directory
 * @param generatedPhoto new photo to replace
 * @param  rewriteIndex index of photo that must be replaced
 */
- (void)rewriteImage:(UIImage *)generatedImage ByIndex:(int)rewriteIndex;

/**
 * Remove image from "Images" folder in documents directory
 *
 *  @param removeIndex image index that must be removed
 */
- (void)removeImageAtIndex:(int)removeIndex;

/**
 * Load all images from "Images" folder in documents directory
 * @return fetched Images
 */
- (NSArray *)fetchImages;

@end
