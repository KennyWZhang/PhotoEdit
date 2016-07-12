//
//  FGSaveImage.m
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

#import "FGSaveImage.h"

@interface FGSaveImage() {
    NSString *customName;
}

@end

@implementation FGSaveImage

- (instancetype)init {
    return [self initWithFolderName:@"/Images"];
}

- (instancetype)initWithFolderName:(NSString *)name {
    self = [super init];
    if(self) {
        customName = [NSString stringWithFormat:@"/%@", name];
    }
    return self;
}

- (void)saveImages:(NSMutableArray *)photos {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:customName];
    
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
        NSString *imageName = [NSString stringWithFormat:@"%d.png", i];
        NSString *imagePath = [dataPath stringByAppendingPathComponent:imageName];
        NSData *data = [NSData dataWithData:UIImagePNGRepresentation(image)];
        [data writeToFile:imagePath atomically:YES];
        i++;
    }
}

- (void)addImageToDocuments:(UIImage *)photo {
    photo = [self rotateImage:photo];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:customName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSArray *fileArray = [fileMgr contentsOfDirectoryAtPath:dataPath error:nil];
        NSString *lastImageName = [fileArray.lastObject stringByReplacingOccurrencesOfString:@".png" withString:@""];
        int i = [lastImageName intValue];
        if(fileArray.count > 0) {
            i++;
        }
        NSString *imageName = [NSString stringWithFormat:@"%d.png", i];
        NSString *imagePath = [dataPath stringByAppendingPathComponent:imageName];
        NSData *data = [NSData dataWithData:UIImagePNGRepresentation(photo)];
        [data writeToFile:imagePath atomically:YES];
    });
}

- (void)replace:(UIImage *)imageToRelace withImage:(UIImage *)generatedImage {
    if(!imageToRelace || !generatedImage) {
        return;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:customName];
    
    NSArray *docFiles = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:dataPath error:NULL];
    int rewriteIndex = 0;
    NSString *fullPath;
    NSData *imgData;
    UIImage *loadedImage;
    for (NSString *fileName in docFiles) {
        if([fileName hasSuffix:@".png"]) {
            fullPath = [dataPath stringByAppendingPathComponent:fileName];
            imgData = [NSData dataWithContentsOfFile:fullPath];
            loadedImage = [UIImage imageWithData:imgData];
            if([UIImagePNGRepresentation(imageToRelace) isEqualToData:UIImagePNGRepresentation(loadedImage)]) {
                rewriteIndex = [[fileName stringByReplacingOccurrencesOfString:@".png" withString:@""] intValue];
            }
        }
    }
    NSString *imageName = [NSString stringWithFormat:@"%d.png", rewriteIndex];
    NSString *imagePath = [dataPath stringByAppendingPathComponent:imageName];
    NSData *data;
    if(generatedImage) {
        data = [NSData dataWithData:UIImagePNGRepresentation(generatedImage)];
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
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:customName];
    NSArray *docFiles = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:dataPath error:NULL];
    NSString *fullPath;
    NSData *imgData;
    UIImage *loadedImage;
    for (NSString *fileName in docFiles) {
        if([fileName hasSuffix:@".png"]) {
            fullPath = [dataPath stringByAppendingPathComponent:fileName];
            imgData = [NSData dataWithContentsOfFile:fullPath];
            loadedImage = [UIImage imageWithData:imgData];
            if(loadedImage) {
                [photos addObject:loadedImage];
            }
        }
    }
    return photos;
}

- (void)removeImage:(UIImage *)removeImage {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:customName];
        
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSMutableArray *fileArray = [[fileMgr contentsOfDirectoryAtPath:dataPath error:nil] mutableCopy];
        
        int removeIndex = 0;
        UIImage *loadedImage;
        NSData *imgData;
        NSString *fullPath;
        for (NSString *fileName in fileArray) {
            if([fileName hasSuffix:@".png"]) {
                fullPath = [dataPath stringByAppendingPathComponent:fileName];
                imgData = [NSData dataWithContentsOfFile:fullPath];
                loadedImage = [UIImage imageWithData:imgData];
                if([UIImagePNGRepresentation(removeImage) isEqualToData:UIImagePNGRepresentation(loadedImage)]) {
                    removeIndex = [[fileName stringByReplacingOccurrencesOfString:@".png" withString:@""] intValue];
                }
            }
        }
        NSString *name = [NSString stringWithFormat:@"%d.png",removeIndex];
        [fileMgr removeItemAtPath:[dataPath stringByAppendingPathComponent:name] error:NULL];
        [fileArray removeObject:name];
        int i =0;
        for(NSString *filename in fileArray) {
            [fileMgr moveItemAtPath:[dataPath stringByAppendingPathComponent:filename] toPath:[dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png" , i]] error:nil];
            i++;
        }
    });
}

- (void)removeImageAtIndex:(int)removeIndex {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:customName];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *fileArray = [fileMgr contentsOfDirectoryAtPath:dataPath error:nil];
    NSString *name = [NSString stringWithFormat:@"%d.png",removeIndex];
    for (NSString *filename in fileArray) {
        if(name == filename) {
            [fileMgr removeItemAtPath:[dataPath stringByAppendingPathComponent:filename] error:NULL];
        }
    }
    fileArray = [fileMgr contentsOfDirectoryAtPath:dataPath error:nil];
    int i =0;
    for(NSString *filename in fileArray) {
        [fileMgr moveItemAtPath:[dataPath stringByAppendingPathComponent:filename] toPath:[dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png" , i]] error:nil];
        i++;
    }
}

- (UIImage *)rotateImage:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp) {
        return image;
    }
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(CGPointZero.x, CGPointZero.y, image.size.width, image.size.height)];
    UIImage *copy = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return copy;

}

@end