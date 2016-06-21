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

- (void)saveImages:(NSMutableArray *)photos;
- (void)addImageToDocuments:(NSMutableArray *)photos ByIndex:(int)i;
- (void)rewriteImage:(UIImage *)generatedPhoto imageToReplace:(UIImage *)imageToreplace ByIndex:(int)rewriteIndex;
- (NSMutableArray *)loadImages;

@end
