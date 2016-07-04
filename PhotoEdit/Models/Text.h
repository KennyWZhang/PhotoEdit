//
//  Text.h
//  PhotoEdit
//
//  Created by Artur Sahakyan on 6/21/16.
//  Copyright © 2016 Feghal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
 * Saving all properties by NSUserDefaults
 * @return void
 */
- (void)save;

/**
 * Load values from NSuserDefaults , and set propertyes
 * @return void
 */
- (void)load;

/**
 * Getting all non-system font names
 * @return NSMutableArray
 */
- (NSMutableArray *)getNonSystemFontNames;

@end
