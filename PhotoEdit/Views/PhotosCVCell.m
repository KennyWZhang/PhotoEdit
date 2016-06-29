//
//  PhotosCVCell.m
//  PhotoEdit
//
//  Created by Artur Sahakyan on 6/9/16.
//  Copyright © 2016 Feghal. All rights reserved.
//

#import "PhotosCVCell.h"

@implementation PhotosCVCell

- (void)setSelected:(BOOL)selected {
    if(selected && self.deleteImageView.isHidden) {
        self.alpha = 0.5;
    } else {
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.5];
        [self setAlpha:0.5];
        [self setAlpha:1];
        [UIView commitAnimations];
    }
}

@end
