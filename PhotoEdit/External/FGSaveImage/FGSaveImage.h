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
 * FGSaveImage is class to save, add, replace, and remove images in/from folder in documents directory
 * also methods crate folder if not exist
 */
@interface FGSaveImage : NSObject

/**
 * Add image to "Images" folder in documents directory
 * @param photo is image that must be added
 * @param folderName name of folder that you crate before, pass nil if you don't
 *
 */
- (void)addImage:(UIImage *)photo toFolder:(NSString *)folderName;

/**
 * Replaacing image in folder in documents directory
 * @param generatedPhoto new photo to replace
 * @param folderName name of folder that you crate before, pass nil if you don't
 *
 * @param  imageToReplace image that will be replaced
 */
- (void)replace:(UIImage *)imageToRelace
      withImage:(UIImage *)generatedImage
       inFolder:(NSString *)folderName;

/**
 * Remove image from folder in documents directory
 *
 *  @param removeImage image that must be removed
 * @param folderName name of folder that you crate before, pass nil if you don't
 *
 */
- (void)removeImage:(UIImage *)removeImage fromFolder:(NSString *)folderName;

/**
 * fetch all images from  folder in documents directory
 * @param folderName name of folder that you crate before, pass nil if you don't
 *
 * @return fetched Images
 */
- (NSArray *)fetchImagesFromFolder:(NSString *)folderName;

/**
 * remove All images from folder in documents directory
 * @param folderName name of folder that you crate before, pass nil if you don't
 */
- (void)removeAllImagesFromFolder:(NSString *)folderName;

/**
 * Save an array of images in folder in documents directory
 * @param photos must be array of images
 * @param folderName name of folder that you crate before, pass nil if you don't
 *
 */
- (void)saveImages:(NSArray *)photos inFolder:(NSString *)folderName;

/**
 * Remove image from  folder in documents directory
 *
 *  @param removeIndex image index that must be removed , if you used "saveImages" method, must be index of image in
 * array
 * @param folderName name of folder that you crate before, pass nil if you don't
 */
- (void)removeImageAtIndex:(int)removeIndex fromFolder:(NSString *)folderName;

/**
 *  get image from folder in documents directory
 *
 *  @param index image index that must be returned , if you used "saveImages" method, must be index of image in
 * that array
 * @param folderName name of folder that you crate before, pass nil if you don't
 *  @return getted image
 */
- (UIImage *)getImageAtIndex:(int)index fromFolder:(NSString *)folderName;

/**
 * Customize folder name in documents directory, if you use init folder name will be "Images" by default
 *
 * @param name name of the folder that will be crated in documents directory
 *
 */
- (instancetype)initWithFolderName:(NSString *)name;

/**
 *  Crate folder in documents directory
 *
 *  @param name name of folder that will be crated
 */
- (void)crateFolderNamed:(NSString *)name;

/**
 *  Remove folder from documents directory ,that you crate before
 *
 *  @param name name of folder
 */
- (void)removeFolderNamed:(NSString *)name;

/**
 * Remove all folders from documents directory
 */
- (void)removeAllFolders;

@end