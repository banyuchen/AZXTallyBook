//
//  JDLoginViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/8/30.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDLoginViewController.h"
#import "JDRegisterTextFieldView.h"
#import "JDForgotPSWViewController.h"

#import "XMGHTTPSessionManager.h"

#import "JDRegisterViewController.h"

@interface JDLoginViewController ()
{
    BOOL _isShow;
}
/**账号*/
@property (nonatomic, strong) JDRegisterTextFieldView *accountTextField;
/**密码*/
@property (nonatomic, strong) UITextField *pswTextField;

/**验证码*/
@property (nonatomic, strong) UITextField *codeTextField;

/**是否显示密码*/
@property (nonatomic, strong) UIButton *isShowPSWBtn;
/** 任务管理者 */
@property (nonatomic, strong) XMGHTTPSessionManager *manager;
/**登录*/
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation JDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"登录";
    
    self.view.backgroundColor = TableColor;
    
    
    _isShow = [[[NSUserDefaults standardUserDefaults] valueForKey:@"BorrowingIsShow"] isEqualToString:@"y"] ? YES : NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadUI];
}

#pragma mark - 是否显示密码
- (void)isShowPSWBtnClick
{
    self.isShowPSWBtn.selected = !self.isShowPSWBtn.selected;
    
//    self.pswTextField.text = @""; // 这句代码可以防止切换的时候光标偏移
    self.pswTextField.secureTextEntry = !self.isShowPSWBtn.selected;
}



