//
//  JDBorrowViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/8/22.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDBorrowViewController.h"
#import "XMGHTTPSessionManager.h"
#import "JDHomeTableViewCell.h"
#import "JDProduct_M.h"

#import "JDProductDetailViewController.h"
#import "JDLoginViewController.h"
#import "JDStatisticsManager.h"


@interface JDBorrowViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger pageNum;
    NSString *_orderParam;//贷款结束额度end_loan_money(默认) 日利率interest_rate_day
    NSString *_orderType;//顺序
    NSString *_productType;
    
    
    BOOL _isLoad;//是否加载过
}

/**tableView*/
@property (nonatomic, strong) UITableView *tableView;
/**产品列表*/
@property (nonatomic, strong) NSMutableArray<JDProduct_M *> *productMulArr;
/** 任务管理者 */
@property (nonatomic, strong) XMGHTTPSessionManager *manager;

/**选择按钮背景*/
@property (nonatomic, strong) UIView *btnBGView;

/**贷款金额排序*/
@property (nonatomic, strong) CustomButton * loanAmountBtn;
/**贷款利率排序*/
@property (nonatomic, strong) CustomButton *loanInterestBtn;

@property (nonatomic, strong) JDIcon_M *icon;

/**当无数据的时候*/
@property (nonatomic, strong) UIView *nullView;
/**无数据&页面挂掉的提示文字*/
@property (nonatomic, strong) UILabel *nullLbl;


@end

@implementation JDBorrowViewController

  

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    
    self.productMulArr = [[NSMutableArray alloc] init];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _orderType = @"desc";
    _orderParam = @"end_loan_money";
    _productType = @"";
    
    [self loanAmountBtn];
    [self loanInterestBtn];
    
    self.tableView.tableFooterView = [UIView new];
    
    pageNum = 1;
    
    _isLoad = NO;
    
    [self collectViewPullUp];
    
    
    //接收通知
    [NZNotificationCenter addObserver:self selector:@selector(acceptObject:) name:@"didSelecIcon" object:nil];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (!_isLoad) {
        
        _isLoad = YES;
        
        [self loadBtnView];
    }
    
    
    //PVUV
    [[JDStatisticsManager sharedInstance] addloanShopPVUVWithAppId:ThirdAppId userId:[DBSave account].account position:@"2" token:@"" pattern:@"10" type:@"2" productId:@"0" callSucceedBack:^(id  _Nullable responseObject) {
        
    } callFailBack:^(NSError * _Nonnull error) {
        
    }];
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    _isLoad = NO;
}

