//
//  JDProduct_M.h
//  Borrowing
//
//  Created by Sierra on 2017/8/25.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDProduct_M : NSObject

@property (nonatomic , copy) NSString              * isDeleted;
@property (nonatomic , copy) NSString              * creator;
/**产品特色*/
@property (nonatomic , copy) NSString              * productCharacteristic;
/**贷款时间类型（1 日 2 月）*/
@property (nonatomic , copy) NSString              * loanTimeType;
/**成功率*/
@property (nonatomic , copy) NSString              * successRate;
/**权重*/
@property (nonatomic , copy) NSString              * sortNumber;
/**商品类型（多个以，隔开）*/
@property (nonatomic , copy) NSString              * productType;
@property (nonatomic , copy) NSString              * updated;
/**已经放款*/
@property (nonatomic , copy) NSString              * securedLoan;
/**状态（y启用 n 禁用）*/
@property (nonatomic , copy) NSString              * state;
/**广告主ID*/
@property (nonatomic , copy) NSString              * advertiserId;
@property (nonatomic , copy) NSString              * ID;
/**产品介绍*/
@property (nonatomic , copy) NSString              * productIntroduce;
/**产品图片*/
@property (nonatomic , copy) NSString              * productImg;
/**广告券*/
@property (nonatomic , copy) NSString              * advertiserVoucher;
/**产品链接*/
@property (nonatomic , copy) NSString              * productUrl;
/**贷款开始时间*/
@property (nonatomic , copy) NSString              * startLoanTime;
/**贷款结束时间*/
@property (nonatomic , copy) NSString              * endLoanTime;
/**日利率*/
@property (nonatomic , copy) NSString              * interestRateDay;
/**广告主*/
@property (nonatomic , copy) NSString              * advertiser;
/**是否首页推荐（y 是 n不是）*/
@property (nonatomic , copy) NSString              * isRecommend;
/**广告类型 1借贷 2 信用卡 3 保险*/
@property (nonatomic , copy) NSString              * advertiserType;
/**商品名称*/
@property (nonatomic , copy) NSString              * productName;
/**广告券id*/
@property (nonatomic , copy) NSString              * advertiserVoucherIdIos;
@property (nonatomic , copy) NSString              * created;
/**贷款开始额度*/
@property (nonatomic , copy) NSString              * startLoanMoney;
/**贷款结束额度*/
@property (nonatomic , copy) NSString              * endLoanMoney;


@property (nonatomic , copy) NSString              * productAndroidUrl;
@property (nonatomic , copy) NSString              * productIosUrl;
@property (nonatomic , copy) NSString              * productH5Url;



/**亮点*/
@property (nonatomic , copy) NSString              * highlights;

@end
