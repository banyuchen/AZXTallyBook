//
//  JDInterface2ViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/8/22.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDInterface2ViewController.h"
#import "JDInterface3ViewController.h"

#import "JDInterface6ViewController.h"

@interface JDInterface2ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

/**tableView*/
@property (nonatomic, strong) UITableView *tableView;
/**确定*/
@property (nonatomic, strong) UIButton *agreeBtn;
/**借款金额*/
@property (nonatomic, strong) UITextField *priceField;
/**数据源*/
@property (nonatomic, strong) NSMutableArray *cellMulArrData;

/**记录上次输入的借款金额*/
@property (nonatomic, copy) NSString *lastTimePrice;
/**利率*/
@property (nonatomic, strong) UILabel *interestLbl;

@end

@implementation JDInterface2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"提交申请";
    
    self.view.backgroundColor =  WhiteColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *footerView = [UIView viewWithBackgroundColor:TableColor superView:nil];
    
    footerView.size = CGSizeMake(kWindowW, 55);
    
    self.agreeBtn = [UIButton buttonWithTitle:@"确定" font:kFont(15) titleColor:WhiteColor backGroundColor:RGBCOLOR(31, 144, 230) buttonTag:0 target:self action:@selector(agreeBtnClick) showView:footerView];
    
    self.agreeBtn.layer.masksToBounds = YES;
    
    self.agreeBtn.layer.cornerRadius = 4;
    
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.centerY.mas_equalTo(0);
        make.left.mas_equalTo(3*kMargin);
        make.height.mas_equalTo(35);
    }];
    
    self.tableView.tableFooterView = footerView;
}

