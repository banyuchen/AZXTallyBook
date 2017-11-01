//
//  JDHomeViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/8/22.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDHomeViewController.h"
#import "XMGHTTPSessionManager.h"
#import "JDHomeTableViewCell.h"
#import "JDHomeHeaderView.h"
#import "JDBorrowViewController.h"
#import "JDProductDetailViewController.h"
#import "JDLoginViewController.h"//登录

#import "JDHomeRequestManager.h"

#import "JDProduct_M.h"
#import "JDBanner_M.h"
#import "JDIcon_M.h"

#import "JDStatisticsManager.h"
#import "JDInsuranceViewController.h"

@interface JDHomeViewController ()<UITableViewDelegate,UITableViewDataSource,JDHomeHeaderViewDelegate>
{
    NSInteger pageNum;
}

/**tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** 任务管理者 */
@property (nonatomic, strong) XMGHTTPSessionManager *manager;

/**banner数组*/
@property (nonatomic, strong) NSArray<JDBanner_M *> *bannerArr;
/**icon数组*/
@property (nonatomic, strong) NSArray<JDIcon_M *> *iconArr;
/**产品列表*/
@property (nonatomic, strong) NSMutableArray<JDProduct_M *> *productMulArr;

/**banner数组*/
@property (nonatomic, strong) NSArray *imageArr;

/**tableHeaderView*/
@property (nonatomic, strong) JDHomeHeaderView *headerView;

/**当无数据的时候*/
@property (nonatomic, strong) UIView *nullView;

/**无数据&页面挂掉的提示文字*/
@property (nonatomic, strong) UILabel *nullLbl;

@end

