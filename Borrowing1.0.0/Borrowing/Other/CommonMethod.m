//
//  CommonMethod.m
//  Thebluebees
//
//  Created by admin on 15/7/2.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "CommonMethod.h"
#import <CommonCrypto/CommonDigest.h>

#warning  登录跳转
//#import "DBLoginViewController.h"

@implementation CommonMethod



+ (NSDate *)getCurrentTimeWithType:(NSString *)type
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:type];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    return date;
}

+ (NSDate *)getDateWithString:(NSString *)dateStr type:(NSString *)type
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:type];
    return [dateFormatter dateFromString:dateStr];
}


+ (void)tipLoginFromController:(UIViewController *)showController finish:(void (^)(void))finish
{
//    DBLoginViewController *loginVC = [[DBLoginViewController alloc]init];
//    
//    [showController.navigationController pushViewController:loginVC animated:NO];
}


+(void)GetVerificationCode:(UIButton *)Verificationbtn finish:(void (^)(void))finish{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [Verificationbtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                
                [Verificationbtn setTitleColor:RGBCOLOR(31, 144, 230) forState:UIControlStateNormal];
                [Verificationbtn setBackgroundImage:[UIImage imageWithColor:WhiteColor] forState:UIControlStateNormal];
                
                //[Verificationbtn setTitleColor:[UIColor colorWithRed:(00.0/255.0) green:(32.0/255.0) blue:(96.0/255.0) alpha:1.0] forState:UIControlStateNormal];
                Verificationbtn.userInteractionEnabled = YES;
                
                if (finish) {
                    finish();
                }
            });
        }else{
            int seconds = timeout % 60;
            if (seconds != 0) {
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [Verificationbtn setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                    
                    [Verificationbtn setTitleColor:TableColor forState:UIControlStateNormal];
//                    [Verificationbtn setBackgroundImage:[UIImage imageWithColor:TableColor] forState:UIControlStateNormal];
                    
//                    [Verificationbtn setTitleColor:[UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:1.0] forState:UIControlStateNormal];
                    
                    Verificationbtn.userInteractionEnabled = NO;
                });
            }
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}

+(int)initlabelwith:(NSString *)labelstr{
    
    CGRect rect = [labelstr boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil];
    return rect.size.width;
}

+(UIImageView *)setViewimag:(UIView *)taskview andimagename:(NSString *)imagestr{
    
    UIImageView *homepagebacimg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imagestr]];
    homepagebacimg.frame = taskview.bounds;
    homepagebacimg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return homepagebacimg;
    
}//设置View背景图片


+(UIBarButtonItem *)Setbarbtntextcolor:(UIColor *)textcolor andtitlestr:(NSString *)textstr{
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = textstr;
    barButton.tintColor = textcolor;
    return barButton;
}//设置btnitem


+(void)altermethord:(NSString *)titlestr andmessagestr:(NSString *)messagestr andconcelstr:concelstr{
    
    UIAlertView* alert = [[UIAlertView alloc] init];
    alert.title = titlestr;
    alert.message =messagestr;
    [alert addButtonWithTitle:concelstr];
    [alert show];
    
}//提示信息方法//提示信息方法


+(BOOL)validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
//    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
    

}

@end