#pragma mark - agreeBtnClick -- 确定
- (void)agreeBtnClick
{
    BOOL isPrice = self.priceField.text.length > 0;
    
    if (isPrice) {
        
        JDInterface6ViewController *vc = [[JDInterface6ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"请输入借款金额"];
        [SVProgressHUD dismissWithDelay:1];
    }
}

#pragma mark - UITextFieldDelegate

-(void)textChange:(UITextField *)textField{
#warning 修改输入金额额度
    
    if ([textField.text integerValue] > 9000) {
        
        [SVProgressHUD showErrorWithStatus:@"最多可借9000"];
        [SVProgressHUD dismissWithDelay:1];
        
        self.priceField.text = self.lastTimePrice;
    }else{
        
        self.lastTimePrice = textField.text;
        
        CGFloat interst = [self.lastTimePrice floatValue] * 31 * 0.25 * [self.cellMulArrData[0][1][1] floatValue]/1000;
        self.interestLbl.text = [NSString stringWithFormat:@"%0.2f",interst];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        arr = [NSMutableArray arrayWithArray:self.cellMulArrData[0]];
        
        NSArray *array = @[@"借多少",@"最多可借9,000元",self.lastTimePrice];
        NSArray *array1 = @[@"总利息",self.interestLbl.text];
        
        [arr replaceObjectAtIndex:0 withObject:array];
        [arr replaceObjectAtIndex:2 withObject:array1];
        
        [self.cellMulArrData replaceObjectAtIndex:0 withObject:arr];
        
    }
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"6个月" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            
            arr = [NSMutableArray arrayWithArray:self.cellMulArrData[0]];
            
            NSArray *array = @[@"借多久",@"6"];
            
            [arr replaceObjectAtIndex:1 withObject:array];
            
            
            CGFloat interst = [self.lastTimePrice floatValue] * 31 * 0.25 * 6/1000;
            self.interestLbl.text = [NSString stringWithFormat:@"%0.2f",interst];
            
            
            NSArray *array1 = @[@"总利息",self.interestLbl.text];
            
            [arr replaceObjectAtIndex:2 withObject:array1];
            
            [self.cellMulArrData replaceObjectAtIndex:0 withObject:arr];
            
            [self.tableView reloadData];
            
        }];
        UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"12个月" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            
            arr = [NSMutableArray arrayWithArray:self.cellMulArrData[0]];
            
            NSArray *array = @[@"借多久",@"12"];
            
            [arr replaceObjectAtIndex:1 withObject:array];
            
            
            CGFloat interst = [self.lastTimePrice floatValue] * 31 * 0.25 * 12/1000;
            self.interestLbl.text = [NSString stringWithFormat:@"%0.2f",interst];
            
            
            NSArray *array1 = @[@"总利息",self.interestLbl.text];
            
            [arr replaceObjectAtIndex:2 withObject:array1];
            
            
            [self.cellMulArrData replaceObjectAtIndex:0 withObject:arr];
            
            [self.tableView reloadData];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        [alertController addAction:archiveAction];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
        
    }else if (indexPath.section == 1 && indexPath.row == 0)
    {
        JDInterface3ViewController *vc = [[JDInterface3ViewController alloc] init];
        vc.cellBackBlock =  ^(NSArray *backArr){
            
            NZLog(@"%@",backArr[1]);
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 3 : 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *storeCityID = @"name";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCityID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
    }
    else
    {
        [cell removeFromSuperview];
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
    }
    
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        UILabel *titleLbl = [UILabel labelWithText:self.cellMulArrData[indexPath.section][indexPath.row][0] font:kFont(14) textColor:BlackNameColor backGroundColor:ClearColor superView:cell];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(kMargin);
        }];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.textAlignment = NSTextAlignmentRight;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = self.cellMulArrData[indexPath.section][indexPath.row][1];
        
        if ([NSString stringWithFormat:@"%@",self.cellMulArrData[indexPath.section][indexPath.row][2]].length > 0) {
            
            textField.text = self.cellMulArrData[indexPath.section][indexPath.row][2];
        }
        
        [textField setValue:kFont(14) forKeyPath:@"_placeholderLabel.font"];
        
        [cell addSubview:textField];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(titleLbl.mas_right).mas_equalTo(kMargin);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-2.5*kMargin);
            
            make.top.bottom.mas_equalTo(0);
        }];
        self.priceField = textField;
        
        //这种方法可以随时监听textField的字符变化
        [self.priceField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];

        
    }else if (indexPath.section == 0 && indexPath.row == 1){
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel *titleLbl = [UILabel labelWithText:self.cellMulArrData[indexPath.section][indexPath.row][0] font:kFont(14) textColor:BlackNameColor backGroundColor:ClearColor superView:cell];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(kMargin);
        }];
        
        UILabel *desLbl = [UILabel labelWithText:[NSString stringWithFormat:@"%@个月",self.cellMulArrData[indexPath.section][indexPath.row][1] ] font:kFont(14) textColor:BlackGrayColor backGroundColor:ClearColor superView:cell];
        [desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-2.5*kMargin);
        }];
        
        
    }else if (indexPath.section == 0 && indexPath.row == 2){
        
        UILabel *titleLbl = [UILabel labelWithText:self.cellMulArrData[indexPath.section][indexPath.row][0] font:kFont(14) textColor:BlackNameColor backGroundColor:ClearColor superView:cell];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(kMargin);
        }];
        
        UILabel *desLbl = [UILabel labelWithText:self.cellMulArrData[indexPath.section][indexPath.row][1] font:kFont(14) textColor:BlackGrayColor backGroundColor:ClearColor superView:cell];
        [desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-2.5*kMargin);
        }];
        
        self.interestLbl = desLbl;
        
    }else if (indexPath.section == 1 && indexPath.row == 0){
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        [cell addSubview:imgView];
        imgView.image = [UIImage imageNamed:@"china_bank"];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(kMargin);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(55, 55));
        }];
        
        UILabel *accountLbl = [UILabel labelWithText:self.cellMulArrData[indexPath.section][indexPath.row][0] font:kFont(16) textColor:BlackNameColor backGroundColor:ClearColor superView:cell];
        [accountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.mas_equalTo(0).mas_equalTo(-8.5);
            make.left.mas_equalTo(imgView.mas_right).mas_equalTo(10);
        }];
        
        UILabel *bankLbl = [UILabel labelWithText:self.cellMulArrData[indexPath.section][indexPath.row][1] font:kFont(14) textColor:BlackGrayColor backGroundColor:ClearColor superView:cell];
        [bankLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(accountLbl.mas_left);
            make.centerY.mas_equalTo(0).mas_equalTo(8.5);
        }];
        
        UILabel *bankNumberLbl = [UILabel labelWithText:self.cellMulArrData[indexPath.section][indexPath.row][2] font:kFont(14) textColor:RGBCOLOR(31, 144, 230) backGroundColor:ClearColor superView:cell];
        
        [bankNumberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-2.5*kMargin);
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView viewWithBackgroundColor:TableColor superView:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        return 80;
    }else if (indexPath.section == 0 && indexPath.row == 1){
        
        return 60;
    }else if (indexPath.section == 0 && indexPath.row == 2){
        
        return 60;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        
        return 70;
    }
    else{
        
        return 44;
    }
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

- (NSMutableArray *)cellMulArrData
{
    if (!_cellMulArrData) {
        
        _cellMulArrData = [[NSMutableArray alloc] init];
        
        NSArray *arr = @[
                         @[
                             @[@"借多少",@"最多可借9,000元",@""],
                             @[@"借多久",@"6"],
                             @[@"总利息",@"0"],
                             ],
                         @[
                             @[
                                 @"收款账号",@"中国银行",@"尾号0379",
                                 ],
                             ],
                         ];
        
        _cellMulArrData = [NSMutableArray arrayWithArray:arr];
    }
    return _cellMulArrData;
}
@end
