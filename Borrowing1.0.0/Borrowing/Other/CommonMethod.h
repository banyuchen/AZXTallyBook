//
//  CommonMethod.h
//  Thebluebees
//
//  Created by admin on 15/7/2.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface CommonMethod : NSObject


+(int)initlabelwith:(NSString *)labelstr;

+(UIImageView *)setViewimag:(UIView *)taskview andimagename:(NSString *)imagestr;

+(UIBarButtonItem *)Setbarbtntextcolor:(UIColor *)textcolor andtitlestr:(NSString *)textstr;

+(void)altermethord:(NSString *)titlestr andmessagestr:(NSString *)messagestr andconcelstr:concelstr;

+(void)GetVerificationCode:(UIButton *)Verificationbtn finish:(void (^)(void))finish;

+(BOOL)validateCarNo:(NSString *)carNo;

/*
 弹出登录页面
 **/
+ (void)tipLoginFromController:(UIViewController *)showController finish:(void (^)(void))finish;

////////时间相关的
+ (NSDate *)getCurrentTimeWithType:(NSString *)type;

+ (NSDate *)getDateWithString:(NSString *)dateStr type:(NSString *)type;

/////////////////////////

@end
