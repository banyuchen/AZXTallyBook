//
//  JDInterface4ViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/8/23.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDInterface4ViewController.h"

@interface JDInterface4ViewController ()<UITableViewDelegate,UITableViewDataSource>

/**tableView*/
@property (nonatomic, strong) UITableView *tableView;
/**数据源*/
@property (nonatomic, strong) NSMutableArray *cellMulArr;
/**下一步*/
@property (nonatomic, strong) UIButton *lastBtn;
/**获取验证码*/
@property (nonatomic, strong) UIButton *codeBtn;

@end

@implementation JDInterface4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    
    self.navigationItem.title = @"添加银行卡";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *footerView = [UIView viewWithBackgroundColor:TableColor superView:nil];
    
    footerView.size = CGSizeMake(kWindowW, 55);
    
    self.lastBtn = [UIButton buttonWithTitle:@"添加" font:kFont(15) titleColor:WhiteColor backGroundColor:RGBCOLOR(31, 144, 230) buttonTag:0 target:self action:@selector(lastBtnClick) showView:footerView];
    
    self.lastBtn.layer.masksToBounds = YES;
    
    self.lastBtn.layer.cornerRadius = 4;
    
    [self.lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.centerY.mas_equalTo(0);
        make.left.mas_equalTo(3*kMargin);
        make.height.mas_equalTo(35);
    }];
    
    self.tableView.tableFooterView = footerView;
}
#pragma mark - 添加
- (void)lastBtnClick
{
    NSString *bankNumber = self.cellMulArr[1][2];
    
    for (int i = 0; i < self.cellMulArr.count; i ++) {
        
        NSString *string = self.cellMulArr[i][2];
        
        if (string.length == 0) {
            
            [SVProgressHUD showErrorWithStatus:self.cellMulArr[i][1]];
            [SVProgressHUD dismissWithDelay:0.5];
            return;
        }
    }
    
    if (![XMToolClass checkCardNo:bankNumber]) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入正确的银行卡号"];
        [SVProgressHUD dismissWithDelay:0.5];
        return;
        
    }
    
    
    [SVProgressHUD showErrorWithStatus:@"验证码错误"];
    
    [SVProgressHUD dismissWithDelay:0.5];
}

#pragma mark - 发送验证码
- (void)codeBtnClick:(UIButton *)sender
{
   BOOL isPhone = [XMToolClass validateMobile:self.cellMulArr[2][2]];
    
    if (isPhone) {
        
        
        [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
        [SVProgressHUD dismissWithDelay:kDelayTime];
        
        [CommonMethod GetVerificationCode:self.codeBtn finish:nil];
        
        
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        [SVProgressHUD dismissWithDelay:1];
    }
    
}
#pragma mark - UITextFieldDelegate


-(void)textChange:(UITextField *)textField{
   
    NSString  *bankName =  self.cellMulArr[0][1];
    NSString *bankNumber = self.cellMulArr[1][1];
    NSString *phone = self.cellMulArr[2][1];
    NSString *code = self.cellMulArr[3][1];
    
    
//    arr = @[
//            @[@"持卡人",@"请输入持卡人姓名",@""],
//            @[@"卡号",@"请输入卡号",@""],
//            @[@"预留手机号码",@"请输入预留号码",@""],
//            ];
    
    if ([textField.placeholder isEqualToString:bankName]) {
        
        NSArray *arr = @[@"持卡人",@"请输入持卡人姓名",textField.text];
        
        [self.cellMulArr replaceObjectAtIndex:0 withObject:arr];
        
        
    }else if ([textField.placeholder isEqualToString:bankNumber])
    {
        NSArray *arr = @[@"卡号",@"请输入卡号",textField.text];
        
        [self.cellMulArr replaceObjectAtIndex:1 withObject:arr];
        
    }else if ([textField.placeholder isEqualToString:phone])
    {
        NSArray *arr = @[@"预留手机号码",@"请输入预留号码",textField.text];
        
        [self.cellMulArr replaceObjectAtIndex:2 withObject:arr];
    }else if ([textField.placeholder isEqualToString:code])
    {
        NSArray *arr = @[@"验证码",@"请输入验证码",textField.text];
        
        [self.cellMulArr replaceObjectAtIndex:3 withObject:arr];
    }
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellMulArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *storeCityID = @"interface4ViewController";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCityID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
    }
    else
    {
        [cell removeFromSuperview];
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
    }
    
    UILabel *titleLbl = [UILabel labelWithText:self.cellMulArr[indexPath.row][0] font:kFont(14) textColor:BlackNameColor backGroundColor:ClearColor superView:cell];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(kMargin);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.font = kFont(14);
    
    textField.placeholder = self.cellMulArr[indexPath.row][1];
    
    NSString *textFieldStr = self.cellMulArr[indexPath.row][2];
    
    if (textFieldStr.length > 0) {
        
        textField.text = textFieldStr;
    }
    
    [cell addSubview:textField];
    //这种方法可以随时监听textField的字符变化
    [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-kMargin);
        make.left.mas_equalTo(2*kMargin+84);
        make.top.bottom.mas_equalTo(0);
        
    }];
    
    
    if (indexPath.row == 2) {
        
        UIButton *codeBtn = [UIButton buttonWithTitle:@"发送验证码" font:kFont(13) titleColor:WhiteColor backGroundColor:RGBCOLOR(31, 144, 230) buttonTag:0 target:self action:@selector(codeBtnClick:) showView:cell];
        
        
        codeBtn.layer.cornerRadius = 4;
        codeBtn.layer.masksToBounds = YES;
        
        
        [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.mas_equalTo(-kMargin);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        
        self.codeBtn = codeBtn;
    }
    
    return cell;
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = TableColor;
        
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(kNavigationH);
            make.left.right.bottom.mas_equalTo(0);
        }];
    }
    return _tableView;
}

- (NSMutableArray *)cellMulArr
{
    if (!_cellMulArr) {
        
        _cellMulArr = [[NSMutableArray alloc] init];
        
        NSArray *arr = [[NSArray alloc] init];
        
        arr = @[
                @[@"持卡人",@"请输入持卡人姓名",@""],
                @[@"卡号",@"请输入卡号",@""],
                @[@"预留手机号码",@"请输入预留号码",@""],
                @[@"验证码",@"请输入验证码",@""]
                ];
        
        _cellMulArr = [NSMutableArray arrayWithArray:arr];
    }
    return _cellMulArr;
}
@end
