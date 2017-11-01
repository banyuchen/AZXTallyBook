//
//  JDGOOUTViewController.h
//  Borrowing
//
//  Created by Sierra on 2017/10/25.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//退出登录

#import <UIKit/UIKit.h>

@protocol JDGOOUTViewControllerDelegate <NSObject>

- (void)didClickGoOutBtn;//点击退出

@end

@interface JDGOOUTViewController : UIViewController


@property (nonatomic, weak) id<JDGOOUTViewControllerDelegate> delegate;

@end
