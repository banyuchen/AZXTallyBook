//
//  JDInterface3ViewController.h
//  Borrowing
//
//  Created by Sierra on 2017/8/23.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//添加银行卡

#import <UIKit/UIKit.h>

@interface JDInterface3ViewController : UIViewController

//model图片被点击
@property (nonatomic, copy) void (^cellBackBlock)(NSArray *backArr);

@end
