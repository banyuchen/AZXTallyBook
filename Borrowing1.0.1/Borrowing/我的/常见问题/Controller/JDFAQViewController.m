//
//  JDFAQViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/9/5.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDFAQViewController.h"
#import "JDFAQTableViewCell.h"

#import <WebKit/WebKit.h>
#import "JDWebviewProgressLine.h"

@interface JDFAQViewController ()<WKUIDelegate,WKNavigationDelegate>


@property (nonatomic, strong) WKWebView *webView;
//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;

@property (nonatomic,strong) JDWebviewProgressLine  *progressLine;

///**tableView*/
//@property (nonatomic, strong) UITableView *tableView;
///**数据源*/
//@property (nonatomic, strong) NSMutableArray<JDFAQHeaderViewModel *> *celMulArr;

@end

@implementation JDFAQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBCOLOR(244, 244, 248);
    self.navigationItem.title = @"常见问题";  
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    //初始化偏好设置属性：preferences
    config.preferences = [WKPreferences new];
    //The minimum font size in points default is 0;
    config.preferences.minimumFontSize = 10;
    //是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, kWindowW, kWindowH)];
    
    [self.view addSubview:webView];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    NSURL *url = [NSURL URLWithString:@"https://jiedai.bianxianmao.com/#/questionApp"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    self.webView = webView;
    
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
    
//    self.navigationItem.title = webView.title;
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






//#pragma mark - UITableViewDelegate,UITableViewDataSource
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    JDFAQHeaderViewModel *model = self.celMulArr[indexPath.section];
//    
//    model.isUnfold = !model.isUnfold;
//    
//    [self.celMulArr replaceObjectAtIndex:indexPath.section withObject:model];
//    
//    [self.tableView reloadData];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.celMulArr[section].isUnfold ? 2 : 1;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.celMulArr.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *storeCityID = @"JDFAQTableViewCell";
//    
//    JDFAQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCityID];
//    
//    if (cell == nil) {
//        cell = [[JDFAQTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
//    }
//    else
//    {
//        [cell removeFromSuperview];
//        
//        cell = [[JDFAQTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
//    }
//    
//    cell.layer.cornerRadius = 5;
//    
//    cell.layer.masksToBounds = YES;
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    if (indexPath.row == 0) {
//        
//        cell.headerModel = self.celMulArr[indexPath.section];
//    }else
//    {
//        cell.answerModel = self.celMulArr[indexPath.section];
//    }
//    
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewAutomaticDimension;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 6;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [UIView viewWithBackgroundColor:RGBCOLOR(244, 244, 248) superView:nil];
//}
//
//
//#pragma mark - 懒加载
//- (UITableView *)tableView
//{
//    if (!_tableView) {
//        
//        _tableView = [[UITableView alloc] init];
//        
//        _tableView.delegate = self;
//        
//        _tableView.dataSource = self;
//        
//        _tableView.tableFooterView = [UIView new];
//        
//        [self.view addSubview:_tableView];
//        
//        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//           
//            make.top.mas_equalTo(kNavigationH + 6);
//            make.left.mas_equalTo(6);
//            make.right.mas_equalTo(-6);
//            make.bottom.mas_equalTo(-6);
//        }];
//    }
//    return _tableView;
//}
//
//
//- (NSMutableArray<JDFAQHeaderViewModel *> *)celMulArr
//{
//    if (!_celMulArr) {
//        
//        _celMulArr = [[NSMutableArray alloc] init];
//        
//        JDFAQHeaderViewModel *model = [[JDFAQHeaderViewModel alloc] init];
//        model.part = @"Q1";
//        model.question = @"如何申请贷款？";
//        model.isUnfold = NO;
//        model.answerStr = @"您可以根据需求在相应版块选择贷款产品，我们建议您选择符合个人信息和需求的贷款产品，并根据此贷款产品的要求填写完资料并提交申请。";
//        [_celMulArr addObject:model];
//        
//        
//        JDFAQHeaderViewModel *model1 = [[JDFAQHeaderViewModel alloc] init];
//        model1.part = @"Q2";
//        model1.question = @"申请贷款后，审核需要多久？";
//        model1.isUnfold = NO;
//        model1.answerStr = @"一般需要1~3个工作日，最快1小时可以到账。用户的资料真实度、配合度也影响审核时长。请您按照消息提醒进行操作，保持电话畅通。";
//        [_celMulArr addObject:model1];
//        
//        JDFAQHeaderViewModel *model2 = [[JDFAQHeaderViewModel alloc] init];
//        model2.part = @"Q3";
//        model2.question = @"如何提高贷款成功率？";
//        model2.isUnfold = NO;
//        model2.answerStr = @"①真实选择符合个人信息和需求的贷款产品; \n②根据自己的实际情况去选择产品;\n③申请多个产品，可大幅度提高贷款成功率，您可以尝试同时多申请几个贷款产品。";
//        [_celMulArr addObject:model2];
//        
//        
//        JDFAQHeaderViewModel *model3 = [[JDFAQHeaderViewModel alloc] init];
//        model3.part = @"Q4";
//        model3.question = @"申请贷款的利率和额度是多少？";
//        model3.isUnfold = NO;
//        model3.answerStr = @"平台推荐的众多贷款产品，利率和额度各有不同：\n①一般参考月利率范围在1%~1.5%，建议在申请时查看详细介绍;\n②额度一般都在500元至50万元，您可以根据自身的资金需求自主申请; \n特别提醒您，信贷机构会根据您的个人资质给出最终的贷款额度和利率，请以放款前的确认信息为准。";
//        [_celMulArr addObject:model3];
//        
//        JDFAQHeaderViewModel *model4 = [[JDFAQHeaderViewModel alloc] init];
//        model4.part = @"Q5";
//        model4.question = @"贷款成功后如何还款？";
//        model4.isUnfold = NO;
//        model4.answerStr = @"平台推荐的众多贷款产品，利率和额度各有不同\n ①一般参考月利率范围在1%~1.5%，建议在申请时查看详细介绍;\n②额度一般都在500元至50万元，您可以根据自身的资金需求自主申请;\n特别提醒您，信贷机构会根据您的个人资质给出最终的贷款额度和利率，请以放款前的确认信息为准。";
//        [_celMulArr addObject:model4];
//        
//        JDFAQHeaderViewModel *model5 = [[JDFAQHeaderViewModel alloc] init];
//        model5.part = @"Q6";
//        model5.question = @"如何查看申请进度？";
//        model5.isUnfold = NO;
//        model5.answerStr = @"您可以登录该机构的官网，或者拨打该机构对应的客服电话进行查询，部分机构可能需要您下载APP进行查询。";
//        [_celMulArr addObject:model5];
//        
//        JDFAQHeaderViewModel *model6 = [[JDFAQHeaderViewModel alloc] init];
//        model6.part = @"Q7";
//        model6.question = @"为什么申请没有通过？";
//        model6.isUnfold = NO;
//        model6.answerStr = @"因为每家信贷机构的审批侧重点和风控政策都有所不相同，所以申请某家机构的产品未通过也不要气馁，我们建议您多申请几家不同的机构，会提高审批通过率哦。";
//        [_celMulArr addObject:model6];
//        
//        JDFAQHeaderViewModel *model7 = [[JDFAQHeaderViewModel alloc] init];
//        model7.part = @"Q8";
//        model7.question = @"如何绑定银行卡？";
//        model7.isUnfold = NO;
//        model7.answerStr = @"1、需您本人身份证办理的银行卡\n2、银行卡预留的手机号码和软件注册手机需号码一致\n特别提醒：每家机构所支持绑卡银行的范围都是不同，具体以实际绑卡页面为准，建议使用四大银行卡：中国银行、建设银行、工商银行、农业银行";
//        [_celMulArr addObject:model7];
//        
//        
//        JDFAQHeaderViewModel *model8 = [[JDFAQHeaderViewModel alloc] init];
//        model8.part = @"Q9";
//        model8.question = @"如何绑定银行卡？";
//        model8.isUnfold = NO;
//        model8.answerStr = @"1、查看手机内是否有拦截或屏蔽短信的功能软件，需将类似功能关闭\n2、验证码以短信形式发送，确保目前手机信号状态良好；\n3、个别地区的当地运营商对于一些特殊手机号码段不支持接收该类信息，详情请咨询号码运营商";
//        [_celMulArr addObject:model8];
//        
//        JDFAQHeaderViewModel *model9 = [[JDFAQHeaderViewModel alloc] init];
//        model9.part = @"Q10";
//        model9.question = @"如何更换手机号？";
//        model9.isUnfold = NO;
//        model9.answerStr = @"注册号码是唯一账号无法更换，建议您直接用新的手机注册即可，所有信息都可重复填写，没有影响";
//        [_celMulArr addObject:model9];
//        
//        
//        JDFAQHeaderViewModel *model10 = [[JDFAQHeaderViewModel alloc] init];
//        model10.part = @"Q11";
//        model10.question = @"是否可以注销账户？";
//        model10.isUnfold = NO;
//        model10.answerStr = @"目前我们暂时不提供“注销账户”的服务，如您暂时没有需求，建议您可以闲置或者不要做其他任何操作，平台和入驻机构都签有安全的内部保密协议，您所填写的个人信息将得到严密的隐私保护，请您放心";
//        [_celMulArr addObject:model10];
//        
//        
//        JDFAQHeaderViewModel *model11 = [[JDFAQHeaderViewModel alloc] init];
//        model11.part = @"Q12";
//        model11.question = @"平台填写个人信息是否会泄露？";
//        model11.isUnfold = NO;
//        model11.answerStr = @"我们作为第三方平台，会监管入驻机构做好信息安全工作，内部都签有保密协议，您填写的个人信息平台只用作借款审批的依据，有选择性的筛选提供，绝不会产生外泄的情况，请您放心！";
//        [_celMulArr addObject:model11];
//    }
//    return _celMulArr;
//}

@end
