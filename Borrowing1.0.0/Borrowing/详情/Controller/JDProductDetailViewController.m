//
//  JDProductDetailViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/9/4.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDProductDetailViewController.h"
#import "JDProductDetailHeaderView.h"
#import "HHWZWebView.h"
#import "JDLoginViewController.h"//登录

#import "JDStatisticsManager.h"


#import "JDWebviewProgressLine.h"



#pragma mark ****************************************************************************贷款***************************************************************************************
@interface JDProductDetailViewController ()<UITableViewDelegate,UITableViewDataSource,HHWZWebViewDelegate>

/**tableView*/
@property (nonatomic, strong) UITableView *tableView;

/**立即申请*/
@property (nonatomic, strong) UIView *immediatelyView;

@end

@implementation JDProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"贷款详情";
    
    self.view.backgroundColor = WhiteColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    HHWZWebView *webView = [[HHWZWebView alloc] init];
    webView.wzDelegate = self;
    webView.size = CGSizeMake(kWindowW, 1000);
    [webView webViewWithHtmlString:self.productM.productIntroduce superController:self];
    
    self.tableView.tableFooterView = webView;
    
    [self immediatelyView];
    
    
    
//    NSString *userId = [XMToolClass isBlankString:[DBSave account].ID] ? @""   : [DBSave account].ID;
//    //详情页PVUV
//    [[JDStatisticsManager sharedInstance] addPVUVWithAppId:@"123" userId:userId appEntranceId:@"" position:@"5" token:@"" pattern:@"10" callSucceedBack:^(id  _Nullable responseObject) {
//        
//        
//    } callFailBack:^(NSError * _Nonnull error) {
//        
//    }];
    
    
    
//    //统计各个商品的PVUV
//    [[JDStatisticsManager sharedInstance] addPVUVWithAppId:@"123" userId:userId appEntranceId:@"" position:[NSString stringWithFormat:@"12345%@",self.productM.ID] token:@"" pattern:@"10" callSucceedBack:^(id  _Nullable responseObject) {
//        
//    } callFailBack:^(NSError * _Nonnull error) {
//        
//    }];
    
    
//
//    [[JDBrowsingHistoryDataStorage sharedInstance] dataBrowsingHistoryStorageWithProductM:self.productM];
    
}
#pragma mark - 立即申请
- (void)immediatelyBtnClick
{
    NZLog(@"立即申请");
    
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
        
        [[JDStatisticsManager sharedInstance] getCountInfoWithPreid:self.productM.advertiserVoucherIdIos awardtype:@"2" activityid:@"0" appos:@"2" appkey:ThirdAppkey business:@"dkcs" i:@"" f:adId ua:@"0" uid:uid modelname:@"礼券点击" modeltype:@"7" callSucceedBack:^(id  _Nullable responseObject) {
            
            NSString *url = @"";
            if ([self.productM.productIosUrl containsString:@"?"]) {
                
                url = [NSString stringWithFormat:@"%@&bxm_id=%@",self.productM.productIosUrl,[responseObject valueForKey:@"data"]];
            }else{
                
                url = [NSString stringWithFormat:@"%@?bxm_id=%@",self.productM.productIosUrl,[responseObject valueForKey:@"data"]];
            }
            
            JDProductDetail1ViewController *vc = [[JDProductDetail1ViewController alloc] init];
            vc.productIosUrl = url;
            vc.productID = self.productM.ID;
            vc.isApplyNow = @"YES";
            [self.navigationController pushViewController:vc animated:YES];
            
        } callFailBack:^(NSError * _Nonnull error) {
            
        }];
        
        
        //PVUV
        [[JDStatisticsManager sharedInstance] addloanShopPVUVWithAppId:ThirdAppId userId:[DBSave account].account position:@"6" token:@"" pattern:@"10" type:@"2" productId:@"0" callSucceedBack:^(id  _Nullable responseObject) {
            
        } callFailBack:^(NSError * _Nonnull error) {
            
        }];
        
        
    }
}



