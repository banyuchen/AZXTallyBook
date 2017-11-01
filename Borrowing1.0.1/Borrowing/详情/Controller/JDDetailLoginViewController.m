//
//  JDDetailLoginViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/10/24.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDDetailLoginViewController.h"
#import "XMGHTTPSessionManager.h"

@interface JDDetailLoginViewController ()

/**手机号*/
@property (nonatomic, strong) UITextField *phoneTextField;
/**验证码*/
@property (nonatomic, strong) UITextField *codeTextField;
/**获取验证码*/
@property (nonatomic, strong) UIButton *codeBtn;
/** 任务管理者 */
@property (nonatomic, strong) XMGHTTPSessionManager *manager;
/**<#name#>*/
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation JDDetailLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = WhiteColor;
    [self loadUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logoinBtnClick
{
    NZLog(@"登录");
    [self.view endEditing:YES];
    
    self.loginBtn.enabled = NO;
    
    BOOL isPhone = [XMToolClass validateMobileAndTel:self.phoneTextField.text];
    BOOL isCode = self.codeTextField.text.length > 0;
    
    if (!isPhone) {
        
        
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        self.loginBtn.enabled = YES;
        return;
    }
    
    if (!isCode) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        self.loginBtn.enabled = YES;
        
        return;
    }
    
    [self codeLoginByJiedai];
    
}



- (void)codeLoginByJiedai
{
    //传入的参数
    NSDictionary *parameters =
    @{
      @"msgValidateCode":[XMToolClass md5:self.codeTextField.text],
      @"appKey":ThirdAppkey,
      @"mobile":self.phoneTextField.text,
      @"pattern":@"10",
      };
    
    NSString *url = [[NSString stringWithFormat:@"%@/user/msgValidateCodeLoginByJiedai", LOGINURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __weak typeof(self) weakSelf = self;
    
    // 发送请求
    [self.manager POST:url parameters:[XMToolClass parseParams:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        weakSelf.loginBtn.enabled = YES;
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
            DBAccount *account = [DBAccount accountWithDict:[responseObject objectForKey:@"returnValue"]];
            [DBSave save:account];
            
            if ([[[responseObject valueForKey:@"returnValue"] valueForKey:@"appUid"] isEqualToString:@"2"]) {
                
                //判断是登录还是注册
                [weakSelf addCustomerUserWithURL:@"/loanshop/user/addCustomerUser"];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
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




#pragma mark - 获取验证码
- (void)codeBtnClick:(UIButton *)sender
{
    
    sender.userInteractionEnabled = NO;
    
    NSString *phone = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    BOOL isPhone = [XMToolClass validateMobile:phone];
    
    if (!isPhone) {
        [CommonMethod altermethord:@"请输入正确的手机号码" andmessagestr:@"" andconcelstr:@"确定"];
        
        sender.userInteractionEnabled = YES;
        return;
    }
    
    
    //传入的参数
    NSDictionary *parameters =
    @{
      @"mobile":self.phoneTextField.text,
      };
    
    NSString *url = [[NSString stringWithFormat:@"%@/user/sendMsgValidateCodeByOther", LOGINURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // 发送请求
    [self.manager POST:url parameters:[XMToolClass parseParams:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            
            [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
            [CommonMethod GetVerificationCode:sender finish:nil];
            
        }else{
            
            sender.userInteractionEnabled = YES;
            
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"errorCode"]];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        sender.userInteractionEnabled = YES;
        
        APPDELEGATE.window.userInteractionEnabled = YES;
        [CommonMethod altermethord:TipFailure andmessagestr:TipFailureDetail andconcelstr:@"确定"];
    }];
    
}

- (void)loadUI
{
    /************************************************弹窗框头部视图*****************************************************/
    
    UIView *headerView = [UIView viewWithBackgroundColor:TableColor superView:self.view];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
        
    }];
    
    UILabel *titleLbl = [UILabel labelWithText:@"验证手机号" font:kFont(16) textColor:BlackGrayColor  backGroundColor:ClearColor superView:headerView];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(kMargin*1.5);
        make.centerY.mas_equalTo(0);
    }];
    
    
    UIButton *exitBtn = [UIButton buttonWithImage:@"fork" target:self action:@selector(backClick) showView:headerView];
    exitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(-kMargin*1.5);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];

    /****************************************************输入框视图******************************************************/
    //手机号
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.font = kFont(15);
    self.phoneTextField.placeholder = @"请输入手机号";
    self.phoneTextField.textColor = BlackGrayColor;
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:self.phoneTextField];

    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin*1.5);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(-kMargin*1.5);
        make.top.mas_equalTo(headerView.mas_bottom).mas_equalTo(10);
    }];

    UIView *phoneLine = [UIView viewWithBackgroundColor:[XMToolClass getColorWithHexString:@"999999"] superView:self.view];
    [phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(kMargin*1.5);
        make.right.mas_equalTo(-kMargin*1.5);
        make.top.mas_equalTo(self.phoneTextField.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];

    //获取验证码
    self.codeBtn = [UIButton buttonWithTitle:@"获取验证码" font:kFont(15) titleColor:WhiteColor backGroundColor:RGBCOLOR(68, 136, 251) buttonTag:0 target:self action:@selector(codeBtnClick:) showView:self.view];
    
    self.codeBtn.layer.cornerRadius = 4;
    self.codeBtn.layer.masksToBounds = YES;
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneLine.mas_bottom).mas_equalTo(10+1.5);
        make.right.mas_equalTo(-kMargin*1.5);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(90);
    }];

    self.codeTextField = [[UITextField alloc] init];
    self.codeTextField.font = kFont(15);
    self.codeTextField.placeholder = @"请输入验证码";
    self.codeTextField.textColor = BlackGrayColor;
    self.codeTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:self.codeTextField];

    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(phoneLine.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(kMargin*1.5);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(self.codeBtn.mas_left).mas_equalTo(-kMargin*1.5);
    }];

    UIView *codeLine = [UIView viewWithBackgroundColor:[XMToolClass getColorWithHexString:@"999999"]  superView:self.view];
    [codeLine mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(kMargin*1.5);
        make.right.mas_equalTo(-kMargin*1.5);
        make.top.mas_equalTo(self.codeTextField.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];

    UIButton *logoinBtn = [UIButton buttonWithTitle:@"完成" font:kFont(18) titleColor:WhiteColor backGroundColor:RGBCOLOR(68, 136, 251) buttonTag:0 target:self action:@selector(logoinBtnClick) showView:self.view];
    logoinBtn.layer.cornerRadius = 4;
    logoinBtn.layer.masksToBounds = YES;
    [logoinBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(kMargin*1.5);
        make.right.mas_equalTo(-kMargin*1.5);
        make.top.mas_equalTo(codeLine.mas_bottom).mas_equalTo(30);
        make.height.mas_equalTo(40);
    }];
    self.loginBtn = logoinBtn;
    
    
    //设置数据
    DBAccount *account = [DBSave account];
    if (![XMToolClass isBlankString:account.account]) {
        
        self.phoneTextField.text = account.account;
        
    }
}

- (XMGHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [XMGHTTPSessionManager manager];
    }
    return _manager;
}
@end
