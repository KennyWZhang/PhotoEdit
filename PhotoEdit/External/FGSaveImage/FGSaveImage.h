//
//  FGSaveImage.h
//  FGSaveImage
//
//  Created by Artur Sahakyan on 7/11/16.
//  Copyright © 2016 Feghal. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * FGSaveImage is class to save, add, replace, and remove images in/from "Images" folder in documents directory
 * also methods crate folder if not exist
 */
@interface FGSaveImage : NSObject

/**
 * Delete all images and save an array of images in "Images" folder in documents directory
 * @param photos must be array of images
 *
 * @warning this method removing all images from folder and add new array that (not recommended)
 *
 */
- (void)saveImages:(NSMutableArray *)photos;

/**
 * Add image to "Images" folder in documents directory
 * @param photo is image that must be added
 *
 */
- (void)addImageToDocuments:(UIImage *)photo;

/**
 * Replaacing image in "Images" folder in documents directory
 * @param generatedPhoto new photo to replace
 * @param  imageToReplace image that will be replaced
 */
- (void)replace:(UIImage *)imageToRelace withImage:(UIImage *)generatedImage;

/**
 * Remove image from "Images" folder in documents directory
 *
 *  @param removeImage image that must be removed
 */
- (void)removeImage:(UIImage *)removeImage;

/**
 * Remove image from "Images" folder in documents directory
 *
 *  @param removeIndex image index that must be removed
 */
- (void)removeImageAtIndex:(int)removeIndex;

/**
 * fetch all images from "Images" folder in documents directory
 * @return fetched Images
 */
- (NSArray *)fetchImages;

/**
 *  Customize folder name in documents directory, if you use init folder name will be "Images" by default
 *
 *  @param name name of the folder that will be crated in documents directory
 */
- (instancetype)initWithFolderName:(NSString *)name;

@end