//
//  EditVC.m
//  PhotoEdit
//
//  Created by Artur Sahakyan on 6/9/16.
//  Copyright © 2016 Feghal. All rights reserved.
//

#import "EditVC.h"

#import "PhotosCVC.h"
#import "SettingsTVC.h"

@interface EditVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSMutableDictionary *text;
@property (strong, nonatomic) UIImage *imageToReplace;
@property (assign, nonatomic) CGFloat lastScale;
@property (assign, nonatomic) BOOL doublePhoto;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *fixButton;

@end

@implementation EditVC

#pragma mark - ViewController lifecycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationController.toolbarHidden = YES;
    [self.imageView setUserInteractionEnabled:YES];
    self.imageView.image = self.photo;
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settingsTapped)];
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                           target:self
                                                                           action:@selector(share)];
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                         target:self
                                                                         action:@selector(addTapped)];
    UIBarButtonItem *bbtnBack = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(goBack)];
    self.navigationItem.rightBarButtonItems = @[settings,share,add];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    [self.imageView addGestureRecognizer:tap];

    [self.navigationItem setLeftBarButtonItem:bbtnBack];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"text"]) {
        self.text = [NSMutableDictionary new];
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"text"];
        self.text = [[NSKeyedUnarchiver unarchiveObjectWithData:data]mutableCopy];
    }
    self.view.backgroundColor = self.text[@"backround"];
    self.imageView.backgroundColor = self.text[@"backround"];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        
    }
    [super viewWillDisappear:animated];
}

///------------

- (void)removeSubviewsFromImageView {
    for(UITextField *textField in self.imageView.subviews) {
        [textField removeFromSuperview];
    }
    for(UIView *textField in self.view.subviews) {
        if([textField isKindOfClass:[UITextField class]]) {
            [textField removeFromSuperview];
        }
    }
}

#pragma mark - Actions -

- (IBAction)fixTapped:(UIBarButtonItem *)sender {
    self.imageToReplace = self.imageView.image;
    if(!self.doublePhoto) {
        UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO,0);
        [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self removeSubviewsFromImageView];
        self.imageView.image = image;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sucsess" message:@"Your Text added sucsessfull, you can add another one, just tap on photo " preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:done];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    } else {
        UIToolbar *toolBar = self.view.subviews[1];
        [toolBar setHidden:YES];

        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO,0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [toolBar setHidden:NO];
        [self removeSubviewsFromImageView];
        self.imageView.image = image;
        for(UIImageView *view in self.view.subviews) {
            if ([view isKindOfClass:[UIImageView class]] && ![view isEqual:self.imageView]) {
                [view removeFromSuperview];
            }
        }
        for(UIGestureRecognizer *gesture in self.imageView.gestureRecognizers) {
            if(![gesture isKindOfClass:[UITapGestureRecognizer class]]) {
                [self.imageView removeGestureRecognizer:gesture];
            }
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sucsess" message:@"Your Text and Photos added sucsessfull " preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:done];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        CGRect frame = self.view.frame;
        self.imageView.frame = frame;
    }
}

- (void)goBack {
    if(self.imageView.image != self.photo) {
        PhotosCVC *pcvc = self.navigationController.viewControllers.firstObject;
        pcvc.imageToReplace = self.imageToReplace;
        pcvc.generatedImage = self.imageView.image;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Save changes in Photos album ?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *save = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, nil);
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Only Here" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alert addAction:save];
        [alert addAction:dismiss];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)share {
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.imageView.image] applicationActivities:nil];
    NSArray *excludedActivities = @[UIActivityTypePostToFacebook, UIActivityTypePostToWeibo, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo,UIActivityTypePostToTwitter,UIActivityTypeMessage,UIActivityTypeAssignToContact];
    activityViewController.excludedActivityTypes = excludedActivities;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)settingsTapped {
    SettingsTVC *stvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingsTVC"];
    
    [self.navigationController pushViewController:stvc animated:YES];
}

- (void)addTapped {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)tapped:(UITapGestureRecognizer *)gesture {
    [self removeSubviewsFromImageView];
    CGPoint point = [gesture locationInView:gesture.view];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(point.x, point.y, gesture.view.frame.size.width -50, 100)];
    [textField setBorderStyle:UITextBorderStyleNone];
    textField.placeholder = @"Type here";
    textField.backgroundColor = [UIColor clearColor];
    if(self.text) {
        textField.tintColor = self.text[@"color"];
        textField.textColor = self.text[@"color"];
        if([self.text[@"style"] intValue] == 0) {
            textField.font = [UIFont systemFontOfSize:[self.text[@"size"] intValue]];
        } else {
            textField.font = [UIFont boldSystemFontOfSize:[self.text[@"size"] intValue]];
        }
    }
    [gesture.view addSubview:textField];
    [textField becomeFirstResponder];
    [textField addTarget:self action:@selector(returnTapped:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    UIRotationGestureRecognizer *rot = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotate:)];
    [textField addGestureRecognizer:rot];
    [textField addGestureRecognizer:pan];
}

- (void)rotate:(UIRotationGestureRecognizer *)gesture {
    CGFloat initialRotation = atan2f(gesture.view.transform.b , gesture.view.transform.a );
    CGFloat newRotation = initialRotation + gesture.rotation ;
    gesture.view.transform = CGAffineTransformMakeRotation(newRotation);
    [gesture setRotation:0];
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    static CGPoint originalCenter;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        originalCenter = gesture.view.center;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translate = [gesture translationInView:[gesture.view superview]];
        gesture.view.center = CGPointMake(originalCenter.x + translate.x , originalCenter.y + translate.y );
    }
}

- (void)resizeImageView:(UIPinchGestureRecognizer *)gesture {
    
    if([gesture state] == UIGestureRecognizerStateBegan) {
        self.lastScale = [gesture scale];
    }
    if ([gesture state] == UIGestureRecognizerStateBegan ||
        [gesture state] == UIGestureRecognizerStateChanged) {
        CGFloat currentScale = [[[gesture view].layer valueForKeyPath:@"transform.scale"] floatValue];
        
        const CGFloat kMaxScale = 3.0;
        const CGFloat kMinScale = 0.3;
        
        CGFloat newScale = 1 -  (self.lastScale - [gesture scale]);
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        CGAffineTransform transform = CGAffineTransformScale([[gesture view] transform], newScale, newScale);
        [gesture view].transform = transform;
        
        self.lastScale = [gesture scale];
    }
}

- (void)textChanged:(UITextField *)sender {
    [sender sizeToFit];
}

- (void)returnTapped:(UITextField *)sender {
    [sender sizeToFit];
    [sender resignFirstResponder];
}

#pragma mark <UIImagePickerControllerDelegate>

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageView *addedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, 100, 100)];
    [addedImageView setUserInteractionEnabled:YES];
    addedImageView.image = pickedImage;
    addedImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(resizeImageView:)];
    UIPinchGestureRecognizer *pinchOriginal = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(resizeImageView:)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    UIPanGestureRecognizer *panOriginal = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [addedImageView addGestureRecognizer:pinch];
    [self.imageView addGestureRecognizer:pinchOriginal];
    [addedImageView addGestureRecognizer:pan];
    [self.imageView addGestureRecognizer:panOriginal];
    [self.view addSubview:addedImageView];
    [self removeSubviewsFromImageView];
    [self.imageView.gestureRecognizers[0] removeTarget:self action:@selector(tapped:)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:tap];
    self.doublePhoto = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
