//
//  JDSettingViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/8/29.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDSettingViewController.h"
#import "JDUpdatePassWordViewController.h"
#import "JDLoginViewController.h"
#import "JDAboutUsViewController.h"

#import "JDGOOUTViewController.h"

@interface JDSettingViewController ()<UITableViewDelegate,UITableViewDataSource,JDGOOUTViewControllerDelegate>

/**tableView*/
@property (nonatomic, strong) UITableView *tableView;

/**cell数据源*/
@property (nonatomic, strong) NSArray *cellArr;

@property (nonatomic, strong) PopAnimator *popAnimator;

@end

@implementation JDSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置";
    
    self.view.backgroundColor = TableColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *footerView = [UIView viewWithBackgroundColor:WhiteColor superView:nil];
    
    footerView.size = CGSizeMake(kWindowW, 60);
    
    NSString *goOutStr = [XMToolClass isBlankString:[DBSave account].ID] ? @"立即登录" : @"退出登录";
    
    UIButton *goOutBtn = [UIButton buttonWithTitle:goOutStr font:kFont(16) titleColor:[UIColor redColor] backGroundColor:ClearColor buttonTag:0 target:self action:@selector(goOutBtnClick) showView:footerView];
    
    [goOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(0);
    }];
    
    self.tableView.tableFooterView = footerView;
}

#pragma mark - 点击退出
- (void)didClickGoOutBtn
{
    
    
    DBAccount *account = [DBSave account];
    account.ID = @"";
    account.userToken = @"";
    [DBSave save:account];
    
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)goOutBtnClick
{
    
    
    if ([XMToolClass isBlankString:[DBSave account].ID]) {
        
        JDLoginViewController *vc = [[JDLoginViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        CGFloat width = (kWindowW - 4*kMargin);
        
        CGFloat height = 140;
        
        
        CGRect coverFrame = CGRectMake(0, 0, kWindowW, kWindowH);
        
        CGRect presentedFrame = CGRectMake(2*kMargin, (kWindowH - height)*0.5, width, height);
        
        
        self.popAnimator = [[PopAnimator alloc]initWithCoverFrame:coverFrame presentedFrame:presentedFrame startPoint:CGPointMake(0.5, 0.5) startTransform:CGAffineTransformMakeScale(0.1, 0.1) endTransform:CGAffineTransformMakeScale(0.0001, 0.0001)];
        
        JDGOOUTViewController *vc = [[JDGOOUTViewController alloc] init];
        
        vc.delegate = self;
        
        vc.view.layer.masksToBounds = YES;
        
        vc.view.layer.cornerRadius = 5;
        
        vc.modalPresentationStyle = UIModalPresentationCustom;
        
        vc.transitioningDelegate = self.popAnimator;
        
        [self presentViewController:vc animated:YES completion:nil];
        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        JDAboutUsViewController *vc = [[JDAboutUsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 1 ){
        
        
        if ([XMToolClass isBlankString:[DBSave account].ID]) {
            
            JDLoginViewController *vc = [[JDLoginViewController alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            
            JDUpdatePassWordViewController *vc = [[JDUpdatePassWordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellArr.count;
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = WhiteColor;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    
    imgView.image = [UIImage imageNamed:@"right_choice"];
    
    imgView.size = CGSizeMake(16, 16) ;
    
    cell.accessoryView = imgView;
    
    
    
    cell.textLabel.text = self.cellArr[indexPath.row];
    
    cell.textLabel.textColor = BlackGrayColor;
    
    cell.textLabel.font = kFont(14);
    
    if (indexPath.row == self.cellArr.count - 1) {
        
        UIView *line = [UIView viewWithBackgroundColor:SeparatorCOLOR superView:cell];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(15);
            make.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView viewWithBackgroundColor:TableColor superView:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
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


- (NSArray *)cellArr
{
    if (!_cellArr) {
        
        _cellArr = [[NSArray alloc] init];
        
//        _cellArr = @[@"关于我们",@"修改密码"];
        _cellArr = @[@"关于我们"];
    }
    return _cellArr;
}
@end
