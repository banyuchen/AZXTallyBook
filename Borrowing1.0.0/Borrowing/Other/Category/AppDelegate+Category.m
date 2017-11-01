//
//  AppDelegate+Category.m
//  XMBasePj
//
//  Created by WenhuaLuo on  16/3/2.
//  Copyright © 2016年 WXIAOM. All rights reserved.
//

#import "AppDelegate+Category.h"
#import "AFNetworkActivityIndicatorManager.h"
@implementation AppDelegate (Category)
#pragma mark - *******************************  检测网络状况  *******************************
- (void)monitorNetWork{
    //电池条显示网络活动
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    //检测网络状态
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case 1:
            case 2:
                [XMToolClass NoNetWorkingView:ONLINE];
                break;
                //            case 0:
            default:
                [XMToolClass NoNetWorkingView:OUTLINE];
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}


@end
