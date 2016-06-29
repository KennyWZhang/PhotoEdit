//
//  SupportVC.m
//  PhotoEdit
//
//  Created by Artur Sahakyan on 6/22/16.
//  Copyright © 2016 Feghal. All rights reserved.
//

#import "SupportVC.h"

@interface SupportVC ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SupportVC

- (void)viewDidLoad {
    [super viewDidLoad];    
    NSString *string = @"We always work to introduce new features and also improve the performance of the app.\n<br/>\n<br/>\nWe would be grateful if you could send us your feedback, suggestions and comments via email by clicking <a href=\"mailto:feghaldev@gmail.com\">here</a>.";
    [self.webView loadHTMLString:string baseURL:nil];
}

@end
