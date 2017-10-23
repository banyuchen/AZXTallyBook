//
//  JDUpdatePassWordViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/8/31.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDUpdatePassWordViewController.h"
#import "JDRegisterTextFieldView.h"

#import "XMGHTTPSessionManager.h"
#import "JDLoginViewController.h"

@interface JDUpdatePassWordViewController ()
/**输入框背景*/
@property (nonatomic, strong) UIView *bgView;
/**账号*/
@property (nonatomic, strong) JDRegisterTextFieldView *accountView;
/**原密码*/
@property (nonatomic, strong) JDRegisterTextFieldView *oldPSWView;
/**新密码*/
@property (nonatomic, strong) JDRegisterTextFieldView *pswView;
/**确认醒密码*/
@property (nonatomic, strong) JDRegisterTextFieldView *pswConfirmView;
/** 任务管理者 */
@property (nonatomic, strong) XMGHTTPSessionManager *manager;
/**确定*/
@property (nonatomic, strong) UIButton  *registerBtn;

@end

@implementation JDUpdatePassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TableColor;
    
    self.navigationItem.title = @"修改密码";
    
    [self loadUI];
}

#pragma mark - 确定
- (void)registerBtnClick
{
    [self.view endEditing:YES];
    
    self.registerBtn.enabled = NO;
    
    BOOL isPhone = [XMToolClass validateMobileAndTel:self.accountView.textField.text];
    BOOL isOldPSW = self.oldPSWView.textField.text.length > 0;
    BOOL isPSW = [XMToolClass validatePassword:self.pswView.textField.text];
    BOOL iSPSWConfirm = [XMToolClass validatePassword:self.pswConfirmView.textField.text];
    
    BOOL isDef = [self.pswConfirmView.textField.text isEqualToString:self.pswView.textField.text];
    
    if (!isPhone) {
        
        
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        
        self.registerBtn.enabled = YES;
        
        return;
    }
    
    if (!isOldPSW) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入原密码"];
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
        
        [SVProgressHUD showErrorWithStatus:@"请确认新密码"];
        [SVProgressHUD dismissWithDelay:0.5];
        self.registerBtn.enabled = YES;
        
        return;
    }
    
    if (isDef) {
        
        [self getUserByToken];
        
        return;
    }
    else{
        
        [SVProgressHUD showErrorWithStatus:@"俩次输入的密码不一致"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        
        self.registerBtn.enabled = YES;
        
        return;
    }
    
}

#pragma mark - 根据token获取用户信息
- (void)getUserByToken
{
    
    /**
     根据token获取用户信息
     */
    NSDictionary *parameters2 =
    @{
      @"userToken":[DBSave account].userToken,
      };
    
    NZLog(@"%@",[DBSave account].userToken);
    NSString *url2 = [[NSString stringWithFormat:@"%@/user/getUserByToken/%@",LOGINURL,[DBSave account].userToken] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    // 发送请求
    [self.manager GET:url2 parameters:parameters2 progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            DBAccount *account = [DBSave account];
            //            account.appUid = [[responseObject valueForKey:@"returnValue"] valueForKey:@"appUid"];
            account.ID = [[responseObject valueForKey:@"returnValue"] valueForKey:@"id"];
            account.nickname = [[responseObject valueForKey:@"returnValue"] valueForKey:@"nickname"];
            //            account.imei = [[responseObject valueForKey:@"returnValue"] valueForKey:@"imei"];
            account.face = [[responseObject valueForKey:@"returnValue"] valueForKey:@"face"];
            //            account.idfa = [[responseObject valueForKey:@"returnValue"] valueForKey:@"idfa"];
            [DBSave save:account];
            
            [self msgValidateCodeFogeterPassWord];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"登录已失效，请重新登录"];
            [SVProgressHUD dismissWithDelay:0.5];
            
            DBAccount *account = [DBSave account];
            account.ID = @"";
            account.userToken = @"";
            [DBSave save:account];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                JDLoginViewController *vc = [[JDLoginViewController alloc] init];
                
                [self.navigationController pushViewController:vc animated:YES];
                
            });
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        APPDELEGATE.window.userInteractionEnabled = YES;
        [CommonMethod altermethord:TipFailure andmessagestr:TipFailureDetail andconcelstr:@"确定"];
    }];
    
}

- (void)msgValidateCodeFogeterPassWord
{
    
    //传入的参数
    NSDictionary *parameters =
    @{
      @"account":self.accountView.textField.text,
      @"oldPassWord":self.oldPSWView.textField.text,
      @"newPassWord":self.pswView.textField.text,
      @"appKey":ThirdAppkey,
      @"pattern":@"10",
      @"token":[DBSave account].userToken,
      };
    
    NSString *url = [[NSString stringWithFormat:@"%@/user/updatePassWord", LOGINURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __weak typeof(self) weakSelf = self;
    
    // 发送请求
    [self.manager POST:url parameters:[XMToolClass parseParams:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.registerBtn.enabled = YES;
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
        
            [SVProgressHUD showSuccessWithStatus:@"修改密码成功"];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
            
            DBAccount *account = [DBSave account];
            account.userToken = [responseObject valueForKey:@"returnValue"];
            [DBSave save:account];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"errorCode"]];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        self.registerBtn.enabled = YES;
        
        [CommonMethod altermethord:TipFailure andmessagestr:TipFailureDetail andconcelstr:@"确定"];
        self.registerBtn.enabled = YES;
    }];
}

#pragma mark - 加载UI
- (void)loadUI
{
    //账号
    JDRegisterTextFieldView *accountView = [[JDRegisterTextFieldView alloc] init];
    accountView.titleLbl.text = @"账   号";
    accountView.textField.placeholder = @"请输入注册手机号";
    accountView.textField.keyboardType = UIKeyboardTypePhonePad;
    accountView.textField.text = [DBSave account].account;
    [self.bgView addSubview:accountView];
    
    [accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    self.accountView = accountView;
    
    
    //原密码
    JDRegisterTextFieldView *oldPSWView = [[JDRegisterTextFieldView alloc] init];
    oldPSWView.titleLbl.text = @"原密码";
    oldPSWView.textField.secureTextEntry = YES;
    oldPSWView.textField.placeholder = @"请输入原密码";
    oldPSWView.textField.keyboardType = UIKeyboardTypeDefault;
    [self.bgView addSubview:oldPSWView];
    [oldPSWView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(55);
        make.top.mas_equalTo(accountView.mas_bottom);
        make.left.right.mas_equalTo(0);
    }];
    self.oldPSWView = oldPSWView;
    
    
    //新密码
    JDRegisterTextFieldView *pswView = [[JDRegisterTextFieldView alloc] init];
    pswView.titleLbl.text = @"新密码";
    pswView.textField.placeholder = @"请输入新密码";
    pswView.textField.secureTextEntry = YES;
    pswView.textField.keyboardType = UIKeyboardTypeDefault;
    [self.bgView addSubview:pswView];
    
    [pswView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(55);
        make.top.mas_equalTo(oldPSWView.mas_bottom);
        make.left.right.mas_equalTo(0);
    }];
    self.pswView = pswView;
    
    //确认密码
    JDRegisterTextFieldView *pswConfirmView = [[JDRegisterTextFieldView alloc] init];
    pswConfirmView.titleLbl.text = @"确认密码";
    pswConfirmView.textField.placeholder = @"请确认新密码";
    pswConfirmView.textField.secureTextEntry = YES;
    pswConfirmView.textField.keyboardType = UIKeyboardTypeDefault;
    pswConfirmView.line.hidden = YES;
    [self.bgView addSubview:pswConfirmView];
    
    [pswConfirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(55);
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
