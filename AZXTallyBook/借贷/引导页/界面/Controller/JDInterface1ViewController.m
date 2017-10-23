//
//  JDInterface1ViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/8/22.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDInterface1ViewController.h"
#import "JDMyTableViewCell.h"
#import "XMGHTTPSessionManager.h"

#import "JDMyheaderView.h"

#import "JDMyIndividuationViewController.h"
#import "JDSettingViewController.h"
#import "JDLoginViewController.h"//登录
//#import "JDRegisterViewController.h"
#import "JDFAQViewController.h"//常见问题
#import "JDBrowsingHistoryViewController.h"

#import "JDStatisticsManager.h"

#import "JDInterface5ViewController.h"

@interface JDInterface1ViewController ()<UITableViewDataSource,UITableViewDelegate,JDMyheaderViewDelegate>

/**cellArr*/
@property (nonatomic, strong) NSArray<JDBorrowMyCellModel *> *cellArr;

/**tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** 任务管理者 */
@property (nonatomic, strong) XMGHTTPSessionManager *manager;

@end

@implementation JDInterface1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TableColor;
    
    self.navigationItem.title = @"我的";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.tableFooterView = [UIView new];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![XMToolClass isBlankString:[DBSave account].userToken]) {
        
        //        [self getUserByToken];
        
        DBAccount *account = [DBSave account];
        
        JDMyheaderView *headerView = [[JDMyheaderView alloc] init];
        headerView.delegate = self;
        headerView.account = account;
        headerView.size = CGSizeMake(kWindowW, KActualH(346));
        headerView.backgroundColor = WhiteColor;
        
        self.tableView.tableHeaderView = headerView;
    }else{
        
        DBAccount *account = [DBSave account];
        account.ID = @"";
        [DBSave save:account];
        
        JDMyheaderView *headerView = [[JDMyheaderView alloc] init];
        headerView.delegate = self;
        headerView.account = account;
        headerView.size = CGSizeMake(kWindowW, KActualH(346));
        headerView.backgroundColor = WhiteColor;
        
        self.tableView.tableHeaderView = headerView;
    }
    
    
}

#pragma mark - 立即登录
- (void)myheaderViewDidSelectLogoInBtn
{
    JDLoginViewController *vc = [[JDLoginViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        
        if ([XMToolClass isBlankString:[DBSave account].ID]) {
            
            JDLoginViewController *vc = [[JDLoginViewController alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            JDInterface5ViewController *vc = [[JDInterface5ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (indexPath.row == 1){
        
        
        if ([XMToolClass isBlankString:[DBSave account].ID]) {
            
            JDLoginViewController *vc = [[JDLoginViewController alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            
            JDMyIndividuationViewController *vc = [[JDMyIndividuationViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (indexPath.row == 2){
         
        JDSettingViewController *vc = [[JDSettingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KActualH(133);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *storeCityID = @"JDMyTableViewCell";
    
    JDMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCityID];
    
    if (cell == nil) {
        cell = [[JDMyTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
    }
    else
    {
        [cell removeFromSuperview];
        
        cell = [[JDMyTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.cellDic = self.cellArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView viewWithBackgroundColor:TableColor superView:nil];
}

#pragma mark - 根据token获取用户信息
- (void)getUserByToken
{
    
    /**
     首页banner接口(轮播图)
     */
    NSDictionary *parameters2 =
    @{
      @"userToken":[DBSave account].userToken,
      };
    
    NSString *url2 = [[NSString stringWithFormat:@"%@/user/getUserByToken/%@",LOGINURL,[DBSave account].userToken] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __weak typeof(self) weakSelf = self;
    
    // 发送请求
    [self.manager GET:url2 parameters:parameters2 progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            DBAccount *account = [DBSave account];
            account.appUid = [[responseObject valueForKey:@"returnValue"] valueForKey:@"appUid"];
            account.ID = [[responseObject valueForKey:@"returnValue"] valueForKey:@"id"];
            account.nickname = [[responseObject valueForKey:@"returnValue"] valueForKey:@"nickname"];
            account.imei = [[responseObject valueForKey:@"returnValue"] valueForKey:@"imei"];
            account.face = [[responseObject valueForKey:@"returnValue"] valueForKey:@"face"];
            account.userToken = [[responseObject valueForKey:@"returnValue"] valueForKey:@"userToken"];
            account.idfa = [[responseObject valueForKey:@"returnValue"] valueForKey:@"idfa"];
            [DBSave save:account];
            
            JDMyheaderView *headerView = [[JDMyheaderView alloc] init];
            headerView.delegate = weakSelf;
            headerView.account = [DBSave account];
            headerView.size = CGSizeMake(kWindowW, KActualH(346));
            headerView.backgroundColor = WhiteColor;
            
            weakSelf.tableView.tableHeaderView = headerView;
            
        }else{
            
            DBAccount *account = [DBSave account];
            account.ID = @"";
            [DBSave save:account];
            
            JDMyheaderView *headerView = [[JDMyheaderView alloc] init];
            headerView.delegate = weakSelf;
            headerView.account = account;
            headerView.size = CGSizeMake(kWindowW, KActualH(346));
            headerView.backgroundColor = WhiteColor;
            
            weakSelf.tableView.tableHeaderView = headerView;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        DBAccount *account = [DBSave account];
        account.ID = @"";
        account.userToken = @"";
        [DBSave save:account];
        
        JDMyheaderView *headerView = [[JDMyheaderView alloc] init];
        headerView.delegate = weakSelf;
        headerView.account = account;
        headerView.size = CGSizeMake(kWindowW, KActualH(346));
        headerView.backgroundColor = WhiteColor;
        
        weakSelf.tableView.tableHeaderView = headerView;
    }];
    
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        
        _tableView.backgroundColor = TableColor;
        
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


- (NSArray <JDBorrowMyCellModel *> *)cellArr
{
    if (!_cellArr) {
        
        NSArray *titleArr = @[@[@"mine_record",@"借款记录",],
                              @[@"mine_collect",@"借款意向",],
//                              @[@"mine_Q&A",@"常见问题",],
                              @[@"mine_setup",@"设置",],
                              ];
        
        NSMutableArray<JDBorrowMyCellModel *> *cellMulArr = [[NSMutableArray alloc] init];
        
        for (NSArray *arr in titleArr) {
            
            JDBorrowMyCellModel *cellModel = [[JDBorrowMyCellModel alloc] init];
            
            cellModel.cellIconImg = arr[0];
            
            cellModel.cellTitle = arr[1];
            
            [cellMulArr addObject:cellModel];
        }
        
        _cellArr = cellMulArr;
    }
    return _cellArr;
}

- (XMGHTTPSessionManager *)manager
{
    if (!_manager) {
        
        _manager = [XMGHTTPSessionManager manager];
    }
    return _manager;
}


@end
