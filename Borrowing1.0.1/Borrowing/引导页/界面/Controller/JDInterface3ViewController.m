//
//  JDInterface3ViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/8/23.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDInterface3ViewController.h"
#import "JDInterface3TableViewCell.h"
#import "JDInterface4ViewController.h"

@interface JDInterface3ViewController ()<UITableViewDelegate,UITableViewDataSource>

/**tableView*/
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JDInterface3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    
    self.navigationItem.title = @"选择收款账号";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *footerView = [UIView viewWithBackgroundColor:TableColor superView:nil];
    
    footerView.size = CGSizeMake(kWindowW, 100);
    
    UILabel *lable = [UILabel labelWithText:@"目前支持：网商银行、工行、招行、建行、中行、农行、交行、浦东、广发、中信、光大、兴业、明生、平安。" font:kFont(10) textColor:BlackGrayColor backGroundColor:ClearColor superView:footerView];
    lable.numberOfLines = 0;
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-kMargin);
        make.left.mas_equalTo(kMargin);
        make.top.mas_equalTo(8);
    }];
    
    self.tableView.tableFooterView = footerView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        JDInterface4ViewController *vc = [[JDInterface4ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        if (self.cellBackBlock) {
            self.cellBackBlock(@[@"1",@"2"]);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 55 : 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *storeCityID = @"JDInterface3TableViewCell.h";
        
        JDInterface3TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCityID];
        
        if (cell == nil) {
            cell = [[JDInterface3TableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
        }
        else
        {
            [cell removeFromSuperview];
            
            cell = [[JDInterface3TableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        cell.cellArr = @[@"china_bank",@"中国银行",@"尾号0379",@"04:00:00-21:00:00内支持俩小时内到账"];
        
        return cell;
    }else{
        
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
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel *titleLbl = [UILabel labelWithText:@"添加储蓄卡" font:kFont(14) textColor:BlackNameColor backGroundColor:ClearColor superView:cell];
        
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(kMargin);
        }];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView viewWithBackgroundColor:TableColor superView:nil];
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
@end
