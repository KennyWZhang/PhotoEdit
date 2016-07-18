//
//  PhotoEditTests.m
//  PhotoEditTests
//
//  Created by Artur Sahakyan on 6/9/16.
//  Copyright © 2016 Feghal. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Text.h"
#import "FGSaveImage.h"

@interface PhotoEditTests : XCTestCase

@end

@implementation PhotoEditTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTextMethods {
    Text *text = [Text new];
    text.size = @"13";
    text.style = @"Default";
    text.backround = [UIColor whiteColor];
    text.color = [UIColor blackColor];
    
    [text save];
    [text load];
    
    NSDictionary *dic1 = @{@"size": @"13", @"style": @"Default" , @"backround" : [UIColor whiteColor] , @"color": [UIColor blackColor]};
    NSDictionary *dic2 = @{@"size": text.size, @"style": text.style , @"backround":text.backround , @"color": text.color};
    XCTAssertEqualObjects(dic1, dic2, @"Should saved and loaded dics be equal");
}

- (void)testSavingImages {
    FGSaveImage *sli = [FGSaveImage new];
    UIImage *testImage1 = [UIImage imageNamed:@"help1.jpg"];
    NSMutableArray *arr1 = [NSMutableArray new];
    
    [arr1 addObject:testImage1];
    [sli saveImages:arr1 inFolder:nil];
    XCTAssertNotNil([sli fetchImagesFromFolder:nil],@"Should load saved images");
}

- (void)testGetImage {
    FGSaveImage *sli = [FGSaveImage new];
    UIImage *testImage1 = [UIImage imageNamed:@"help1.jpg"];
    NSMutableArray *arr1 = [NSMutableArray new];
    
    [arr1 addObject:testImage1];
    [sli saveImages:arr1 inFolder:nil];
    XCTAssertNotNil([sli getImageAtIndex:0 fromFolder:nil],@"Should load first image");
}

@end
