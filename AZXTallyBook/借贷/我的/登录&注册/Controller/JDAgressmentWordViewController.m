//
//  JDAgressmentWordViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/9/13.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDAgressmentWordViewController.h"
#import "HHWZWebView.h"

@interface JDAgressmentWordViewController ()

@end

@implementation JDAgressmentWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    
    self.navigationItem.title = @"用户协议";
    
    UIWebView *webView = [[UIWebView alloc] init];
    
    
    webView.frame = CGRectMake(0, 0, kWindowW, kWindowH);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
    
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    
    NSURL *baseURL = [NSURL fileURLWithPath:basePath];
    
    [webView loadHTMLString:htmlString baseURL:baseURL];
    
    
    [self.view addSubview:webView];
}



@end
