//
//  HelpPageVC.m
//  PhotoEdit
//
//  Created by Artur Sahakyan on 6/16/16.
//  Copyright © 2016 Feghal. All rights reserved.
//

#import "HelpPageVC.h"

@interface HelpPageVC ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageController;

@end

@implementation HelpPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *bbtnBack = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:bbtnBack];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.imageView addGestureRecognizer:swipeLeft];
    [self.imageView addGestureRecognizer:swipeRight];
}

- (IBAction)pageChanged:(UIPageControl *)sender {
    [self changePages];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture {
    if(gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        if(self.pageController.currentPage == 0) {
            return;
        }
        [self changeImagesByDiraction:YES];
        self.pageController.currentPage--;
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        if(self.pageController.currentPage == 2) {
            return;
        }
        [self changeImagesByDiraction:NO];
        self.pageController.currentPage++;
    }
}

- (void)changePages {
    if(self.pageController.currentPage == 0) {
        self.imageView.image = [UIImage imageNamed:@"test.jpeg"];
    } else if(self.pageController.currentPage == 1) {
        self.imageView.image = [UIImage imageNamed:@"test.png"];
    } else {
        self.imageView.image = [UIImage imageNamed:@"Unknown-person.gif"];
    }
}

- (void)changeImagesByDiraction:(BOOL)right {
    [UIView transitionWithView:self.view duration:0.2 options:UIViewAnimationOptionTransitionNone animations:^{
        CGFloat x;
        if(right){
            x = self.imageView.frame.size.width;
        } else {
            x = - self.imageView.frame.size.width;
        }
        self.imageView.frame = CGRectMake(x, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
    }completion:^(BOOL finished) {
        if(finished) {
            [self changePages];
        }
    }];
}

@end
