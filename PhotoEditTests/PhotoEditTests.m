//
//  PhotoEditTests.m
//  PhotoEditTests
//
//  Created by Artur Sahakyan on 6/9/16.
//  Copyright © 2016 Feghal. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Text.h"
#import "SaveLoadImages.h"

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
    SaveLoadImages *sli = [SaveLoadImages new];
    UIImage *testImage1 = [UIImage imageNamed:@"help1.jpeg"];
    NSMutableArray *arr1 = [NSMutableArray new];
    
    [arr1 addObject:testImage1];
    [sli saveImages:arr1];
    XCTAssertNotNil([sli loadImages],@"Should load saved images");

}

@end
