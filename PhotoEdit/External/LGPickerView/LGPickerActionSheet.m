//
//  SOPickerActionSheet.m
//  PTO
//
//  Created by David Sahakyan on 2/16/15.
//  Copyright (c) 2015 Heptacopter. All rights reserved.
//

#import "LGPickerActionSheet.h"

#define PICKER_HEIGHT 255
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@interface LGPickerActionSheet()

@property (strong, nonatomic) UIView *actionView;
@property (strong, nonatomic) UIPickerView *pickerView;

@end

@implementation LGPickerActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithData:(NSArray *)data
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
        
        self.data = [data mutableCopy];
        
        // Adding buttons
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 40.0f)];
        NSMutableArray *buttons = [NSMutableArray array];
        
        if (cancelButtonTitle && ![cancelButtonTitle isEqualToString:@""]) {
            // Adding cancel bar button to view
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelButton.frame = CGRectMake(0,0,70,30);
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
            okButton.frame = CGRectMake(0,0,50,30);
            [okButton addTarget:self action:@selector(okSelected:) forControlEvents:UIControlEventTouchUpInside];
            [okButton setTitle:okButtonTitle forState:UIControlStateNormal];
            okButton.titleLabel.font = [UIFont fontWithName:@"HalisGR-Regular" size:15];
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
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 40, SCREEN_SIZE.width - 20, 216)];
        self.pickerView.backgroundColor = [UIColor whiteColor];
        self.pickerView.showsSelectionIndicator = YES;
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        
        
        CALayer* mask = [[CALayer alloc] init];
        [mask setBackgroundColor: [UIColor blackColor].CGColor];
        [mask setFrame:  CGRectMake(10.0f, 10.0f, self.pickerView.frame.size.width - 20, 196.0f)];
        [mask setCornerRadius: 5.0f];
        [self.pickerView.layer setMask: mask];
        
        [self.pickerView reloadAllComponents];
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

- (void)adjustPickerSelectionForData:(NSArray *)data
{
    if (!data) {
        return;
    }
    for (int i = 0; i < data.count; i++) {
        int rowIndex = 0;
        for (int k = 0; k < [self.data[i] count]; k++) {
            if ([self.data[i][k] isEqual:data[i]]) {
                rowIndex = k;
                break;
            }
        }
        [self.pickerView selectRow:rowIndex inComponent:i animated:NO];
    }
}

#pragma Actions

- (void)okSelected:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerActionSheetDone:fromData:)])
    {
        NSMutableArray *selectedData = [NSMutableArray array];
        for (int i = 0; i < self.data.count; i++) {
            int row = (int)[self.pickerView selectedRowInComponent:i];
            [selectedData addObject:@(row)];
        }
        [self.delegate pickerActionSheetDone:selectedData fromData:self.data];
    }
    [self hide];
}

- (void)cancelSelected:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerActionSheetCanceled)])
    {
        [self.delegate pickerActionSheetCanceled];
    }
    [self hide];
}

#pragma mark - PickerView Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.data.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.data[component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.data[component][row];
}

@end
