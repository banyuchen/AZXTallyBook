//
//  JDMyViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/8/22.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDMyViewController.h"
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


@interface JDMyViewController ()<UITableViewDataSource,UITableViewDelegate,JDMyheaderViewDelegate>

/**cellArr*/
@property (nonatomic, strong) NSArray<JDBorrowMyCellModel *> *cellArr;

/**tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** 任务管理者 */
@property (nonatomic, strong) XMGHTTPSessionManager *manager;

@end

@implementation JDMyViewController

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
        
        [self getUserByToken];
        
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
    
    
    //PVUV
//    NSString *userId = [XMToolClass isBlankString:[DBSave account].ID] ? @""   : [DBSave account].ID;
//    
//    [[JDStatisticsManager sharedInstance] addPVUVWithAppId:@"123" userId:userId appEntranceId:@"" position:@"4" token:@"" pattern:@"10" callSucceedBack:^(id  _Nullable responseObject) {
//        
//    } callFailBack:^(NSError * _Nonnull error) {
//        
//    }];
    
    
    //PVUV
    [[JDStatisticsManager sharedInstance] addloanShopPVUVWithAppId:ThirdAppId userId:[DBSave account].account position:@"4" token:@"" pattern:@"10" type:@"2" productId:@"0" callSucceedBack:^(id  _Nullable responseObject) {
        
    } callFailBack:^(NSError * _Nonnull error) {
        
    }];
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
            
            JDBrowsingHistoryViewController *vc = [[JDBrowsingHistoryViewController alloc] init];
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
        
        JDFAQViewController *vc = [[JDFAQViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (indexPath.row == 3){
        
        if ([XMToolClass isBlankString:[DBSave account].ID]) {
            
            JDLoginViewController *vc = [[JDLoginViewController alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            
            JDSettingViewController *vc = [[JDSettingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    
    if (indexPath.row == self.cellArr.count -1) {
        
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kWindowW);
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
     根据token获取用户信息
     */
    NSDictionary *parameters2 =
    @{
      @"userToken":[DBSave account].userToken,
      };
    
    NZLog(@"%@",[DBSave account].userToken);
    NSString *url2 = [[NSString stringWithFormat:@"%@/user/getUserByToken/%@",LOGINURL,[DBSave account].userToken] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __weak typeof(self) weakSelf = self;
    
    // 发送请求
    [self.manager GET:url2 parameters:parameters2 progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            DBAccount *account = [DBSave account];
            //            account.idfa = [[responseObject valueForKey:@"returnValue"] valueForKey:@"idfa"];
            //            account.appUid = [[responseObject valueForKey:@"returnValue"] valueForKey:@"appUid"];
            //            account.imei = [[responseObject valueForKey:@"returnValue"] valueForKey:@"imei"];
            account.ID = [[responseObject valueForKey:@"returnValue"] valueForKey:@"id"];
            account.nickname = [[responseObject valueForKey:@"returnValue"] valueForKey:@"nickname"];
            account.face = [[responseObject valueForKey:@"returnValue"] valueForKey:@"face"];
            [DBSave save:account];
            
            JDMyheaderView *headerView = [[JDMyheaderView alloc] init];
            headerView.delegate = weakSelf;
            headerView.account = [DBSave account];
            headerView.size = CGSizeMake(kWindowW, KActualH(346));
            headerView.backgroundColor = WhiteColor;
            
            weakSelf.tableView.tableHeaderView = headerView;
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"登录已失效，请重新登录"];
            [SVProgressHUD dismissWithDelay:0.5];
            
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
        
        NSArray *titleArr = @[@[@"mine_record",@"浏览记录",],
                              @[@"mine_collect",@"个人资料",],
                              @[@"mine_Q&A",@"常见问题",],
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
