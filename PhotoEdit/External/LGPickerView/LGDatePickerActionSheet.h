//
//  SODatePickerActionSheet.h
//  Pavlok
//
//  Created by David Sahakyan on 2/16/15.
//  Copyright (c) 2015 Heptacopter. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LGDatePickerActionSheetDelegate <NSObject>

@optional

- (void)datePickerActionSheetDone:(NSDate *)date;
- (void)datePickerActionSheetCanceled;

@end

@interface LGDatePickerActionSheet : UIView

@property (weak, nonatomic) id<LGDatePickerActionSheetDelegate> delegate;

@property (strong, nonatomic) UIDatePicker *pickerView;

- (void)show;
- (void)hide;
- (void)adjustPickerSelectionForDate:(NSDate *)date animated:(BOOL)animated;

- (id)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;

@end
