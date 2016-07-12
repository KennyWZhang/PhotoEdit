//
//  SettingsTVC.m
//  PhotoEdit
//
//  Created by Artur Sahakyan on 6/9/16.
//  Copyright © 2016 Feghal. All rights reserved.
//

#import "SettingsTVC.h"

#import "DRColorPicker.h"
#import "LGPickerActionSheet.h"
#import "Text.h"

@interface SettingsTVC () <LGPickerActionSheetDelegate> {
    Text *text;
    NSArray *fontNames;
}
@property (strong, nonatomic) IBOutlet UIButton *fontButton;
@property (strong, nonatomic) IBOutlet UIStepper *stepper;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *colorButton;
@property (strong, nonatomic) IBOutlet UIButton *backroundColorButton;

@property (strong, nonatomic) DRColorPickerColor *color;
@property (weak, nonatomic) DRColorPickerViewController *colorPickerVC;

@end

@implementation SettingsTVC

#pragma mark - ViewController lifecycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.fontButton setExclusiveTouch:YES];
    [self.colorButton setExclusiveTouch:YES];
    [self.backroundColorButton setExclusiveTouch:YES];
    
    text = [Text new];
    fontNames = [text getNonSystemFontNames];
    [text load];
    if([text.style isEqualToString:@"Default"]) {
        self.fontButton.titleLabel.font = [UIFont systemFontOfSize:15];
    } else {
        self.fontButton.titleLabel.font = [UIFont fontWithName:text.style size:15];
    }
    [self.fontButton setTitle:@"Default" forState:UIControlStateNormal];
    
    self.textField.font = [UIFont systemFontOfSize:13];
    self.textField.text = @"13";
    self.colorButton.backgroundColor = [UIColor blackColor];
    self.backroundColorButton.backgroundColor = [UIColor whiteColor];
    
    if(text.size || text.color || text.backround || text.style) {
        [self.fontButton setTitle:text.style forState:UIControlStateNormal];
        
        self.textField.font = [UIFont systemFontOfSize:[text.size intValue]];
        self.textField.text = text.size;
        self.colorButton.backgroundColor = text.color;
        self.backroundColorButton.backgroundColor = text.backround;
    }
    self.stepper.minimumValue = 5;
    self.stepper.maximumValue = 40;
    self.stepper.value = [self.textField.text intValue];
    
    self.color = [[DRColorPickerColor alloc] initWithColor:UIColor.blueColor];
    [self.navigationController.toolbar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [self.navigationController.toolbar setHidden:NO];
        
        text.size = self.textField.text;
        text.color = self.colorButton.backgroundColor;
        text.backround = self.backroundColorButton.backgroundColor;
        text.style = self.fontButton.titleLabel.text;
        
        [text save];
    }
}

#pragma mark - LGPickerActionSheetDelegate methods -

- (IBAction)pickerTapped:(UIButton *)sender {
    if(fontNames) {
        LGPickerActionSheet *pickerView = [[LGPickerActionSheet alloc]
                                           initWithData:@[fontNames]
                                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                           okButtonTitle:NSLocalizedString(@"Done", nil)];
        pickerView.delegate = self;
        [pickerView show];
    }
}

- (void)pickerActionSheetDone:(NSArray *)selectedRows fromData:(NSArray *)data {
    [self.fontButton setTitle: data[0][[selectedRows[0] intValue]] forState:UIControlStateNormal];
    self.fontButton.titleLabel.font = [UIFont fontWithName:data[0][[selectedRows[0] intValue]]
                                                      size:15];
}

#pragma mark - Actions -

- (IBAction)stepperTapped:(UIStepper *)sender {
    self.textField.text = [NSString stringWithFormat:@"%d", (int)[sender value]];
    self.textField.font = [UIFont systemFontOfSize:(int)[sender value]];
}

- (IBAction)colorButton:(UIButton *)sender {
    DRColorPickerBackgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    DRColorPickerBorderColor = [UIColor blackColor];
    DRColorPickerFont = [UIFont systemFontOfSize:16.0f];
    DRColorPickerLabelColor = [UIColor blackColor];
    DRColorPickerStoreMaxColors = 200;
    DRColorPickerShowSaturationBar = YES;
    DRColorPickerHighlightLastHue = YES;
    DRColorPickerSharedAppGroup = nil;
    
    DRColorPickerViewController* vc = [DRColorPickerViewController newColorPickerWithColor:self.color];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.rootViewController.showAlphaSlider = YES;
    vc.rootViewController.addToFavoritesImage = DRColorPickerImage(@"images/light/drcolorpicker-addtofavorites-light.png");
    vc.rootViewController.favoritesImage = DRColorPickerImage(@"images/light/drcolorpicker-favorites-light.png");
    vc.rootViewController.hueImage = DRColorPickerImage(@"images/light/drcolorpicker-hue-v3-light.png");
    vc.rootViewController.wheelImage = DRColorPickerImage(@"images/light/drcolorpicker-wheel-light.png");
    vc.rootViewController.importImage = DRColorPickerImage(@"images/light/drcolorpicker-import-light.png");
    
    self.colorPickerVC = vc;
    vc.rootViewController.dismissBlock = ^(BOOL cancel) {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    vc.rootViewController.colorSelectedBlock = ^(DRColorPickerColor* color, DRColorPickerBaseViewController* vc) {
        if (sender.tag == 0) {
            self.color = color;
            self.colorButton.backgroundColor = color.rgbColor;
        } else {
            self.backroundColorButton.backgroundColor = color.rgbColor;
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
}


@end
