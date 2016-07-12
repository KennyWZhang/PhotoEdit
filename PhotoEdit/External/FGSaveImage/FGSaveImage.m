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

@implementation FGSaveImage

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
    fileArray = [fileMgr contentsOfDirectoryAtPath:dataPath error:nil];
    int i =0;
    for(NSString *filename in fileArray) {
        [fileMgr moveItemAtPath:[dataPath stringByAppendingPathComponent:filename] toPath:[dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpeg" , i]] error:nil];
        i++;
    }
}

@end