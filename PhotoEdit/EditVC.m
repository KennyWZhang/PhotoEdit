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

@interface EditVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate , UIGestureRecognizerDelegate> {
    NSMutableDictionary *text;
    UIImage *imageToReplace;
    CGFloat lastScale;
    BOOL doublePhoto;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *wView; // workspace View ,added because of (posible)backround opacity

@end

@implementation EditVC

#pragma mark - ViewController lifecycle -

- (void)viewDidLoad {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [super viewDidLoad];
    
    imageToReplace = self.photo;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.photo;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    [self.imageView addGestureRecognizer:tap];
    
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.barTintColor = [UIColor colorWithRed:29.f/255.f green:196.f/255.f blue:255.f/255.f alpha:1];;
    for(UIView *temp in self.navigationController.toolbar.subviews) {
        [temp setExclusiveTouch:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"text"]) {
        text = [NSMutableDictionary new];
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"text"];
        text = [[NSKeyedUnarchiver unarchiveObjectWithData:data]mutableCopy];
    }
    if(text) {
        self.wView.backgroundColor = text[@"backround"];
        self.imageView.backgroundColor = text[@"backround"];
    }
}

///------------

- (void)addCPMToImage {
    CGRect frame = self.wView.frame;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 90, frame.size.height - 20, 90, 20)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    label.text = @"Made by CPM";
    [self.wView addSubview:label];
}

- (void)shareIfFixed {
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.imageView.image] applicationActivities:nil];
    NSArray *excludedActivities = @[UIActivityTypePostToFacebook, UIActivityTypePostToWeibo, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo,UIActivityTypePostToTwitter,UIActivityTypeMessage,UIActivityTypeAssignToContact];
    if ([activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
        activityViewController.popoverPresentationController.sourceView =
        self.wView;
    }
    activityViewController.excludedActivityTypes = excludedActivities;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)removeSubviewsFromImageView {
    for(UITextField *textField in self.imageView.subviews) {
        [textField removeFromSuperview];
    }
    for(UIView *textField in self.wView.subviews) {
        if([textField isKindOfClass:[UITextField class]] || [textField isKindOfClass:[UILabel class]]) {
            [textField removeFromSuperview];
        }
    }
}

#pragma mark - Actions -

- (IBAction)fixTapped:(UIBarButtonItem *)sender {
    [self addCPMToImage];
    NSString *buttonTitle = @"Done";
    NSString *buttonMessage;
    if(!doublePhoto) {
        buttonMessage = @"Your Text added sucsessfull, you can add another one, just tap on photo";
        if(!sender) {
            buttonMessage = @"Your Text added sucsessfull , Now you can share it !";
            buttonTitle = @"Share";
        }
        UIGraphicsBeginImageContextWithOptions(self.wView.bounds.size, NO,0);
        [self.wView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.imageView.image = image;
        
        [self removeSubviewsFromImageView];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sucsess" message:buttonMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *done = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^
                               (UIAlertAction * _Nonnull action) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       if(!sender) {
                                           [self shareIfFixed];
                                       }
                                   });
                               }];
        [alert addAction:done];
        
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    } else {
        buttonMessage = @"Your Text and Photos added sucsessfull";
        if(!sender) {
            buttonMessage = @"Your Text and Photos added sucsessfull , Now you can share it !";
            buttonTitle = @"Share";
        }
        UIGraphicsBeginImageContextWithOptions(self.wView.bounds.size, NO,0);
        [self.wView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self removeSubviewsFromImageView];
        
        for(UIImageView *view in self.wView.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sucsess" message:buttonMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *done = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^
                               (UIAlertAction * _Nonnull action) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       if(!sender) {
                                           [self shareIfFixed];
                                       }
                                   });
                               }];
        [alert addAction:done];
        
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.wView.bounds];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        self.imageView = imageView;
        [self.wView addSubview:self.imageView];
        doublePhoto = NO;
    }
}

- (IBAction)removeTextTapped:(UIBarButtonItem *)sender {
    [self removeSubviewsFromImageView];
}

- (IBAction)goBack:(UIBarButtonItem *)sender {
    if(self.imageView.image != self.photo) {
        PhotosCVC *pcvc = self.navigationController.viewControllers.firstObject;
        pcvc.imageToReplace = imageToReplace;
        pcvc.generatedImage = self.imageView.image;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Save changes in Photos album ?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *save = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, nil);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
        UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Only Here" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
        [alert addAction:save];
        [alert addAction:dismiss];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    } else {
        if(self.imageView.subviews.count > 0 || self.wView.subviews.count > 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"You don't fixed your changes,do you wan't dissmis all changes ?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"dissmis" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                return ;
            }];
            [alert addAction:cancel];
            [alert addAction:dismiss];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)share:(UIBarButtonItem *)sender {
    if(self.imageView.subviews.count > 0 || self.wView.subviews.count > 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Forgot fix ?" message:@"Prepare to share unfixed content " preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *fixShare = [UIAlertAction actionWithTitle:@"Fix & Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self fixTapped:nil];
            });
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            return ;
        }];
        [alert addAction:fixShare];
        [alert addAction:cancel];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    } else {
        [self shareIfFixed];
    }
}