@implementation JDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    
    self.navigationItem.title = @"借钱猫";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self collectViewPullUp];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    pageNum = 1;
    
    [self requestGetproduct];
    
    [self requestHeaderData];
    
    //PVUV
    [[JDStatisticsManager sharedInstance] addloanShopPVUVWithAppId:ThirdAppId userId:[DBSave account].ID position:@"1" token:@"" pattern:@"10" type:@"2" productId:@"0" callSucceedBack:^(id  _Nullable responseObject) {
        
    } callFailBack:^(NSError * _Nonnull error) {
        
    }];
    
    
    
    [[JDStatisticsManager sharedInstance] addPVUVWithAppId:ThirdAppId userId:[DBSave account].ID appEntranceId:@"" position:@"1" token:@"" pattern:@"10" callSucceedBack:^(id  _Nullable responseObject) {
        
    } callFailBack:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark - 首页icon点击事件
- (void)homeHeaderViewDidSelectIcon:(JDIcon_M *)icon
{
    
    
    [[JDStatisticsManager sharedInstance] addloanShopPVUVWithAppId:ThirdAppId userId:[DBSave account].ID position:@"12" token:@"" pattern:@"10" type:@"2" productId:@"0" callSucceedBack:^(id  _Nullable responseObject) {
        
    } callFailBack:^(NSError * _Nonnull error) {
        
    }];
    
    [[JDStatisticsManager sharedInstance] addloanShopPVUVWithAppId:ThirdAppId userId:[DBSave account].ID position:@"12" token:@"" pattern:@"10" type:@"2" productId:icon.ID callSucceedBack:^(id  _Nullable responseObject) {
        
    } callFailBack:^(NSError * _Nonnull error) {
        
    }];
    
    if ([icon.type isEqualToString:@"1"]) {
        
        //发出通知
        [NZNotificationCenter postNotificationName:@"didSelecIcon" object:icon];
        
        self.navigationController.tabBarController.selectedIndex = 1;
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        if ([icon.productTypeName isEqualToString:@"信用卡"]) {
            
            
            JDInsuranceViewController *vc = [[JDInsuranceViewController alloc] init];
            vc.advertiserType = @"2";
            vc.navigationItem.title = @"信用卡专区";
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else{
            
            
            //跳转到广告落地页
            if ([XMToolClass isBlankString:[DBSave account].ID]) {
                
                JDLoginViewController *vc = [[JDLoginViewController alloc] init];
                
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                
                JDProductDetail1ViewController *vc = [[JDProductDetail1ViewController alloc] init];
                vc.productIosUrl = icon.appLinkUrl;
                vc.productID = icon.ID;
                vc.isApplyNow = @"NO";
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }
        }
        
    }
    
}



#pragma mark ----首页轮播图点击事件
- (void)homeHeaderViewDidSelctCycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    JDBanner_M *banner = [[JDBanner_M alloc] init];
    banner = self.bannerArr[index];
    
    self.view.userInteractionEnabled = NO;
    
    [[JDStatisticsManager sharedInstance] addloanShopPVUVWithAppId:ThirdAppId userId:[DBSave account].ID position:@"11" token:@"" pattern:@"10" type:@"2" productId:banner.ID callSucceedBack:^(id  _Nullable responseObject) {
        
    } callFailBack:^(NSError * _Nonnull error) {
        
    }];
    
    [[JDStatisticsManager sharedInstance] addloanShopPVUVWithAppId:ThirdAppId userId:[DBSave account].ID position:@"11" token:@"" pattern:@"10" type:@"2" productId:@"0" callSucceedBack:^(id  _Nullable responseObject) {
        
    } callFailBack:^(NSError * _Nonnull error) {
        
    }];
    
    
    if ([banner.bannerType isEqualToString:@"1"]) {
        //商品
        
        [[JDHomeRequestManager sharedInstance] getproductWithIsRecommend:@"" pageSize:@"" pageIndex:@"" orderParam:@"" advertiserType:@"" orderType:@"" ID:banner.productId callSucceedBack:^(id  _Nullable responseObject) {
            
            NSArray *arr = [[responseObject valueForKey:@"returnValue"] valueForKey:@"list"];
            
            if ( arr.count> 0) {
                
                JDProduct_M *product = [JDProduct_M mj_objectWithKeyValues:[[responseObject valueForKey:@"returnValue"] valueForKey:@"list"][0]];
                
                
                self.view.userInteractionEnabled = YES;
                
                JDProductDetailViewController *vc = [[JDProductDetailViewController alloc] init];
                vc.productM = product;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            
            
        } callFailBack:^(NSError * _Nonnull error) {
            
            self.view.userInteractionEnabled = YES;
        }];
        
    }else
    {//链接
        
        //跳转到广告落地页
        if ([XMToolClass isBlankString:[DBSave account].ID]) {
            
            JDLoginViewController *vc = [[JDLoginViewController alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            
            JDProductDetail1ViewController *vc = [[JDProductDetail1ViewController alloc] init];
            vc.productIosUrl = banner.linkeUrl;
            vc.productID = banner.productId;
            vc.isApplyNow = @"NO";
            [self.navigationController pushViewController:vc animated:YES];
            
            self.view.userInteractionEnabled = YES;
        }
    }
}



#pragma mark - 请求数据
- (void)collectViewPullUp
{
    self.tableView.mj_header = [HHRefreshHeader headerWithRefreshingBlock:^{
        
        pageNum = 1;
        
        [self requestGetproduct];
    }];
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [HHRefreshFooter footerWithRefreshingBlock:^{
        
        pageNum++;
        
        [self requestGetproduct];
    }];
    
    self.tableView.mj_footer.hidden = YES;
}

- (void)requestHeaderData
{
    
    dispatch_group_t group = dispatch_group_create();
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_group_async(group, dispatch_queue_create("banner.home", DISPATCH_QUEUE_CONCURRENT), ^{
        
        // 创建一个信号量为0的信号(红灯)
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        /**
         首页banner接口(轮播图)
         */
        [[JDHomeRequestManager sharedInstance] getBannerWithPosition:@"1" callSucceedBack:^(id  _Nullable responseObject) {
            
            weakSelf.bannerArr = [JDBanner_M mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"returnValue"]];
            
            weakSelf.imageArr = [[responseObject valueForKey:@"returnValue"] valueForKey:@"images"];
            
            // 使信号的信号量+1，这里的信号量本来为0，+1信号量为1(绿灯)
            dispatch_semaphore_signal(sema);
            
        } callFailBack:^(NSError * _Nonnull error) {
            
        }];
        
        
        // 开启信号等待，设置等待时间为永久，直到信号的信号量大于等于1（绿灯）
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_queue_create("com.dispatch.test", DISPATCH_QUEUE_CONCURRENT), ^{
        
        
        // 创建一个信号量为0的信号(红灯)
        dispatch_semaphore_t sema1 = dispatch_semaphore_create(0);
        
        /**
         首页icon列表
         */
        [[JDHomeRequestManager sharedInstance] getIconCallSucceedBack:^(id  _Nullable responseObject) {
            
            weakSelf.iconArr = [JDIcon_M mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"returnValue"]];
            
            
            // 使信号的信号量+1，这里的信号量本来为0，+1信号量为1(绿灯)
            dispatch_semaphore_signal(sema1);
            
        } callFailBack:^(NSError * _Nonnull error) {
            
        }];
        
        // 开启信号等待，设置等待时间为永久，直到信号的信号量大于等于1（绿灯）
        dispatch_semaphore_wait(sema1, DISPATCH_TIME_FOREVER);
    });
    
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        //刷新页面
        NSInteger count = ceil(weakSelf.iconArr.count/4.0);
        
        JDHomeHeaderView *headerView = [[JDHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, KActualH(200) + 85*count)];
        
        headerView.delegate = weakSelf;
        
        weakSelf.headerView= headerView;
        
        
        weakSelf.headerView.backgroundColor = WhiteColor;
        
        weakSelf.tableView.tableHeaderView = headerView;
        
        weakSelf.headerView.iconArr = weakSelf.iconArr;
        
        weakSelf.headerView.bannerArr = weakSelf.imageArr;
        
        [weakSelf.tableView reloadData];
        
    });
    
}



- (void)requestGetproduct
{
    /**
     首页列表
     */
    __weak typeof(self) weakSelf = self;
    
    [[JDHomeRequestManager sharedInstance] getproductWithIsRecommend:@"y" pageSize:NumPerPage pageIndex:[NSString stringWithFormat:@"%ld",(long)pageNum] orderParam:@"" advertiserType:@"" orderType:@"" ID:@"" callSucceedBack:^(id  _Nullable responseObject) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        
        
        NSArray <JDProduct_M *>*array = [JDProduct_M mj_objectArrayWithKeyValuesArray:[[responseObject valueForKey:@"returnValue"] valueForKey:@"list"]];
        
        weakSelf.tableView.mj_footer.hidden = array.count == [NumPerPage integerValue] ? NO : YES;
        
        if (pageNum == 1) {
            
            [weakSelf.productMulArr removeAllObjects];
            
            weakSelf.productMulArr = [NSMutableArray arrayWithArray:array];
        }else{
            
            [weakSelf.productMulArr addObjectsFromArray:array];
        }
        
        weakSelf.nullView.hidden = self.productMulArr.count > 0 ? YES : NO;
        
        self.nullLbl.attributedText = [NSString attributedStringWithColorTitle:@"暂无数据" normalTitle:@"" frontTitle:@"" diffentColor:BlackGrayColor];
        
        [weakSelf.tableView reloadData];
        
    } callFailBack:^(NSError * _Nonnull error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        weakSelf.nullView.hidden = NO;
        self.nullLbl.attributedText = [NSString attributedStringWithColorTitle:@"页面好像挂了，" normalTitle:@"点击刷新" frontTitle:@"" diffentColor:BlackGrayColor];
        
    }];
    
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.productMulArr[indexPath.row].advertiserType isEqualToString:@"1"]) {
        
        JDProductDetailViewController *vc = [[JDProductDetailViewController alloc] init];
        vc.productM = self.productMulArr[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        //跳转到广告落地页
        if ([XMToolClass isBlankString:[DBSave account].ID]) {
            
            JDLoginViewController *vc = [[JDLoginViewController alloc] init];
            vc.isLogin = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            
            self.view.userInteractionEnabled = NO;
            
            //礼券点击
            NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            
            NSString *uid = [NSString stringWithFormat:@"dkch%@",[DBSave account].ID];
            
            uid = [XMToolClass md5:uid];
            
            [[JDStatisticsManager sharedInstance] getCountInfoWithPreid:self.productMulArr[indexPath.row].advertiserVoucherIdIos awardtype:@"2" activityid:@"0" appos:@"2" appkey:ThirdAppkey business:@"dkcs" i:@"" f:adId ua:@"0" uid:uid modelname:@"礼券点击" modeltype:@"7" callSucceedBack:^(id  _Nullable responseObject) {
                
                
                
                JDProductDetail1ViewController *vc = [[JDProductDetail1ViewController alloc] init];
                vc.productIosUrl = self.productMulArr[indexPath.row].productIosUrl;
                vc.productID = self.productMulArr[indexPath.row].ID;
                vc.isApplyNow = @"NO";
                [self.navigationController pushViewController:vc animated:YES];
                
                self.view.userInteractionEnabled = YES;
                
            } callFailBack:^(NSError * _Nonnull error) {
                
                self.view.userInteractionEnabled = YES;
            }];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productMulArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.productMulArr[indexPath.row].advertiserType isEqualToString:@"1"]) {
        
        static NSString *storeCityID = @"JDHomeBrowingTableViewCell";
        
        JDHomeBrowingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCityID];
        
        if (cell == nil) {
            cell = [[JDHomeBrowingTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
        }
        else
        {
            [cell removeFromSuperview];
            
            cell = [[JDHomeBrowingTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = TableColor;
        
        cell.productDic = self.productMulArr[indexPath.row];
        
        
        return cell;
    }else{
        static NSString *storeCityID = @"JDHomeTableViewCell";
        
        JDHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCityID];
        
        if (cell == nil) {
            cell = [[JDHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
        }
        else
        {
            [cell removeFromSuperview];
            
            cell = [[JDHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = TableColor;
        
        cell.productDic = self.productMulArr[indexPath.row];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView viewWithBackgroundColor:TableColor superView:nil];
    
    UILabel *title = [UILabel labelWithText:@"热门推荐" font:kFont(16) textColor:BlackContentColor backGroundColor:ClearColor superView:view];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(4);
    }];
    
    
    UIView *line1 = [UIView viewWithBackgroundColor:[XMToolClass getColorWithHexString:@"999999"] superView:view];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(title.mas_left).mas_equalTo(-8);
        make.centerY.mas_equalTo(title.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(33, 0.5));
    }];
    
    
    UIView *line2 = [UIView viewWithBackgroundColor:[XMToolClass getColorWithHexString:@"999999"] superView:view];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(title.mas_right).mas_equalTo(8);
        make.centerY.mas_equalTo(title.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(33, 0.5));
    }];
    
    
    return view;
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.separatorColor = ClearColor;
        
        _tableView.backgroundColor = TableColor;
        
        [self.view addSubview:_tableView];
        
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, kNavigationH, 0);
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(kNavigationH);
            make.left.right.bottom.mas_equalTo(0);
        }];
    }
    return _tableView;
}

- (XMGHTTPSessionManager *)manager
{
    if (!_manager) {
        
        _manager = [XMGHTTPSessionManager manager];
    }
    return _manager;
}

- (UIView *)nullView
{
    if (!_nullView) {
        
        _nullView = [UIView viewWithBackgroundColor:RGBCOLOR(244, 244, 244) superView:self.view];
        
        [_nullView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(kNavigationH);
            make.left.right.bottom.mas_equalTo(0);
        }];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.image = [UIImage imageNamed:@"empty"];
        
        [_nullView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(KActualH(-80));
        }];
        
        UILabel *lable = [UILabel labelWithText:@"" font:kFont(16) textColor:RGBCOLOR(0, 137, 229) backGroundColor:ClearColor superView:_nullView];
        
        lable.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
        
        [lable addGestureRecognizer:labelTapGestureRecognizer];
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(imageView.mas_bottom).mas_equalTo(5);
        }];
        _nullView.hidden = YES;
        
        
        self.nullLbl = lable;
    }
    return _nullView;
}

-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    UILabel *label=(UILabel*)recognizer.view;
    
    
    pageNum = 1;
    
    [self requestGetproduct];
    
    [self collectViewPullUp];
    
    
}
@end
