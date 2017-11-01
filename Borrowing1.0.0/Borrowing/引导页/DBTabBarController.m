//
//  DBTabBarController.m
//  Snatch
//
//  Created by Sierra on 2017/7/31.
//  Copyright © 2017年 Sierra. All rights reserved.
//

#import "DBTabBarController.h"
#import "DBNavigationController.h"

//项目文件
#import "JDMyViewController.h"//我的
#import "JDHomeViewController.h"//首页
#import "JDWelfareViewController.h"//福利
#import "JDBorrowViewController.h"//借款

//界面文件
#import "JDInterfaceViewController.h"
#import "JDInterface1ViewController.h"


@interface DBTabBarController ()
{
    BOOL _isShow;
}


@end

@implementation DBTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    _isShow = [[[NSUserDefaults standardUserDefaults] valueForKey:@"BorrowingIsShow"] isEqualToString:@"y"] ? YES : NO;
    
    
    if (!_isShow) {
        
        //模式tabbar图标选中时的描述颜色
        [self.tabBar setTintColor:ThemeColor];
        
        [self addChildVc:[JDInterfaceViewController new] title:@"借款申请" image:@"bar_loan" selectedImage:@"bar_loan_red"];
        
        [self addChildVc:[JDInterface1ViewController new] title:@"我的" image:@"bar_mine" selectedImage:@"bar_mine_red"];
        
        CGRect frame = CGRectMake(0.0, 0, kWindowW, 50);
        
        UIView *v = [[UIView alloc] initWithFrame:frame];
        
        [v setBackgroundColor:WhiteColor];
        
        [self.tabBar insertSubview:v atIndex:0];
        
    }else{
        //模式tabbar图标选中时的描述颜色
        [self.tabBar setTintColor:ThemeColor];
        
        [self addChildVc:[JDHomeViewController new] title:@"首页" image:@"bar_home" selectedImage:@"bar_home_red"];
        
        JDBorrowViewController *vc = [[JDBorrowViewController alloc] init];
        vc.view.backgroundColor = WhiteColor;
        
        [self addChildVc:vc title:@"贷款" image:@"bar_loan" selectedImage:@"bar_loan_red"];
        
        [self addChildVc:[JDWelfareViewController new] title:@"福利" image:@"bar_welfare" selectedImage:@"bar_welfare_red"];
        
        [self addChildVc:[JDMyViewController new] title:@"我的" image:@"bar_mine" selectedImage:@"bar_mine_red"];
        
        
        CGRect frame = CGRectMake(0.0, 0, kWindowW, 50);
        
        UIView *v = [[UIView alloc] initWithFrame:frame];
        
        [v setBackgroundColor:WhiteColor];
        
        [self.tabBar insertSubview:v atIndex:0];
    }
}



/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    
    textAttrs[NSForegroundColorAttributeName] = RGBCOLOR(123, 123, 123);
    
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    
    selectTextAttrs[NSForegroundColorAttributeName] = ThemeColor;
    
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    //    childVc.view.backgroundColor = HWRandomColor;
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    DBNavigationController *nav = [[DBNavigationController alloc] initWithRootViewController:childVc];
    
    // 添加为子控制器
    [self addChildViewController:nav];
}

@end
