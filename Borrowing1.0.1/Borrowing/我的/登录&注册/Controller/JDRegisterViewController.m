//
//  JDRegisterViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/8/30.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDRegisterViewController.h"
#import "JDRegisterTextFieldView.h"
#import "XMGHTTPSessionManager.h"

#import "JDAgressmentWordViewController.h"

@interface JDRegisterViewController ()

/**输入框背景*/
@property (nonatomic, strong) UIView *bgView;
/**账号*/
@property (nonatomic, strong) JDRegisterTextFieldView *accountView;
/**验证码*/
@property (nonatomic, strong) UITextField *codeTextField;
/**密码*/
@property (nonatomic, strong) JDRegisterTextFieldView *pswView;
/**是否同意用户协议*/
@property (nonatomic, strong) CustomButton *agreementBtn;
/** 任务管理者 */
@property (nonatomic, strong) XMGHTTPSessionManager *manager;

/**注册*/
@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation JDRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TableColor;
    
    self.navigationItem.title = @"快速注册";
    
    [self loadUI];
}

#pragma mark - 获取验证码
- (void)codeBtnClick:(UIButton *)sender
{
    NSString *phone = [self.accountView.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    BOOL isPhone = [XMToolClass validateMobile:phone];
    
    if (!isPhone) {
        [CommonMethod altermethord:@"请输入正确的手机号码" andmessagestr:@"" andconcelstr:@"确定"];
        return;
    }
    
    
    //传入的参数
    NSDictionary *parameters =
    @{
      @"mobile":self.accountView.textField.text,
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

#pragma mark - 注册
- (void)registerBtnClick
{
    [self.view endEditing:YES];
    
    self.registerBtn.enabled = NO;
    
    BOOL isPhone = [XMToolClass validateMobileAndTel:self.accountView.textField.text];
    BOOL isCode = self.codeTextField.text.length > 0;
    BOOL isPSW = [XMToolClass validatePassword:self.pswView.textField.text];
    
    if (!isPhone) {
        
        
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        self.registerBtn.enabled = YES;
        return;
    }
    
    if (!isCode) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        self.registerBtn.enabled = YES;
        return;
    }
    
    if (!isPSW) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入6-20位字母和数字组合的密码"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        self.registerBtn.enabled = YES;
        return;
    }
    
    if (self.agreementBtn.selected) {
        
        [SVProgressHUD showErrorWithStatus:@"请阅读并同意用户协议"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        self.registerBtn.enabled = YES;
        return;
    }
    
    [self msgValidateCodePassWordRigister];
    
}

- (void)msgValidateCodePassWordRigister
{
    
    //传入的参数
    NSDictionary *parameters =
    @{
      @"mobile":self.accountView.textField.text,
      @"passWord":self.pswView.textField.text,
      @"appKey":ThirdAppkey,
      @"account":self.accountView.textField.text,
      @"pattern":@"10",
      @"msgValidateCode":self.codeTextField.text,
      @"face":@"http://jiedai.bianxianmao.com/images/face_jiedai.png",
      };
    
    NSString *url = [[NSString stringWithFormat:@"%@/user/msgValidateCodePassWordRigister", LOGINURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __weak typeof(self) weakSelf = self;
    
    // 发送请求
    [self.manager POST:url parameters:[XMToolClass parseParams:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.registerBtn.enabled = YES;
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
            DBAccount *account = [DBAccount accountWithDict:[responseObject objectForKey:@"returnValue"]];
            [DBSave save:account];
            
            
            [self addCustomerUserWithURL:@"/loanshop/user/addCustomerUser"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                weakSelf.navigationController.tabBarController.selectedIndex = 0;
                
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
            
        }else{
            
            
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"errorCode"]];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        APPDELEGATE.window.userInteractionEnabled = YES;
        [CommonMethod altermethord:TipFailure andmessagestr:TipFailureDetail andconcelstr:@"确定"];
        self.registerBtn.enabled = YES;
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



#pragma mark - 用户协议文本
- (void)agressmentWordBtnClick
{
    JDAgressmentWordViewController *vc = [[JDAgressmentWordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 是否同意用户协议
- (void)agreementBtnClick
{
    self.agreementBtn.selected = !self.agreementBtn.selected;
}

#pragma mark - 加载UI
- (void)loadUI
{
    //账号
    JDRegisterTextFieldView *accountView = [[JDRegisterTextFieldView alloc] init];
    accountView.titleLbl.text = @"账   号";
    accountView.textField.placeholder = @"请输入手机号码";
    accountView.textField.keyboardType = UIKeyboardTypePhonePad;
    [self.bgView addSubview:accountView];
    
    [accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    self.accountView = accountView;
    
    
    //验证码
    UILabel *codeLbl = [UILabel labelWithText:@"验证码" font:kFont(15) textColor:BlackGrayColor backGroundColor:ClearColor superView:self.bgView];
    [codeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(kMargin);
        make.height.mas_equalTo(55);
        make.top.mas_equalTo(accountView.mas_bottom);
    }];
    
    
    UIButton *codeBtn = [UIButton buttonWithTitle:@"获取验证码" font:kFont(15) titleColor:RGBCOLOR(68, 136, 251) backGroundColor:ClearColor buttonTag:0 target:self action:@selector(codeBtnClick:) showView:self.bgView];
    
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(-kMargin);
        make.top.mas_equalTo(accountView.mas_bottom);
        make.height.mas_equalTo(55);
        make.width.mas_equalTo(85);
    }];
    
    
    UITextField *codeTextField = [[UITextField alloc] init];
    codeTextField.font = kFont(15);
    codeTextField.placeholder = @"请输入验证码";
    codeTextField.textColor = BlackGrayColor;
    codeTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.bgView addSubview:codeTextField];
    
    [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(90);
        make.top.mas_equalTo(accountView.mas_bottom);
        make.height.mas_equalTo(55);
        make.right.mas_equalTo(codeBtn.mas_left).mas_equalTo(-kMargin);
    }];
    self.codeTextField = codeTextField;
    
    
    
    UIView *line = [UIView viewWithBackgroundColor:[XMToolClass getColorWithHexString:@"e5e5e5"] superView:self.bgView];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(codeBtn.mas_bottom);
    }];
    
    //密码
    JDRegisterTextFieldView *pswView = [[JDRegisterTextFieldView alloc] init];
    pswView.titleLbl.text = @"密   码";
    pswView.textField.placeholder = @"请输入密码";
    pswView.line.hidden = YES;
    pswView.textField.secureTextEntry = YES;
    pswView.textField.keyboardType = UIKeyboardTypeDefault;
    [self.bgView addSubview:pswView];
    
    [pswView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(54);
        make.top.mas_equalTo(line.mas_bottom);
        make.left.right.mas_equalTo(0);
    }];
    self.pswView = pswView;
    
    
    //注册
    UIButton *registerBtn = [UIButton buttonWithTitle:@"注   册" font:kFont(15) titleColor:WhiteColor backGroundColor:RGBCOLOR(68, 138, 251) buttonTag:0 target:self action:@selector(registerBtnClick) showView:self.view];
    
    registerBtn.layer.cornerRadius = 5;
    registerBtn.layer.masksToBounds = YES;
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(6);
        make.top.mas_equalTo(self.bgView.mas_bottom).mas_equalTo(10);
        make.right.mas_equalTo(-6);
        make.height.mas_equalTo(40);
    }];
    
    self.registerBtn = registerBtn;
    
    //用户协议
    CustomButton *agreementBtn = [CustomButton buttonWithLeftImage:@"check" title:@"我已阅读并同意" font:kFont(13) titleColor:BlackGrayColor backGroundColor:ClearColor target:self action:@selector(agreementBtnClick) showView:self.view];
    [agreementBtn setImage:[UIImage imageNamed:@"check_2"] forState:UIControlStateSelected];
    CGFloat agreementBtnW = [NSString sizeWithText:@"我已阅读并同意" font:kFont(13) maxSize:CGSizeMake(MAXFLOAT, 20)].width + 20;
    [agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(6);
        make.top.mas_equalTo(registerBtn.mas_bottom).mas_equalTo(kMargin);
        make.width.mas_equalTo(agreementBtnW);
    }];
    self.agreementBtn = agreementBtn;
    
    UIButton *agressmentWordBtn = [UIButton buttonWithTitle:@"《用户协议》" font:kFont(13) titleColor:RGBCOLOR(68, 138, 251) backGroundColor:ClearColor buttonTag:0 target:self action:@selector(agressmentWordBtnClick) showView:self.view];
    
    [agressmentWordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.agreementBtn.mas_right).mas_equalTo(2);
        make.centerY.mas_equalTo(agreementBtn.mas_centerY);
    }];
}



#pragma mark - 懒加载
- (UIView *)bgView
{
    if (!_bgView) {
       
        _bgView = [UIView viewWithBackgroundColor:WhiteColor superView:self.view];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(kNavigationH + 6);
            make.left.mas_equalTo(6);
            make.right.mas_equalTo(-6);
            make.height.mas_equalTo(55*3);
        }];
    }
    return _bgView;
}


- (XMGHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [XMGHTTPSessionManager manager];
    }
    return _manager;
}

@end
