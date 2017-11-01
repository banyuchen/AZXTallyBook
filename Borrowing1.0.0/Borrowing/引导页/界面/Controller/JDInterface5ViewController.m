//
//  JDInterface5ViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/9/14.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDInterface5ViewController.h"

@interface JDInterface5ViewController ()

/**当无数据的时候*/
@property (nonatomic, strong) UIView *nullView;

/**无数据&页面挂掉的提示文字*/
@property (nonatomic, strong) UILabel *nullLbl;

@end

@implementation JDInterface5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    
    self.navigationItem.title = @"借款记录";
    
    self.nullView.hidden = NO;
    
    self.nullLbl.attributedText = [NSString attributedStringWithColorTitle:@"暂无记录" normalTitle:@"" frontTitle:@"" diffentColor:BlackGrayColor];
}

- (UIView *)nullView
{
    if (!_nullView) {
        
        _nullView = [UIView viewWithBackgroundColor:RGBCOLOR(244, 244, 244) superView:self.view];
        
        [_nullView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(kNavigationH);
            make.left.right.bottom.mas_equalTo(0);
        }];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.image = [UIImage imageNamed:@"empty"];
        
        [_nullView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(KActualH(-80));
        }];
        
        UILabel *lable = [UILabel labelWithText:@"" font:kFont(16) textColor:RGBCOLOR(0, 137, 229) backGroundColor:ClearColor superView:_nullView];
        
        lable.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
        
        [lable addGestureRecognizer:labelTapGestureRecognizer];
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(imageView.mas_bottom).mas_equalTo(5);
        }];
        _nullView.hidden = YES;
        
        
        self.nullLbl = lable;
    }
    return _nullView;
}


-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    UILabel *label=(UILabel*)recognizer.view;
    
    
}

@end
