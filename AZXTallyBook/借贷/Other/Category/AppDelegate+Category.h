//
//  AppDelegate+Category.h
//  XMBasePj
//
//  Created by WenhuaLuo on  16/3/2.
//  Copyright © 2016年 WXIAOM. All rights reserved.
//

#import "AppDelegate.h"
typedef NS_ENUM(NSInteger, NETSTATE) {
    ONLINE,//有网
    OUTLINE,//没网
};

@interface AppDelegate (Category)

-(void)monitorNetWork;

@end
