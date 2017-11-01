//
//  AppDelegate.m
//  Borrowing
//
//  Created by Sierra on 2017/8/22.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "AppDelegate.h"
#import "DBTabBarController.h"
#import "ZJLeadingPageController.h"
#import "ViewController.h"

//************************************************** 友盟统计 ********************************************************8
#import "UMMobClick/MobClick.h"

@interface AppDelegate ()
{
    BOOL _isShow;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_queue_create("com.dispatch.test", DISPATCH_QUEUE_CONCURRENT), ^{
        // 创建一个信号量为0的信号(红灯)
        dispatch_semaphore_t sema1 = dispatch_semaphore_create(0);
        
        NSDictionary *parameters2 =
        @{
          };
        
        NSString *url2 = [[NSString stringWithFormat:@"%@/version/getVersion", LINEURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPSessionManager *manager = [XMToolClass httpRequestInit];
        
        //    __weak typeof(self) weakSelf = self;
        
        // 发送请求
        [manager GET:url2 parameters:parameters2 progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
//            [[NSUserDefaults standardUserDefaults] setObject:@"n" forKey:@"BorrowingIsShow"];
            [[NSUserDefaults standardUserDefaults] setObject:[[responseObject valueForKey:@"returnValue"] valueForKey:@"yesNo"] forKey:@"BorrowingIsShow"];
            
            // 使信号的信号量+1，这里的信号量本来为0，+1信号量为1(绿灯)
            dispatch_semaphore_signal(sema1);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"n" forKey:@"BorrowingIsShow"];
            
            // 使信号的信号量+1，这里的信号量本来为0，+1信号量为1(绿灯)
            dispatch_semaphore_signal(sema1);
        }];
        
        // 开启信号等待，设置等待时间为永久，直到信号的信号量大于等于1（绿灯）
        dispatch_semaphore_wait(sema1, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [self loadUI];
        
    });
    
    
    return YES;
}


#pragma mark --- 检测是否是线上
- (void)loadUI
{
    
    /**
     ***************************************************************** 友盟 *********************************************************************
     */
    
    UMConfigInstance.appKey = @"59b8dc174544cb293b00003c";
    UMConfigInstance.channelId = @"App Store";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    /**
     ********************************************************************************************************************************************
     */
    
    
    _isShow = [[[NSUserDefaults standardUserDefaults] valueForKey:@"BorrowingIsShow"] isEqualToString:@"y"] ? NO : YES;
    
    
    
    if (!_isShow) {
        
        
        [self isTrue];
    }else{
        
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        self.window.rootViewController = [[DBTabBarController alloc] init];
        
        self.window.backgroundColor = WhiteColor;
        
        [self.window makeKeyAndVisible];
    }
    
}


- (void)isTrue
{
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *versionCache = [[NSUserDefaults standardUserDefaults] objectForKey:@"VersionCache"];//本地缓存的版本号  第一次启动的时候本地是没有缓存版本号的。
    
    if (![versionCache isEqualToString:version]) //如果本地缓存的版本号和当前应用版本号不一样，则是第一次启动（更新版本也算第一次启动）
    {
        // 如果是第一次安装打开App --- 显示引导页面
        ZJLeadingPageController *leadController = [[ZJLeadingPageController alloc] initWithPagesCount:3 setupCellHandler:^(ZJLeadingPageCell *cell, NSIndexPath *indexPath) {
            
            // 设置图片
            NSString *imageName = [NSString stringWithFormat:@"load%ld",indexPath.row+1];
            cell.imageView.image = [UIImage imageNamed:imageName];
            
            // 设置按钮属性
            [cell.finishBtn setTitle:@"立即体验" forState:UIControlStateNormal];
            [cell.finishBtn setTitleColor:RGBCOLOR(58,133,243) forState:UIControlStateNormal];
            
        } finishHandler:^(UIButton *finishBtn) {
            
            self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            
            self.window.rootViewController = [[DBTabBarController alloc] init];
            
            [self.window makeKeyAndVisible];
            
            [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"VersionCache"];
        }];
        
        // 自定义属性
        leadController.pageControl.pageIndicatorTintColor = GrayLoginColor;
        leadController.pageControl.currentPageIndicatorTintColor = RGBCOLOR(58,133,243);
        
        
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
        self.window.rootViewController = leadController;
        
    }else{
        
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        self.window.rootViewController = [[DBTabBarController alloc] init];
        
        [self.window makeKeyAndVisible];
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
