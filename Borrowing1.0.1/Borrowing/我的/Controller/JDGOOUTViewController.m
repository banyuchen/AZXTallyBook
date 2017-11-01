//
//  JDGOOUTViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/10/25.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDGOOUTViewController.h"

@interface JDGOOUTViewController ()

@end

@implementation JDGOOUTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    
    [self loadUIView];
}


- (void)loadUIView
{
    UILabel *title = [UILabel labelWithText:@"确定退出登录？" font:kFont(16) textColor:BlackNameColor backGroundColor:ClearColor superView:self.view];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(kMargin *2);
        
    }];
    
    CGFloat btnW = (kWindowW - 3*kMargin*2- 4*kMargin)*0.5;
    
    UIButton *yesBtn = [UIButton buttonWithTitle:@"是" font:kFont(16) titleColor:WhiteColor backGroundColor:RGBCOLOR(51, 118, 254) buttonTag:0 target:self action:@selector(yesBtnClick) showView:self.view];
    yesBtn.layer.cornerRadius = 4;
    yesBtn.layer.masksToBounds = YES;
    [yesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(2*kMargin);
        make.width.mas_equalTo(btnW);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(title.mas_bottom).mas_equalTo(kMargin*1.5);
    }];
    
    UIButton *noBtn = [UIButton buttonWithTitle:@"否" font:kFont(16) titleColor:BlackNameColor backGroundColor:TableColor buttonTag:0 target:self action:@selector(noBtnClick) showView:self.view];
    noBtn.layer.cornerRadius = 4;
    noBtn.layer.masksToBounds = YES;
    [noBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kMargin*2);
        make.width.mas_equalTo(btnW);
        make.height.mas_equalTo(50);
        make.centerY.mas_equalTo(yesBtn.mas_centerY);
    }];
    
}


#pragma mark - 退出登录
- (void)yesBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(didClickGoOutBtn)]) {
        
        [self.delegate didClickGoOutBtn];
    }
    
}

#pragma mark - 取消
- (void)noBtnClick
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
