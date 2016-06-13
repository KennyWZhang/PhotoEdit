//
//  SettingsTVC.m
//  PhotoEdit
//
//  Created by Artur Sahakyan on 6/9/16.
//  Copyright © 2016 Feghal. All rights reserved.
//

#import "SettingsTVC.h"

#import "DRColorPicker.h"

@interface SettingsTVC ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
@property (strong, nonatomic) IBOutlet UIStepper *stepper;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *colorButton;
@property (strong, nonatomic) DRColorPickerColor *color;
@property (weak, nonatomic) DRColorPickerViewController *colorPickerVC;
@property (strong, nonatomic) NSMutableDictionary *text;

@end

@implementation SettingsTVC

#pragma mark - ViewController lifecycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.text = [NSMutableDictionary new];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"text"]) {
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"text"];
        self.text = [[NSKeyedUnarchiver unarchiveObjectWithData:data]mutableCopy];
        self.segment.selectedSegmentIndex = [self.text[@"style"] intValue];
        if (self.segment.selectedSegmentIndex == 0) {
            self.textField.font = [UIFont systemFontOfSize:[self.text[@"size"]intValue]];
        } else {
            self.textField.font = [UIFont boldSystemFontOfSize:[self.text[@"size"]intValue]];
        }
        self.textField.text = self.text[@"size"];
        self.colorButton.backgroundColor = self.text[@"color"];
    }
    self.stepper.minimumValue = 5;
    self.stepper.maximumValue = 40;
    self.stepper.value = [self.textField.text intValue];
    self.color = [[DRColorPickerColor alloc] initWithColor:UIColor.blueColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        self.text[@"size"] = self.textField.text;
        self.text[@"color"] = self.colorButton.backgroundColor;
        self.text[@"style"] = [NSString stringWithFormat:@"%ld",(long)self.segment.selectedSegmentIndex];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.text];
        [prefs setObject:data forKey:@"text"];
        [prefs synchronize];
    }
}

#pragma mark - Actions -

- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex == 0) {
        self.textField.font = [UIFont systemFontOfSize:[self.textField.text intValue]];
    } else {
        self.textField.font = [UIFont boldSystemFontOfSize:[self.textField.text intValue]];
    }
}

- (IBAction)stepperTapped:(UIStepper *)sender {
    self.textField.text = [NSString stringWithFormat:@"%d", (int)[sender value]];
    if (self.segment.selectedSegmentIndex == 0) {
        self.textField.font = [UIFont systemFontOfSize:(int)[sender value]];
    } else {
        self.textField.font = [UIFont boldSystemFontOfSize:(int)[sender value]];
    }
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
    vc.rootViewController.showAlphaSlider = YES; // default is YES, set to NO to hide the alpha slider
    vc.rootViewController.addToFavoritesImage = DRColorPickerImage(@"images/light/drcolorpicker-addtofavorites-light.png");
    vc.rootViewController.favoritesImage = DRColorPickerImage(@"images/light/drcolorpicker-favorites-light.png");
    vc.rootViewController.hueImage = DRColorPickerImage(@"images/light/drcolorpicker-hue-v3-light.png");
    vc.rootViewController.wheelImage = DRColorPickerImage(@"images/light/drcolorpicker-wheel-light.png");
    vc.rootViewController.importImage = DRColorPickerImage(@"images/light/drcolorpicker-import-light.png");
    
    self.colorPickerVC = vc;
    vc.rootViewController.dismissBlock = ^(BOOL cancel)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    vc.rootViewController.colorSelectedBlock = ^(DRColorPickerColor* color, DRColorPickerBaseViewController* vc)
    {
        self.color = color;
        self.colorButton.backgroundColor = color.rgbColor;
    };
    [self presentViewController:vc animated:YES completion:nil];
}


@end