#pragma mark -
- (void)wzWebViewDidFinishLoad:(UIWebView *)webView
{
    self.tableView.tableFooterView.height = webView.scrollView.contentSize.height;
    [self.tableView reloadData];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
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
    static NSString *storeCityID = @"JDProductDetailHeaderView";
    
    JDProductDetailHeaderView *cell = [tableView dequeueReusableCellWithIdentifier:storeCityID];
    
    if (cell == nil) {
        cell = [[JDProductDetailHeaderView alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
    }
    else
    {
        [cell removeFromSuperview];
        
        cell = [[JDProductDetailHeaderView alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.product = self.productM;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.separatorColor = ClearColor;
        
        _tableView.backgroundColor = WhiteColor;
        
        _tableView.tableFooterView = [UIView new];
        
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(kNavigationH);
            make.left.right.mas_equalTo(0);
            
            make.bottom.mas_equalTo(-49);
        }];
    }
    return _tableView;
}

- (UIView *)immediatelyView
{
    if (!_immediatelyView) {
        
        _immediatelyView = [UIView viewWithBackgroundColor:WhiteColor superView:self.view];
        
        [_immediatelyView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.bottom.mas_equalTo(0);
            make.width.mas_equalTo(kWindowW);
            make.top.mas_equalTo(self.tableView.mas_bottom);
        }];
        
        UIView *line = [UIView viewWithBackgroundColor:SeparatorCOLOR superView:_immediatelyView];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.right.left.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        UIButton *immediatelyBtn = [UIButton buttonWithTitle:@"立即申请" font:kFont(18) titleColor:WhiteColor backGroundColor:ClearColor buttonTag:0 target:self action:@selector(immediatelyBtnClick) showView:_immediatelyView];
        
        [immediatelyBtn setBackgroundImage:[UIImage imageNamed:@"butt_blue"] forState:UIControlStateNormal];
        
        immediatelyBtn.layer.cornerRadius = 5;
        
        immediatelyBtn.layer.masksToBounds = YES;
        
        [immediatelyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(4);
            make.bottom.mas_equalTo(-4);
            
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            
        }];
    }
    return _immediatelyView;
}
@end



#pragma mark ****************************************************************************保险&&信用卡***************************************************************************************

#import <WebKit/WebKit.h>

@interface JDProductDetail1ViewController ()<WKUIDelegate,WKNavigationDelegate>


@property (nonatomic, strong) WKWebView *webView;
//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;

@property (nonatomic,strong) JDWebviewProgressLine  *progressLine;

@end

@implementation JDProductDetail1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    //初始化偏好设置属性：preferences
    config.preferences = [WKPreferences new];
    //The minimum font size in points default is 0;
    config.preferences.minimumFontSize = 10;
    //是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.frame];
    
    [self.view addSubview:webView];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    self.productIosUrl = [self.productIosUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *url = [NSURL URLWithString:self.productIosUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    self.webView = webView;
    
    //添加浏览记录
    [[JDStatisticsManager sharedInstance] addBrowseLogWithUseId:[DBSave account].ID productId:self.productID callSucceedBack:^(id  _Nullable responseObject) {
        
        
    } callFailBack:^(NSError * _Nonnull error) {
        
    }];
    
    //PVUV
    [[JDStatisticsManager sharedInstance] addloanShopPVUVWithAppId:ThirdAppId userId:[DBSave account].account position:@"7" token:@"" pattern:@"10" type:@"2" productId:self.productID callSucceedBack:^(id  _Nullable responseObject) {
        
    } callFailBack:^(NSError * _Nonnull error) {
        
    }];
    
    
    
    [self addLeftButton];
    
//    同时设置返回按钮和关闭按钮为导航栏左边的按钮
    self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    
    
    self.progressLine = [[JDWebviewProgressLine alloc] initWithFrame:CGRectMake(0, 64, kWindowW, 3)];
    self.progressLine.lineColor = RGBCOLOR(31, 144, 230);
    [self.view addSubview:self.progressLine];
}


#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    [self.progressLine startLoadingAnimation];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    self.navigationItem.title = webView.title;
    [self.progressLine endLoadingAnimation];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [self.progressLine endLoadingAnimation];
}


