//
//  AppDelegate.m
//  AZXTallyBook
//
//  Created by azx on 16/3/7.
//  Copyright © 2016年 azx. All rights reserved.
//

#import "AppDelegate.h"
#import "DBTabBarController.h"
#import "ZJLeadingPageController.h"


//************************************************** 友盟统计 ********************************************************8
#import "UMMobClick/MobClick.h"

@interface AppDelegate (){
    BOOL _isShow;
}


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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
            
//                        [[NSUserDefaults standardUserDefaults] setObject:@"y" forKey:@"BorrowingIsShow"];
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
        
        
        _isShow = [[[NSUserDefaults standardUserDefaults] valueForKey:@"BorrowingIsShow"] isEqualToString:@"y"] ? YES : NO;
        
        
        if (!_isShow) {
            //majia
            
        }else{
            
            [self loadUI];
        }
        
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
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    // 退出应用时将appDidLaunch设为NO
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"appDidLaunch"];
    // 并保持CoreData的数据
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.azxccmu.AZXTallyBook" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AZXTallyBook" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AZXTallyBook.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        NSLog(@"saved");
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        NSLog(@"saved");
    }
}

@end
