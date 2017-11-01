//
//  JDInterfaceViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/8/22.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDInterfaceViewController.h"
#import "JDInterfaceFooterView.h"
#import "JDInterface2ViewController.h"
#import "JDLoginViewController.h"


@interface JDInterfaceViewController ()<UITableViewDelegate,UITableViewDataSource,JDInterfaceFooterViewDelegate>

/**tableView*/
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation JDInterfaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([XMToolClass isBlankString:[DBSave account].ID]) {
        
        JDLoginViewController *vc = [[JDLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        JDInterfaceFooterView *footerView = [[JDInterfaceFooterView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 110)];
        footerView.delegate = self;
        self.tableView.tableFooterView = footerView;
    }
}

#pragma mark - 去借钱
- (void)interfaceFooterViewDidGoBorrowBtn
{
    
    JDInterface2ViewController *vc = [[JDInterface2ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    
    cell.backgroundColor = RGBCOLOR(31, 144, 230);
    
    //可借金额文字
    UILabel *pwordLbl = [UILabel labelWithText:@"可借的钱(元)" font:kFont(15) textColor:WhiteColor backGroundColor:ClearColor superView:cell];
    
    [pwordLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(0).multipliedBy(0.5);
        make.left.mas_equalTo(3*kMargin);
        
    }];
    
    //可借的金额
    UILabel *priceLbl = [UILabel labelWithText:@"9,000" font:kFont(50) textColor:WhiteColor backGroundColor:ClearColor superView:cell];
    
    [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(3*kMargin);
    }];
    
    //总额度文字
    UILabel *awordLbl = [UILabel labelWithText:@"总额度" font:kFont(15) textColor:WhiteColor backGroundColor:ClearColor superView:cell];
    
    [awordLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(0).multipliedBy(1.5);
        make.left.mas_equalTo(3*kMargin);
    }];
    
    UILabel *amountLbl = [UILabel labelWithText:@"9,000" font:kFont(15) textColor:WhiteColor backGroundColor:ClearColor superView:cell];
    
    [amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(awordLbl.mas_bottom).mas_equalTo(2);
        make.left.mas_equalTo(3*kMargin);
    }];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230;
}



#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(kNavigationH);
            make.left.right.bottom.mas_equalTo(0);
        }];
    }
    return _tableView;
}

@end