- (IBAction)addTapped:(UIBarButtonItem *)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Gesture Recognizers selectors -

- (void)tapped:(UITapGestureRecognizer *)gesture {
    [self removeSubviewsFromImageView];
    
    CGPoint point = [gesture locationInView:gesture.view];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(point.x, point.y, gesture.view.frame.size.width - 50, 100)];
    [textField setBorderStyle:UITextBorderStyleNone];
    textField.placeholder = @"Type here";
    textField.backgroundColor = [UIColor clearColor];
    if(text) {
        textField.tintColor = text[@"color"];
        textField.textColor = text[@"color"];
        if([text[@"style"]  isEqualToString:@"Default"]) {
            textField.font = [UIFont systemFontOfSize:[text[@"size"] intValue]];
        } else {
            textField.font = [UIFont fontWithName:text[@"style"] size:[text[@"size"] intValue]];
        }
    }
    [textField becomeFirstResponder];
    [textField addTarget:self action:@selector(returnTapped:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    UIRotationGestureRecognizer *rot = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotate:)];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(resizeView:)];
    
    [textField addGestureRecognizer:rot];
    [textField addGestureRecognizer:pan];
    [textField addGestureRecognizer:pinch];
    [gesture.view addSubview:textField];
    [textField sizeToFit];
}

- (void)rotate:(UIRotationGestureRecognizer *)gesture {
    [gesture view].transform = CGAffineTransformRotate([[gesture view] transform],
                                                       [gesture rotation]);
    [gesture setRotation:0];
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    static CGPoint originalCenter;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if([gesture.view isEqual:self.imageView]) {
            originalCenter = self.imageView.center;
        } else {
            originalCenter = gesture.view.center;
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        if([gesture.view isEqual:self.imageView]) {
            CGPoint translate = [gesture translationInView:[self.imageView superview]];
            self.imageView.center = CGPointMake(originalCenter.x + translate.x , originalCenter.y + translate.y );
        } else {
            CGPoint translate = [gesture translationInView:[gesture.view superview]];
            gesture.view.center = CGPointMake(originalCenter.x + translate.x , originalCenter.y + translate.y );
        }
    }
}

- (void)resizeView:(UIPinchGestureRecognizer *)gesture {
    if([gesture state] == UIGestureRecognizerStateBegan) {
        lastScale = [gesture scale];
    }
    if ([gesture state] == UIGestureRecognizerStateBegan ||
        [gesture state] == UIGestureRecognizerStateChanged) {
        CGFloat currentScale = [[[gesture view].layer valueForKeyPath:@"transform.scale"] floatValue];
        
        const CGFloat kMaxScale = 10.0;
        const CGFloat kMinScale = 0.3;
        
        CGFloat newScale = 1 -  (lastScale - [gesture scale]);
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        CGAffineTransform transform = CGAffineTransformScale([[gesture view] transform], newScale, newScale);
        [gesture view].transform = transform;
        lastScale = [gesture scale];
    }
}

#pragma mark - textField selectors -

- (void)textChanged:(UITextField *)sender {
    [sender sizeToFit];
}

- (void)returnTapped:(UITextField *)sender {
    [sender sizeToFit];
    [sender resignFirstResponder];
}

#pragma mark - UIGestureRecognizer delegate -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate -

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageView *addedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.wView.frame.size.width / 2, self.wView.frame.size.width / 2)];
    
    [addedImageView setUserInteractionEnabled:YES];
    addedImageView.image = pickedImage;
    addedImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(resizeView:)];
    UIPinchGestureRecognizer *pinchOriginal = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(resizeView:)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    UIPanGestureRecognizer *panOriginal = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    UIRotationGestureRecognizer *rot = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotate:)];
    UIRotationGestureRecognizer *rotOriginal = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotate:)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    NSArray *gestures = @[pan,panOriginal,pinch,pinchOriginal];
    
    for(UIGestureRecognizer *gesture in gestures) {
        gesture.delegate = self;
    }
    [pan setMaximumNumberOfTouches:1];
    [panOriginal setMaximumNumberOfTouches:1];
    
    for (UIGestureRecognizer *recognizer in self.imageView.gestureRecognizers) {
        [self.imageView removeGestureRecognizer:recognizer];
    }
    [addedImageView addGestureRecognizer:pinch];
    [self.imageView addGestureRecognizer:pinchOriginal];
    [addedImageView addGestureRecognizer:pan];
    [self.imageView addGestureRecognizer:panOriginal];
    [addedImageView addGestureRecognizer:rot];
    [self.imageView addGestureRecognizer:rotOriginal];
    
    [self.wView addSubview:addedImageView];
    [self.wView addGestureRecognizer:tap];
    
    doublePhoto = YES;
    [self.imageView removeConstraints:self.imageView.constraints];
    [self.wView removeConstraints:self.wView.constraints];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.wView.translatesAutoresizingMaskIntoConstraints = YES;
    self.imageView.translatesAutoresizingMaskIntoConstraints = YES;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
