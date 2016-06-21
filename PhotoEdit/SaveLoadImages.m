//
//  SaveLoadImages.m
//  PhotoEdit
//
//  Created by Artur Sahakyan on 6/21/16.
//  Copyright © 2016 Feghal. All rights reserved.
//

#import "SaveLoadImages.h"

@implementation SaveLoadImages

- (void)saveImages:(NSMutableArray *)photos {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *fileArray = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
    for (NSString *filename in fileArray) {
        [fileMgr removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
    }
    int i = 0;
    for(UIImage *image in photos) {
        NSString *imageName = [NSString stringWithFormat:@"%d.jpeg", i];
        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
        NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];
        [data writeToFile:imagePath atomically:YES];
        i++;
    }
}

- (void)addImageToDocuments:(NSMutableArray *)photos ByIndex:(int)i {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageName = [NSString stringWithFormat:@"%d.jpeg", i];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(photos.lastObject, 1.0f)];
    [data writeToFile:imagePath atomically:YES];
}

- (void)rewriteImage:(UIImage *)generatedImage
      imageToReplace:(UIImage *)imageToReplace
             ByIndex:(int)rewriteIndex {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageName = [NSString stringWithFormat:@"%d.jpeg", rewriteIndex];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSData *data;
    if(generatedImage) {
        data = [NSData dataWithData:UIImageJPEGRepresentation(generatedImage, 1.0f)];
    } else {
        data = [NSData dataWithData:UIImageJPEGRepresentation(imageToReplace, 1.0f)];
    }
    [data writeToFile:imagePath atomically:YES];
}

- (NSMutableArray *)loadImages {
    NSMutableArray *photos = [NSMutableArray new];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *docFiles = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    for (NSString *fileName in docFiles) {
        if([fileName hasSuffix:@".jpeg"]) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:fileName];
            NSData *imgData = [NSData dataWithContentsOfFile:fullPath];
            UIImage *loadedImage = [[UIImage alloc] initWithData:imgData];
            if(loadedImage) {
                [photos addObject:loadedImage];
            }
        }
    }
    return photos;
}
@end
