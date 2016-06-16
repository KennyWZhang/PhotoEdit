//
//  SODatePickerActionSheet.m
//  Pavlok
//
//  Created by David Sahakyan on 2/16/15.
//  Copyright (c) 2015 Heptacopter. All rights reserved.
//

#import "LGDatePickerActionSheet.h"

#define PICKER_HEIGHT 255
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@interface LGDatePickerActionSheet()

@property (strong, nonatomic) UIView *actionView;

@end

@implementation LGDatePickerActionSheet

- (id)initWithStartDate:(NSDate *)startDate
                endDate:(NSDate *)endDate
      cancelButtonTitle:(NSString *)cancelButtonTitle
          okButtonTitle:(NSString *)okButtonTitle
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    if (self) {
        self.actionView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   SCREEN_SIZE.height,
                                                                   SCREEN_SIZE.width,
                                                                   PICKER_HEIGHT)];
        self.backgroundColor = [UIColor darkGrayColor];
        self.actionView.backgroundColor = [UIColor darkGrayColor];
        
        self.alpha = 0.0;
        
        // Adding buttons
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         SCREEN_SIZE.width,
                                                                         40.0f)];
        NSMutableArray *buttons = [NSMutableArray array];
        
        if (cancelButtonTitle && ![cancelButtonTitle isEqualToString:@""]) {
            // Adding cancel bar button to view
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelButton.frame = CGRectMake(0, 0, 70, 30);
            [cancelButton addTarget:self action:@selector(cancelSelected:) forControlEvents:UIControlEventTouchUpInside];
            [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            cancelButton.titleLabel.font = [UIFont fontWithName:@"HalisGR-Regular" size:15];
            
            UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
            
            [buttons addObject:leftButton];
        }
        
        if (!okButtonTitle || [okButtonTitle isEqualToString:@""]) {
            assert(@"okButtonTitle can't be nil or empty string");
        } else {
            // Adding ok bar button to view
            UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            
            UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
            okButton.frame = CGRectMake(0, 0, 50, 30);
            [okButton addTarget:self action:@selector(okSelected:) forControlEvents:UIControlEventTouchUpInside];
            [okButton setTitle:okButtonTitle forState:UIControlStateNormal];
            okButton.titleLabel.font = [UIFont fontWithName:@"HalisGR-Regular" size:15.0];
            okButton.titleLabel.textAlignment = NSTextAlignmentRight;
            UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:okButton];
            
            [buttons addObjectsFromArray:[NSArray arrayWithObjects:flex,rightButton, nil]];
        }
        
        [toolbar setItems:buttons];
        
        // Clearing toolbar background (transparent)
        [toolbar setBackgroundImage:[UIImage new]
                 forToolbarPosition:UIToolbarPositionAny
                         barMetrics:UIBarMetricsDefault];
        [toolbar setBackgroundColor:[UIColor clearColor]];
        
        [self.actionView addSubview:toolbar];
        

        self.pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(5, 40, 315, 216)];
        self.pickerView.backgroundColor = [UIColor whiteColor];
        if (startDate) {
            [self.pickerView setMinimumDate:startDate];
        }
        
        if (endDate) {
            [self.pickerView setMaximumDate:endDate];
        }
        
        CALayer *mask = [[CALayer alloc] init];
        [mask setBackgroundColor: [UIColor blackColor].CGColor];
        [mask setFrame:  CGRectMake(2.5f, 10.0f, 305.0f, 196.0f)];
        [mask setCornerRadius: 5.0f];
        [self.pickerView.layer setMask: mask];
        
        
        [self.actionView addSubview:self.pickerView];
    }
    return self;
}

- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [window addSubview:self];
    [window addSubview:self.actionView];
    
    CGRect frame = self.actionView.frame;
    frame.origin.y = SCREEN_SIZE.height - PICKER_HEIGHT;
    [UIView animateWithDuration:0.25f animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.alpha = 0.5;
        self.actionView.frame = frame;
    } completion:nil];
}

- (void)hide
{
    CGRect frame = self.actionView.frame;
    frame.origin.y = SCREEN_SIZE.height;
    
    [UIView animateWithDuration:0.25f animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.actionView.frame = frame;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.actionView removeFromSuperview];
        [self removeFromSuperview];
    }];
}


- (void)adjustPickerSelectionForDate:(NSDate *)date animated:(BOOL)animated
{
    if (!date) {
        return;
    }
    [self.pickerView setDate:date animated:animated];
}

#pragma actions

- (void)okSelected:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerActionSheetDone:)]) {
        [self.delegate datePickerActionSheetDone:self.pickerView.date];
    }
    [self hide];
}

- (void)cancelSelected:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerActionSheetCanceled)]) {
        [self.delegate datePickerActionSheetCanceled];
    }
    [self hide];
}

@end
