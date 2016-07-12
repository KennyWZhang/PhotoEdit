//
//  Text.h
//  PhotoEdit
//
//  Created by Artur Sahakyan on 6/21/16.
//  Copyright © 2016 Feghal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * Text class is for save text color, backround color, size, style(fontName) in NSUserDefaults
 * and load them
 * @warning you must set properties and then call "save" method to save them
 *
 * @warning when you call "load" method properies will be setted, and you can access them 
 */
@interface Text : NSObject

/**
 * The color of text
 */
@property (strong, nonatomic) UIColor *color;

/**
 * The background color of workspace
 */
@property (strong, nonatomic) UIColor *backround;

/**
 * Size of text
 */
@property (strong, nonatomic) NSString *size;

/**
 * Font name of text
 */
@property (strong, nonatomic) NSString *style;

/**
 * Save all properties by NSUserDefaults
 *
 */
- (void)save;

/**
 * Load values from NSUserDefaults , and set properties
 * 
 */
- (void)load;

/**
 * Get all non-system font names
 * @return font names
 */
- (NSArray *)getNonSystemFontNames;

@end
