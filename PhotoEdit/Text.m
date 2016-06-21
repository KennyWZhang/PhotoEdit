//
//  Text.m
//  PhotoEdit
//
//  Created by Artur Sahakyan on 6/21/16.
//  Copyright © 2016 Feghal. All rights reserved.
//

#import "Text.h"

@implementation Text


- (void)save {
    NSDictionary *text = @{@"size":self.size,@"color":self.color,@"backround":self.backround,@"style":self.style};
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:text];
    [prefs setObject:data forKey:@"text"];
    [prefs synchronize];
}

- (void)load {
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"text"]) {
        NSDictionary *text = [NSDictionary new];
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"text"];
        text = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.size = text[@"size"];
        self.color = text[@"color"];
        self.style = text[@"style"];
        self.backround = text[@"backround"];
    }
}

@end
