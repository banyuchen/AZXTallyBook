//
//  JDBrowsingHistoryViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/9/6.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDBrowsingHistoryViewController.h"
#import "JDProductDetailViewController.h"

#import "JDHomeTableViewCell.h"
#import "JDStatisticsManager.h"

@interface JDBrowsingHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger pageNum;
}

/**<#name#>*/
@property (nonatomic, strong) NSMutableArray<JDProduct_M *> *productArr;

/**tableView*/
@property (nonatomic, strong) UITableView *tableView;

/**当无数据的时候*/
@property (nonatomic, strong) UIView *nullView;

/**无数据&页面挂掉的提示文字*/
@property (nonatomic, strong) UILabel *nullLbl;

@end

@implementation JDBrowsingHistoryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    
    self.navigationItem.title = @"浏览记录";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.tableView.tableFooterView = [UIView new];
    
    pageNum = 1;
    [self collectViewPullUp];
    [self requestGetproduct];
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

- (void)requestGetproduct
{
    /**
     首页列表
     */
    NSDictionary *parameters2 =
    @{
      @"userId":[DBSave account].ID,
      @"pageSize":NumPerPage,
      @"pageIndex":[NSString stringWithFormat:@"%ld",pageNum],
      };
    
    __weak typeof(self) weakSelf = self;
    
    NSString *url2 = [[NSString stringWithFormat:@"%@/browselog/getProductBrowseLog", LINEURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    AFHTTPSessionManager *manager = [XMToolClass httpRequestInit];
    
    // 发送请求
    [manager GET:url2 parameters:parameters2 progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        
        
        NSArray <JDProduct_M *>*array = [JDProduct_M mj_objectArrayWithKeyValuesArray:[[responseObject valueForKey:@"returnValue"] valueForKey:@"list"]];
        
        weakSelf.tableView.mj_footer.hidden = array.count == [NumPerPage integerValue] ? NO : YES;
        
        if (pageNum == 1) {
            
            [weakSelf.productArr removeAllObjects];
            
            weakSelf.productArr = [NSMutableArray arrayWithArray:array];
        }else{
            
            [weakSelf.productArr addObjectsFromArray:array];
        }
        
        weakSelf.nullView.hidden = self.productArr.count > 0 ? YES : NO;
        self.nullLbl.attributedText = [NSString attributedStringWithColorTitle:@"暂无数据" normalTitle:@"" frontTitle:@"" diffentColor:BlackGrayColor];
        
        [weakSelf.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        weakSelf.nullView.hidden = NO;
        self.nullLbl.attributedText = [NSString attributedStringWithColorTitle:@"页面好像挂了，" normalTitle:@"点击刷新" frontTitle:@"" diffentColor:BlackGrayColor];
        
    }];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.productArr[indexPath.row].advertiserType isEqualToString:@"1"]) {
        
        JDProductDetailViewController *vc = [[JDProductDetailViewController alloc] init];
        vc.productM = self.productArr[indexPath.row];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        
        self.view.userInteractionEnabled = NO;
        //礼券点击
        NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
        NSString *uid = [NSString stringWithFormat:@"dkch%@",[DBSave account].ID];
        
        uid = [XMToolClass md5:uid];
        
        [[JDStatisticsManager sharedInstance] getCountInfoWithPreid:self.productArr[indexPath.row].advertiserVoucherIdIos awardtype:@"2" activityid:@"0" appos:@"2" appkey:ThirdAppkey business:@"dkcs" i:@"" f:adId ua:@"0" uid:uid modelname:@"礼券点击" modeltype:@"7" callSucceedBack:^(id  _Nullable responseObject) {
            
            JDProductDetail1ViewController *vc = [[JDProductDetail1ViewController alloc] init];
            vc.productIosUrl = self.productArr[indexPath.row].productIosUrl;
            vc.productID = self.productArr[indexPath.row].ID;
            vc.isApplyNow = @"NO";
            [self.navigationController pushViewController:vc animated:YES];
            
            self.view.userInteractionEnabled = YES;
        } callFailBack:^(NSError * _Nonnull error) {
            
            self.view.userInteractionEnabled = YES;
        }];
        
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.productArr[indexPath.row].advertiserType isEqualToString:@"1"]) {
        
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
        
        cell.productDic = self.productArr[indexPath.row];
        
        
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
        
        cell.productDic = self.productArr[indexPath.row];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
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
        
//        _tableView.contentInset = UIEdgeInsetsMake(0, 0, kNavigationH, 0);
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(kNavigationH);
            make.left.right.bottom.mas_equalTo(0);
        }];
    }
    return _tableView;
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
