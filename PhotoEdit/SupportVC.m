//
//  SupportVC.m
//  PhotoEdit
//
//  Created by Artur Sahakyan on 6/22/16.
//  Copyright © 2016 Feghal. All rights reserved.
//

#import "SupportVC.h"

#import <MessageUI/MessageUI.h>

@interface SupportVC () <MFMailComposeViewControllerDelegate>

@end

@implementation SupportVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)hereTapped:(UIButton *)sender {
    NSString *emailTitle = @"Feedback";
    NSString *messageBody = @"";
    NSArray *toRecipents = [NSArray arrayWithObject:@"feghaldev@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];

    [self presentViewController:mc animated:YES completion:NULL];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Your email sent" message:@"Thanks for feedback" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil];
    
    switch (result) {
        case MFMailComposeResultSent:
            [alert addAction:done];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
}
@end
