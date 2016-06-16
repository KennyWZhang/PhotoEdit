//
//  SOPickerActionSheet.h
//  PTO
//
//  Created by David Sahakyan on 2/16/15.
//  Copyright (c) 2015 Heptacopter. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LGPickerActionSheetDelegate <NSObject>

@optional

- (void)pickerActionSheetDone:(NSArray *)selectedRows fromData:(NSArray *)data;
- (void)pickerActionSheetCanceled;

@end

@interface LGPickerActionSheet : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSMutableArray *data;

@property (weak, nonatomic) id<LGPickerActionSheetDelegate> delegate;


- (void)show;
- (void)hide;
- (void)adjustPickerSelectionForData:(NSArray *)data;

/**************************************************************
 *  The parameter data should be an array of components value
 *  e.g. data[[text1,text3,text3,text4],
 *        [],
 *        []]
 **************************************************************/
- (id)initWithData:(NSArray *)data cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;

@end
