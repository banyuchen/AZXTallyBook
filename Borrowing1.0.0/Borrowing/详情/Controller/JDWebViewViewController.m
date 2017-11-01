//
//  JDWebViewViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/9/26.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDWebViewViewController.h"
@interface NSURLRequest (InvalidSSLCertificate)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;

@end

@interface JDWebViewViewController ()
{
    BOOL isRun;
}

@property (nonatomic, strong) NSURLRequest *request;
//判断是否是HTTPS的
@property (nonatomic, assign) BOOL isAuthed;

//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;

@end

@implementation JDWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isRun = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    
    [self.view addSubview:self.webView];

    [self addLeftButton];
    
    //同时设置返回按钮和关闭按钮为导航栏左边的按钮
    self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    
}
//加载URL
- (void)loadHTML:(NSString *)htmlString
{
    NSURL *url = [NSURL URLWithString:htmlString];
    htmlString = [NSString stringWithFormat:@"%@&1931143435",htmlString];
    
    self.request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
    
    [self.webView loadRequest:self.request];
    
//    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建
//    
//    [self.webView loadRequest:request];//加载
}

#pragma mark - UIWebViewDelegate

//开始加载
- (BOOL)webView:(UIWebView *)awebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString* scheme = [[request URL] scheme];
    
    //判断是不是https
    if ([scheme isEqualToString:@"https"]) {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (!self.isAuthed) {
            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
            [awebView stopLoading];
            return NO;
        }
    }
    return YES;
}



//设置webview的title为导航栏的title
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
//    
//    if (!isRun) {
//        
//        isRun = YES;
//        NSString *js = @"document.documentElement.innerHTML";
//        NSString *Html1 = [webView stringByEvaluatingJavaScriptFromString:js];
//        
//        //获取temp文件的路径
//        NSString *tempPath = [[NSBundle mainBundle]pathForResource:@"temp" ofType:@"html"];
//        
//        //加载temp内容为字符串
//        NSString *tempHtml = [NSString stringWithContentsOfFile:tempPath encoding:NSUTF8StringEncoding error:nil];
//        
//        //替换temp内的占位符{{Content_holder}}为需要加载的HTML代码
//        tempHtml = [tempHtml stringByReplacingOccurrencesOfString:@"{{Content_holder}}" withString:Html1];
//        
//        //Temp目录下的js文件在根路径，因此需要在加载HTMLString时指定根路径
//        NSString *basePath = [[NSBundle mainBundle] bundlePath];
//        
//        NSURL *baseURL = [NSURL fileURLWithPath:basePath];
//        
//        [self.webView loadHTMLString:tempHtml baseURL:baseURL];
//        
//        [self.webView loadHTMLString:tempHtml baseURL:baseURL];
//        
//        
//        [self.webView setScalesPageToFit:NO];
//        
//        self.webView.scrollView.bounces = YES;
//        
//        UIScrollView *tempView = (UIScrollView *)[self.webView.subviews objectAtIndex:0];
//        
//        tempView.scrollEnabled = YES;
//    }
}

- (NSString *)handleStringWithString:(NSString *)str{
    
    NSString *text1= [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    
    NSString *text2= [text1 stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    NSString *text3 = [text2 stringByReplacingOccurrencesOfString:@"&quot;" withString:@"'"];
    
    return text3;
}

#pragma mark ================= NSURLConnectionDataDelegate <NSURLConnectionDelegate>

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0) {
        self.isAuthed = YES;
        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential *cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"网络不给力");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.isAuthed = YES;
    //webview 重新加载请求。
    [self.webView loadRequest:self.request];
    [connection cancel];
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
        
        
        
//        UILabel *lable = [UILabel labelWithText:@"关闭" font:kFont(15) textColor:RGBCOLOR(31, 144, 230) backGroundColor:ClearColor superView:nil];
//        
//        lable.userInteractionEnabled=YES;
//        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
//        
//        [lable addGestureRecognizer:labelTapGestureRecognizer];
//        
//        lable.size = CGSizeMake(31, 13);
//        
//        UIBarButtonItem *item1 = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"back" highImage:@"back"];
//        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:lable];
//        
//        NSArray *items = @[item1,item2];
//        viewController.navigationItem.leftBarButtonItems = items;
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem
{
    if (!_closeItem) {
//        _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeNative)];
        
        
        
        UILabel *lable = [UILabel labelWithText:@"关闭" font:kFont(15) textColor:BlackColor backGroundColor:ClearColor superView:nil];
        
        lable.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeNative)];
        
        [lable addGestureRecognizer:labelTapGestureRecognizer];
        
        lable.size = CGSizeMake(31, 13);
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:lable];
        
//        self.navigationItem.leftBarButtonItem = item;
        
        _closeItem = item;
    }
    return _closeItem;
}


@end
