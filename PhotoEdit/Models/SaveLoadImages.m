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
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Images"];

    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:dataPath]) {
        [fileMgr createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSArray *fileArray = [fileMgr contentsOfDirectoryAtPath:dataPath error:nil];
    for (NSString *filename in fileArray) {
        [fileMgr removeItemAtPath:[dataPath stringByAppendingPathComponent:filename] error:NULL];
    }
    int i = 0;
    for(UIImage *image in photos) {
        NSString *imageName = [NSString stringWithFormat:@"%d.jpeg", i];
        NSString *imagePath = [dataPath stringByAppendingPathComponent:imageName];
        NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];
        [data writeToFile:imagePath atomically:YES];
        i++;
    }
}

- (void)addImageToDocuments:(UIImage *)photo ByIndex:(int)i {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString *imageName = [NSString stringWithFormat:@"%d.jpeg", i];
    NSString *imagePath = [dataPath stringByAppendingPathComponent:imageName];
    NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(photo, 1.0f)];
    [data writeToFile:imagePath atomically:YES];
}

- (void)rewriteImage:(UIImage *)generatedImage
             ByIndex:(int)rewriteIndex {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    NSString *imageName = [NSString stringWithFormat:@"%d.jpeg", rewriteIndex];
    NSString *imagePath = [dataPath stringByAppendingPathComponent:imageName];
    NSData *data;
    if(generatedImage) {
        data = [NSData dataWithData:UIImageJPEGRepresentation(generatedImage, 1.0f)];
    } else {
        return;
    }
    [data writeToFile:imagePath atomically:YES];
}

- (NSArray *)fetchImages {
    NSMutableArray *photos = [NSMutableArray new];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    NSArray *docFiles = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:dataPath error:NULL];
    for (NSString *fileName in docFiles) {
        if([fileName hasSuffix:@".jpeg"]) {
            NSString *fullPath = [dataPath stringByAppendingPathComponent:fileName];
            NSData *imgData = [NSData dataWithContentsOfFile:fullPath];
            UIImage *loadedImage = [[UIImage alloc] initWithData:imgData];
            if(loadedImage) {
                [photos addObject:loadedImage];
            }
        }
    }
    return photos;
}

- (void)removeImageAtIndex:(int)removeIndex {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *fileArray = [fileMgr contentsOfDirectoryAtPath:dataPath error:nil];
    NSString *name = [NSString stringWithFormat:@"%d.jpeg",removeIndex];
    for (NSString *filename in fileArray) {
        if(name == filename) {
            [fileMgr removeItemAtPath:[dataPath stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

@end