#pragma mark - 添加关闭按钮
- (void)addLeftButton
{

    self.navigationItem.leftBarButtonItem = self.backItem;
}


//点击返回的方法
- (void)backNative
{
    
    //判断是否有上一层H5页面
    if ([self.webView canGoBack]) {
        //如果有则返回
        [self.webView goBack];
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    } else {
        
        [self closeNative];
    }
}

//关闭H5页面，直接回到原生页面
- (void)closeNative
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - init

- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //这是一张“<”的图片，可以让美工给切一张
        UIImage *image = [UIImage imageNamed:@"back"];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backNative) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn setTitleColor:RGBCOLOR(31, 144, 230) forState:UIControlStateNormal];
        //字体的多少为btn的大小
        [btn sizeToFit];
        //左对齐
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //让返回按钮内容继续向左边偏移15，如果不设置的话，就会发现返回按钮离屏幕的左边的距离有点儿大，不美观
        //        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        btn.frame = CGRectMake(0, 0, 40, 40);
        _backItem.customView = btn;
        
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem
{
    if (!_closeItem) {
        
        UILabel *lable = [UILabel labelWithText:@"关闭" font:kFont(15) textColor:BlackColor backGroundColor:ClearColor superView:nil];
        
        lable.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeNative)];
        
        [lable addGestureRecognizer:labelTapGestureRecognizer];
        
        lable.size = CGSizeMake(31, 13);
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:lable];
        
        
        _closeItem = item;
    }
    return _closeItem;
}


@end





//#pragma mark ---- 懒加载
//- (UIWebView *)webView
//{
//    if (!_webView) {
//
//        _webView = [[ alloc]initWithFrame:self.view.bounds];
//
//        [self.view addSubview:_webView];
//
//        _webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
//
//        _webView.scrollView.bounces = NO;
//
//        UIScrollView *tempView = (UIScrollView *)[self.webView.subviews objectAtIndex:0];
//
//        tempView.scrollEnabled = YES;
//
//        NSURL *url = [NSURL URLWithString:self.productIosUrl];//创建URL
//
//        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建
//
//        [_webView loadRequest:request];//加载
//
//
//    }
//    return _webView;
//}

//-(void)webViewDidStartLoad:(UIWebView *)webView{
//    [self.progressLine startLoadingAnimation];
//}
//
//
//-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    [self.progressLine endLoadingAnimation];
//}
//
////设置webview的title为导航栏的title
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//
//    [self.progressLine endLoadingAnimation];
//
//}


//    self.webView.height = webView.scrollView.contentSize.height;
//
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
//        if (!isRun && [self.isApplyNow isEqualToString:@"NO"]) {
//
//            isRun = YES;
//            NSString *js = @"document.documentElement.innerHTML";
//            NSString *Html1 = [webView stringByEvaluatingJavaScriptFromString:js];
//
//            //获取temp文件的路径
//            NSString *tempPath = [[NSBundle mainBundle]pathForResource:@"temp" ofType:@"html"];
//
//            //加载temp内容为字符串
//            NSString *tempHtml = [NSString stringWithContentsOfFile:tempPath encoding:NSUTF8StringEncoding error:nil];
//
//            //替换temp内的占位符{{Content_holder}}为需要加载的HTML代码
//            tempHtml = [tempHtml stringByReplacingOccurrencesOfString:@"{{Content_holder}}" withString:Html1];
//
//            //Temp目录下的js文件在根路径，因此需要在加载HTMLString时指定根路径
//            NSString *basePath = [[NSBundle mainBundle] bundlePath];
//
//            NSURL *baseURL = [NSURL fileURLWithPath:basePath];
//
//            [self.webView loadHTMLString:tempHtml baseURL:baseURL];
//
//
//            [self.webView setScalesPageToFit:YES];
//
//            self.webView.scrollView.bounces = NO;
//
//            UIScrollView *tempView = (UIScrollView *)[self.webView.subviews objectAtIndex:0];
//
//            tempView.scrollEnabled = YES;
//        }
//    });