- (void)acceptObject:(NSNotification *)notification
{
    self.icon = notification.object;
    
    self.navigationItem.title = self.icon.productTypeName;
    
    _productType = self.icon.productClassId;
    
    if (!_isLoad) {
        
        
        [self loadBtnView];
        _isLoad = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationItem.title = @"贷款列表";
    
    _productType = @"";
}


//每次进入默认金额排序
- (void)loadBtnView
{
    
    pageNum = 1;
    _orderParam = @"end_loan_money";
    self.loanInterestBtn.selected = NO;
    [self.loanInterestBtn setImage:[UIImage imageNamed:@"reorder3"] forState:UIControlStateNormal];
    [self.loanInterestBtn setTitleColor:BlackNameColor forState:UIControlStateNormal];
    
    [self.loanAmountBtn setTitleColor:RGBCOLOR(0, 103, 254) forState:UIControlStateNormal];
    [self.loanAmountBtn setImage:[UIImage imageNamed:@"reorder1"] forState:UIControlStateNormal];
    
    
    self.loanAmountBtn.tag = 111;
    self.loanAmountBtn.selected = YES;
    
    _orderType = @"desc";
    
    [self requestGetproduct];
}

#pragma mark - loanAmountBtnClick - 贷款金额排序
- (void)loanAmountBtnClick
{
    pageNum = 1;
    _orderParam = @"end_loan_money";
    self.loanInterestBtn.selected = NO;
    [self.loanInterestBtn setImage:[UIImage imageNamed:@"reorder3"] forState:UIControlStateNormal];
    [self.loanInterestBtn setTitleColor:BlackNameColor forState:UIControlStateNormal];
    
    [self.loanAmountBtn setTitleColor:RGBCOLOR(0, 103, 254) forState:UIControlStateNormal];
    [self.loanAmountBtn setImage:[UIImage imageNamed:@"reorder1"] forState:UIControlStateNormal];
    
    
    if (self.loanAmountBtn.tag == 1) {
        
        self.loanAmountBtn.tag = 111;
        self.loanAmountBtn.selected = YES;
        
        _orderType = @"desc";
    }else{
        
        self.loanAmountBtn.tag = 1;
        self.loanAmountBtn.selected = NO;
        _orderType = @"asc";
    }
    
    [self requestGetproduct];
}

#pragma mark - loanInterestBtnClick - 贷款利率排序
- (void)loanInterestBtnClick
{
    
    pageNum = 1;
    _orderParam = @"interest_rate_day";
    self.loanAmountBtn.selected = NO;
    [self.loanAmountBtn setTitleColor:BlackNameColor forState:UIControlStateNormal];
    [self.loanAmountBtn setImage:[UIImage imageNamed:@"reorder3"] forState:UIControlStateNormal];
    
    [self.loanInterestBtn setTitleColor:RGBCOLOR(0, 103, 254) forState:UIControlStateNormal];
    [self.loanInterestBtn setImage:[UIImage imageNamed:@"reorder1"] forState:UIControlStateNormal];
    
    
    if (self.loanInterestBtn.tag == 1) {
        
        self.loanInterestBtn.tag = 111;
        self.loanInterestBtn.selected = YES;
        _orderType = @"desc";
        
    }else{
        
        self.loanInterestBtn.tag = 1;
        self.loanInterestBtn.selected = NO;
        _orderType = @"asc";
    }
    
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
     首页产品列表
     */
    NSDictionary *parameters2 =
    @{
      @"isRecommend":@"",
      @"pageSize":NumPerPage,
      @"pageIndex":[NSString stringWithFormat:@"%ld",(long)pageNum],
      @"orderParam":_orderParam,
      @"advertiserType":@"1",
      @"orderType":_orderType,
      @"productType":_productType,
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
            
            
        }else{ 
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"errorDesc"]];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
        }
        weakSelf.nullView.hidden = self.productMulArr.count > 0 ? YES : NO;
        self.nullLbl.attributedText = [NSString attributedStringWithColorTitle:@"暂无数据" normalTitle:@"" frontTitle:@"" diffentColor:BlackGrayColor];
        
        [weakSelf.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        weakSelf.nullView.hidden = NO;
        self.nullLbl.attributedText = [NSString attributedStringWithColorTitle:@"页面好像挂了，" normalTitle:@"点击刷新" frontTitle:@"" diffentColor:BlackGrayColor];
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        [SVProgressHUD dismiss];
        APPDELEGATE.window.userInteractionEnabled = YES;
        [CommonMethod altermethord:TipFailure andmessagestr:TipFailureDetail andconcelstr:@"确定"];
        
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

#pragma mark - 懒加载
- (UIView *)btnBGView
{
    if (!_btnBGView) {
        
        _btnBGView = [UIView viewWithBackgroundColor:WhiteColor superView:self.view];
        
        [_btnBGView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(kNavigationH);
            make.height.mas_equalTo(40);
        }];
        
        UIView *line = [UIView viewWithBackgroundColor:[XMToolClass getColorWithHexString:@"e5e5e5"] superView:_btnBGView];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return _btnBGView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.separatorColor = ClearColor;
        
        _tableView.backgroundColor = TableColor;
        
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, kNavigationH, 0);
        
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(kNavigationH +40);
            make.left.right.bottom.mas_equalTo(0);
        }];
        
        
        
        UIView *lineView = [UIView viewWithBackgroundColor:[XMToolClass getColorWithHexString:@"e5e5e5"] superView:self.view];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1.5);
            make.top.mas_equalTo(_tableView.mas_bottom).mas_equalTo(-1.5);
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


- (CustomButton *)loanAmountBtn
{
    if (!_loanAmountBtn) {
        
        CGFloat buttonW = kWindowW*0.5;
        
        _loanAmountBtn = [CustomButton buttonWithRightImage:@"reorder3" title:@"贷款金额" font:kFont(16) titleColor:BlackNameColor bgColor:ClearColor target:self action:@selector(loanAmountBtnClick) buttonH:40 showView:self.btnBGView];
        
        _loanAmountBtn.tag = 1;
        
        [_loanAmountBtn setImage:[UIImage imageNamed:@"reorder2"] forState:UIControlStateSelected];
        
        [_loanAmountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(buttonW, 40));
        }];
    }
    
    return _loanAmountBtn;
}
- (CustomButton *)loanInterestBtn
{
    if (!_loanInterestBtn) {
        
        CGFloat buttonW = kWindowW*0.5;
        
        _loanInterestBtn = [CustomButton buttonWithRightImage:@"reorder3" title:@"贷款利率" font:kFont(16) titleColor:BlackNameColor bgColor:ClearColor target:self action:@selector(loanInterestBtnClick) buttonH:40 showView:self.btnBGView];
        
        _loanInterestBtn.tag = 1;
        
        [_loanInterestBtn setImage:[UIImage imageNamed:@"reorder2"] forState:UIControlStateSelected];
        
        [_loanInterestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(buttonW, 40));
        }];
    }
    
    return _loanInterestBtn;
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