#pragma mark - 登录
- (void)loginBtnClick
{
    [self.view endEditing:YES];
    
    self.loginBtn.enabled = NO;
    
    BOOL isPhone = [XMToolClass validateMobileAndTel:self.accountTextField.textField.text];
    BOOL isCode = self.codeTextField.text.length > 0;
    BOOL isPSW = [XMToolClass validatePassword:self.pswTextField.text];
    
    if (!isPhone) {
        
        
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        self.loginBtn.enabled = YES;
        return;
    }
    
    if (!_isShow) {
        
        if (!isPSW) {
            
            
            [SVProgressHUD showErrorWithStatus:@"请输入正确的密码"];
            [SVProgressHUD dismissWithDelay:0.5];
            
            self.loginBtn.enabled = YES;
            
            return;
        }
        
    }
    else{
        
        if (!isCode) {
            
            
            [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
            [SVProgressHUD dismissWithDelay:0.5];
            
            self.loginBtn.enabled = YES;
            
            return;
        }
    }
    
    
    if (!_isShow) {
        
        [self userPassWordCodeLogin];
    }
    else{
        
        [self codeLoginByJiedai];
    }
    
}

- (void)codeLoginByJiedai
{
    //传入的参数
    NSDictionary *parameters =
    @{
      @"msgValidateCode":self.codeTextField.text,
      @"appKey":ThirdAppkey,
      @"mobile":self.accountTextField.textField.text,
      @"pattern":@"10",
      };
    
    NSString *url = [[NSString stringWithFormat:@"%@/user/msgValidateCodeLoginByJiedai", LOGINURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __weak typeof(self) weakSelf = self;
    
    // 发送请求
    [self.manager POST:url parameters:[XMToolClass parseParams:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.loginBtn.enabled = YES;
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
            DBAccount *account = [DBAccount accountWithDict:[responseObject objectForKey:@"returnValue"]];
            [DBSave save:account];
            
            if ([[[responseObject valueForKey:@"returnValue"] valueForKey:@"appUid"] isEqualToString:@"2"]) {
                
                //判断是登录还是注册
                [self addCustomerUserWithURL:@"/loanshop/user/addCustomerUser"];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (self.isLogin) {
                    
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else{
                    
                    weakSelf.navigationController.tabBarController.selectedIndex = 0;
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
                
            });
            
        }else{
            
            
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"errorCode"]];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        self.loginBtn.enabled = YES;
        
        APPDELEGATE.window.userInteractionEnabled = YES;
        [CommonMethod altermethord:TipFailure andmessagestr:TipFailureDetail andconcelstr:@"确定"];
    }];

}


#pragma mark - 添加个性化数据
- (void)addCustomerUserWithURL:(NSString *)url
{
    
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    NSDictionary *parameters2 =
    @{
      @"userName":@"",
      @"card":@"",
      @"provice":@"",
      @"city":@"",
      @"mobile":[DBSave account].account,
      @"marriage":@"",
      @"culture":@"",
      @"loanMoney":@"",
      @"loanTimeType":@"",
      @"loanTime":@"",
      @"equipment":@"2",
      @"deviceNumber":adId,
      @"userId":[DBSave account].ID,
      @"id":@"",
      };
    
    NSString *url2 = [[NSString stringWithFormat:@"%@%@",LOGINURL,url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    // 发送请求
    [self.manager GET:url2 parameters:parameters2 progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}




- (void)userPassWordCodeLogin
{
//    NSString *passWord = [XMToolClass md5:self.pswTextField.text];
    
    //传入的参数
    NSDictionary *parameters =
    @{
      @"passWord":self.pswTextField.text,
      @"appKey":ThirdAppkey,
      @"account":self.accountTextField.textField.text,
      @"pattern":@"10",
      };
    
    NSString *url = [[NSString stringWithFormat:@"%@/user/userPassWordCodeLogin", LOGINURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __weak typeof(self) weakSelf = self;
    
    // 发送请求
    [self.manager POST:url parameters:[XMToolClass parseParams:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.loginBtn.enabled = YES;
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
            DBAccount *account = [DBAccount accountWithDict:[responseObject objectForKey:@"returnValue"]];
            [DBSave save:account];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (self.isLogin) {
                    
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else{
                    
                    weakSelf.navigationController.tabBarController.selectedIndex = 0;
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
                
            });
            
        }else{
            
            
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"errorCode"]];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        self.loginBtn.enabled = YES;
        
        APPDELEGATE.window.userInteractionEnabled = YES;
        [CommonMethod altermethord:TipFailure andmessagestr:TipFailureDetail andconcelstr:@"确定"];
    }];
}


#pragma mark - 忘记密码
- (void)forgotPSWClick
{
    JDForgotPSWViewController *vc = [[JDForgotPSWViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 快速注册
- (void)quickRegisBtnClick
{
    JDRegisterViewController *vc = [[JDRegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadUI
{
    //头像
    UIImageView *avatarImgView = [[UIImageView alloc] init];
    avatarImgView.image = [UIImage imageNamed:@"mine_default"];
    avatarImgView.layer.cornerRadius = 30;
    avatarImgView.layer.masksToBounds = YES;
    [self.view addSubview:avatarImgView];
    [avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(20 +kNavigationH);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    //输入框背景
    UIView *bgView = [UIView viewWithBackgroundColor:WhiteColor superView:self.view];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(avatarImgView.mas_bottom).mas_equalTo(20);
        make.left.mas_equalTo(6);
        make.right.mas_equalTo(-6);
        make.height.mas_equalTo(55*2);
    }];
    
    //账号
    JDRegisterTextFieldView *accountTextField = [[JDRegisterTextFieldView alloc] init];
    accountTextField.textField.placeholder = @"请输入手机号码";
    accountTextField.titleLbl.text = @"账    号";
    accountTextField.textField.keyboardType = UIKeyboardTypePhonePad;
    [bgView addSubview:accountTextField];
    [accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    self.accountTextField = accountTextField;
    
   
    
    
    if (!_isShow) {
        
        //密码
        UILabel *pswLbl = [UILabel labelWithText:@"密    码" font:kFont(15) textColor:BlackGrayColor backGroundColor:ClearColor superView:bgView];
        [pswLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kMargin);
            make.top.mas_equalTo(accountTextField.mas_bottom);
            make.height.mas_equalTo(55);
        }];
        
        UIButton *isShowPSWBtn = [UIButton buttonWithImage:@"signin_close" target:self action:@selector(isShowPSWBtnClick) showView:bgView];
        [isShowPSWBtn setImage:[UIImage imageNamed:@"signin_open"] forState:UIControlStateSelected];
        [isShowPSWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kMargin);
            make.top.mas_equalTo(accountTextField.mas_bottom);
            make.height.mas_equalTo(55);
            make.width.mas_equalTo(55);
        }];
        isShowPSWBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.isShowPSWBtn = isShowPSWBtn;
        
        UITextField *pswTextField = [[UITextField alloc] init];
        pswTextField.font = kFont(15);
        pswTextField.placeholder = @"请输入密码";
        pswTextField.keyboardType = UIKeyboardTypeDefault;
        pswTextField.textColor = BlackGrayColor;
        [bgView addSubview:pswTextField];
        [pswTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(90);
            make.top.mas_equalTo(accountTextField.mas_bottom);
            make.height.mas_equalTo(55);
            make.right.mas_equalTo(isShowPSWBtn.mas_left).mas_equalTo(-kMargin);
        }];
        self.pswTextField = pswTextField;
        self.pswTextField.secureTextEntry = YES;
        
    }else
    {
        //验证码
        UILabel *codeLbl = [UILabel labelWithText:@"验证码" font:kFont(15) textColor:BlackGrayColor backGroundColor:ClearColor superView:bgView];
        [codeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(kMargin);
            make.height.mas_equalTo(55);
            make.top.mas_equalTo(self.accountTextField.mas_bottom);
        }];
        
        
        UIButton *codeBtn = [UIButton buttonWithTitle:@"获取验证码" font:kFont(15) titleColor:RGBCOLOR(68, 136, 251) backGroundColor:ClearColor buttonTag:0 target:self action:@selector(codeBtnClick:) showView:bgView];
        
        [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-kMargin);
            make.top.mas_equalTo(self.accountTextField.mas_bottom);
            make.height.mas_equalTo(55);
            make.width.mas_equalTo(85);
        }];
        
        
        UITextField *codeTextField = [[UITextField alloc] init];
        codeTextField.font = kFont(15);
        codeTextField.placeholder = @"请输入验证码";
        codeTextField.textColor = BlackGrayColor;
        codeTextField.keyboardType = UIKeyboardTypePhonePad;
        [bgView addSubview:codeTextField];
        
        [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(90);
            make.top.mas_equalTo(self.accountTextField.mas_bottom);
            make.height.mas_equalTo(55);
            make.right.mas_equalTo(codeBtn.mas_left).mas_equalTo(-kMargin);
        }];
        self.codeTextField = codeTextField;
        
        
    }
    
    
    //登录
    UIButton *loginBtn = [UIButton buttonWithTitle:@"登  录" font:kFont(15) titleColor:WhiteColor backGroundColor:RGBCOLOR(68, 139, 251) buttonTag:0 target:self action:@selector(loginBtnClick) showView:self.view];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(bgView.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(6);
        make.right.mas_equalTo(-6);
        make.height.mas_equalTo(40);
    }];
    self.loginBtn = loginBtn;
    
    if (!_isShow) {
        
        //忘记密码
        UIButton *forgotPSWBtn = [UIButton buttonWithTitle:@"忘记密码？" font:kFont(13) titleColor:RGBCOLOR(68, 139, 251) backGroundColor:ClearColor buttonTag:0 target:self action:@selector(forgotPSWClick) showView:self.view];
        [forgotPSWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(loginBtn.mas_left);
            make.top.mas_equalTo(loginBtn.mas_bottom).mas_equalTo(10);
            
            make.height.mas_equalTo(25);
        }];
        
        //快速注册
        UIButton *quickRegisBtn = [UIButton buttonWithTitle:@"快速注册>" font:kFont(13) titleColor:RGBCOLOR(68, 139, 251) backGroundColor:ClearColor buttonTag:0 target:self action:@selector(quickRegisBtnClick) showView:self.view];
        
        [quickRegisBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(loginBtn.mas_right);
            make.top.mas_equalTo(loginBtn.mas_bottom).mas_equalTo(10);
            
            make.height.mas_equalTo(25);
            
        }];
    }
    
    //设置数据
    DBAccount *account = [DBSave account];
    if (![XMToolClass isBlankString:account.account]) {
        
        self.accountTextField.textField.text = account.account;
        
    }
    
}

#pragma mark - 获取验证码
- (void)codeBtnClick:(UIButton *)sender
{
    NSString *phone = [self.accountTextField.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    BOOL isPhone = [XMToolClass validateMobile:phone];
    
    if (!isPhone) {
        [CommonMethod altermethord:@"请输入正确的手机号码" andmessagestr:@"" andconcelstr:@"确定"];
        return;
    }
    
    
    //传入的参数
    NSDictionary *parameters =
    @{
      @"mobile":self.accountTextField.textField.text,
      };
    
    NSString *url = [[NSString stringWithFormat:@"%@/user/sendMsgValidateCodeByOther", LOGINURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // 发送请求
    [self.manager GET:url parameters:[XMToolClass parseParams:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            
            [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
            [CommonMethod GetVerificationCode:sender finish:nil];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"errorCode"]];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        APPDELEGATE.window.userInteractionEnabled = YES;
        [CommonMethod altermethord:TipFailure andmessagestr:TipFailureDetail andconcelstr:@"确定"];
    }];
    
}

- (XMGHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [XMGHTTPSessionManager manager];
    }
    return _manager;
}
@end
