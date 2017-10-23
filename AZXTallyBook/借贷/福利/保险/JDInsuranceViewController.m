//
//  JDInsuranceViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/8/28.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDInsuranceViewController.h"
#import "XMGHTTPSessionManager.h"
#import "JDProduct_M.h"
#import "JDHomeTableViewCell.h"

#import "JDProductDetailViewController.h"
#import "JDLoginViewController.h"
#import "JDStatisticsManager.h"

@interface JDInsuranceViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger pageNum;
}


/**tableView*/
@property (nonatomic, strong) UITableView *tableView;
/**产品列表*/
@property (nonatomic, strong) NSMutableArray<JDProduct_M *> *productMulArr;
/** 任务管理者 */
@property (nonatomic, strong) XMGHTTPSessionManager *manager;

/**当无数据的时候*/
@property (nonatomic, strong) UIView *nullView;
/**无数据&页面挂掉的提示文字*/
@property (nonatomic, strong) UILabel *nullLbl;

@end

@implementation JDInsuranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TableColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
     首页icon列表
     */
    NSDictionary *parameters2 =
    @{
      @"isRecommend":@"",
      @"pageSize":NumPerPage,
      @"pageIndex":[NSString stringWithFormat:@"%ld",pageNum],
      @"orderParam":@"",
      @"advertiserType":self.advertiserType,
      @"orderType":@"",
      };
    
    NSString *url2 = [[NSString stringWithFormat:@"%@/product/getproduct", LINEURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __weak typeof(self) weakSelf = self;
    
    // 发送请求
    [self.manager GET:url2 parameters:parameters2 progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            
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
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"errorDesc"]];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        weakSelf.nullView.hidden = NO;
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
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
            
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            
            
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
                
            } callFailBack:^(NSError * _Nonnull error) {
                
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
        
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        
        _tableView.delegate = self;
        
        _tableView.separatorColor = ClearColor;
        
        _tableView.backgroundColor = TableColor;
        
        [self.view addSubview:_tableView];
        
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

- (XMGHTTPSessionManager *)manager
{
    if (!_manager) {
        
        _manager = [XMGHTTPSessionManager manager];
    }
    return _manager;
}

@end
