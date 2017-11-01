//
//  JDProductDetailViewController.h
//  Borrowing
//
//  Created by Sierra on 2017/9/4.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//贷款详情

#import <UIKit/UIKit.h>
#import "JDProduct_M.h"
#import "JDWebViewViewController.h"

#pragma mark ****************************************************************************贷款***************************************************************************************
@interface JDProductDetailViewController : UIViewController


@property (nonatomic, strong) JDProduct_M *productM;

@end






#pragma mark ****************************************************************************保险&&信用卡***************************************************************************************

@interface JDProductDetail1ViewController : UIViewController

@property (nonatomic, copy) NSString *productIosUrl;
@property (nonatomic, copy) NSString *productID;

/**是否是立即申请进去的*/
@property (nonatomic, copy) NSString *isApplyNow;

@end
