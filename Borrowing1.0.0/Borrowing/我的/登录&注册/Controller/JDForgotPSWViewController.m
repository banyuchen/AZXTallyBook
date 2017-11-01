//
//  JDForgotPSWViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/8/31.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDForgotPSWViewController.h"
#import "JDRegisterTextFieldView.h"
#import "XMGHTTPSessionManager.h"

@interface JDForgotPSWViewController ()

/**输入框背景*/
@property (nonatomic, strong) UIView *bgView;
/**账号*/
@property (nonatomic, strong) JDRegisterTextFieldView *accountView;
/**验证码*/
@property (nonatomic, strong) UITextField *codeTextField;
/**新密码*/
@property (nonatomic, strong) JDRegisterTextFieldView *pswView;
/**确认醒密码*/
@property (nonatomic, strong) JDRegisterTextFieldView *pswConfirmView;
/** 任务管理者 */
@property (nonatomic, strong) XMGHTTPSessionManager *manager;
/**确定*/
@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation JDForgotPSWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"忘记密码";
    
    self.view.backgroundColor = TableColor;
    
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
        
        
    }];
    
}

#pragma mark - 确定
- (void)registerBtnClick
{
    [self.view endEditing:YES];
    
    self.registerBtn.enabled = NO;
    
    BOOL isPhone = [XMToolClass validateMobileAndTel:self.accountView.textField.text];
    BOOL isCode = self.codeTextField.text.length > 0;
    BOOL isPSW = [XMToolClass validatePassword:self.pswView.textField.text];
    BOOL iSPSWConfirm = self.pswConfirmView.textField.text.length > 0;
    
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
        
        [SVProgressHUD showErrorWithStatus:@"请输入6位字母和数字组合的密码"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        
        self.registerBtn.enabled = YES;
        
        return;
    }
    
    if (!iSPSWConfirm) {
        
        [SVProgressHUD showErrorWithStatus:@"请确定新密码"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        self.registerBtn.enabled = YES;
        
        return;
    }
    
    [self msgValidateCodeFogeterPassWord];
}


- (void)msgValidateCodeFogeterPassWord
{
    
    //传入的参数
    NSDictionary *parameters =
    @{
      @"passWord":self.pswView.textField.text,
      @"confirmPassWord":self.pswConfirmView.textField.text,
      @"appKey":ThirdAppkey,
      @"account":self.accountView.textField.text,
      @"mobile":self.accountView.textField.text,
      @"pattern":@"10",
      @"msgValidateCode":self.codeTextField.text,
      };
    
    NSString *url = [[NSString stringWithFormat:@"%@/user/msgValidateCodeFogeterPassWord", LOGINURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __weak typeof(self) weakSelf = self;
    
    // 发送请求
    [self.manager POST:url parameters:[XMToolClass parseParams:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.registerBtn.enabled = YES;
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            DBAccount *account = [[DBAccount alloc] init];
            account.account = self.accountView.textField.text;
            [DBSave save:account];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"errorCode"]];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        self.registerBtn.enabled = YES;
        
        APPDELEGATE.window.userInteractionEnabled = YES;
        [CommonMethod altermethord:TipFailure andmessagestr:TipFailureDetail andconcelstr:@"确定"];
    }];
}

#pragma mark - 加载UI
- (void)loadUI
{
    //账号
    JDRegisterTextFieldView *accountView = [[JDRegisterTextFieldView alloc] init];
    accountView.titleLbl.text = @"账   号";
    accountView.textField.placeholder = @"请输入手机号";
    accountView.textField.keyboardType = UIKeyboardTypePhonePad;
    accountView.textField.text = [DBSave account].account;
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
    
    //新密码
    JDRegisterTextFieldView *pswView = [[JDRegisterTextFieldView alloc] init];
    pswView.titleLbl.text = @"新密码";
    pswView.textField.placeholder = @"请输入新密码";
    pswView.textField.keyboardType = UIKeyboardTypeDefault;
    pswView.textField.secureTextEntry = YES;
    [self.bgView addSubview:pswView];
    
    [pswView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(54);
        make.top.mas_equalTo(line.mas_bottom);
        make.left.right.mas_equalTo(0);
    }];
    self.pswView = pswView;
    
    //确认密码
    
    JDRegisterTextFieldView *pswConfirmView = [[JDRegisterTextFieldView alloc] init];
    pswConfirmView.titleLbl.text = @"确认密码";
    pswConfirmView.textField.placeholder = @"请确认新密码";
    pswConfirmView.textField.keyboardType = UIKeyboardTypeDefault;
    pswConfirmView.textField.secureTextEntry = YES;
    pswConfirmView.line.hidden = YES;
    [self.bgView addSubview:pswConfirmView];
    
    [pswConfirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(54);
        make.top.mas_equalTo(pswView.mas_bottom);
        make.left.right.mas_equalTo(0);
    }];
    self.pswConfirmView = pswConfirmView;
    
    
    //注册
    UIButton *registerBtn = [UIButton buttonWithTitle:@"确   定" font:kFont(15) titleColor:WhiteColor backGroundColor:RGBCOLOR(68, 138, 251) buttonTag:0 target:self action:@selector(registerBtnClick) showView:self.view];
    
    registerBtn.layer.cornerRadius = 5;
    registerBtn.layer.masksToBounds = YES;
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(6);
        make.top.mas_equalTo(self.bgView.mas_bottom).mas_equalTo(10);
        make.right.mas_equalTo(-6);
        make.height.mas_equalTo(40);
    }];
    self.registerBtn = registerBtn;
    
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
            make.height.mas_equalTo(55*4);
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
