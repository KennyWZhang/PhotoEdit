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
        NSDictionary *text = nil;
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"text"];
        text = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.size = text[@"size"];
        self.color = text[@"color"];
        self.style = text[@"style"];
        self.backround = text[@"backround"];
    }
}

- (NSArray *)getNonSystemFontNames {
    NSMutableArray *names = [NSMutableArray new];
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    [names addObject:@"Default"];
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily) {
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont) {
            [names addObject:[fontNames objectAtIndex:indFont]];
        }
    }
    return names;
}

@end
