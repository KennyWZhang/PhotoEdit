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

@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *backround;
@property (strong, nonatomic) NSString *size;
@property (strong, nonatomic) NSString *style;

- (void)save;
- (void)load;
- (NSMutableArray *)getNonSystemFontNames;

@end
