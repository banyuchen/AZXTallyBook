//
//  JDAboutUsViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/9/13.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDAboutUsViewController.h"

@interface JDAboutUsViewController ()

/**图标*/
@property (nonatomic, strong) UIImageView *imgView;
/**版本号*/
@property (nonatomic, strong) UILabel *versionNumberLbl;

/**客服电话*/
@property (nonatomic, strong) UIButton *serviceCallBtn;
/**公司信息*/
@property (nonatomic, strong) UILabel *companyLbl;

@end

@implementation JDAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于我们";
    
    self.view.backgroundColor = WhiteColor;
    
    self.versionNumberLbl.text = [NSString stringWithFormat:@"当前版本  %@ ",[XMToolClass getVersion]];
    
    [self serviceCallBtn];
    [self companyLbl];
}
#pragma mark - 拨打电话
- (void)serviceCallBtnClick
{
    
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"17625296836"];
//    UIWebView * callWebview = [[UIWebView alloc] init];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//    [self.view addSubview:callWebview];
    
//    UIWebView * callWebview = [[UIWebView alloc] init];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:17625296836"]]];
//    [self.view addSubview:callWebview];
    
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:4006305816"];
    
    AppDelegate *app = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    app.window.userInteractionEnabled = NO;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
        app.window.userInteractionEnabled = YES; }];
    
}

#pragma mark - 懒加载

- (UIImageView *)imgView
{
    if (!_imgView) {
        
        _imgView = [[UIImageView alloc] init];
        
        _imgView.image = [UIImage imageNamed:@"about_icon"];
        
        [self.view addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(KActualH(144) + kNavigationH);
            make.centerX.mas_equalTo(0);
        }];
    }
    return _imgView;
}

- (UILabel *)versionNumberLbl
{
    if (!_versionNumberLbl) {
        
        _versionNumberLbl = [UILabel labelWithText:@"" font:kFont(12) textColor:[XMToolClass getColorWithHexString:@"b7b7b7"] backGroundColor:ClearColor superView:self.view];
        
        [_versionNumberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(self.imgView.mas_bottom).mas_equalTo(KActualH(30));
            make.centerX.mas_equalTo(0);
        }];
    }
    return _versionNumberLbl;
}


- (UIButton *)serviceCallBtn
{
    if (!_serviceCallBtn) {
        
        _serviceCallBtn = [UIButton buttonWithTitle:@"客服电话  400 630-5816" font:kFont(14) titleColor:[XMToolClass getColorWithHexString:@"408eff"] backGroundColor:ClearColor buttonTag:0 target:self action:@selector(serviceCallBtnClick) showView:self.view];
        
        [_serviceCallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-KActualH(66));
        }];
    }
    return _serviceCallBtn;
}

- (UILabel *)companyLbl
{
    if (!_companyLbl) {
        
        _companyLbl = [UILabel labelWithText:@"版权所有 厦门森巴网络借贷信息中介服务有限公司" font:kFont(13) textColor:GrayTipColor backGroundColor:ClearColor superView:self.view];
        
        [_companyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return _companyLbl;
}
@end
