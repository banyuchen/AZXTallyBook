//
//  JDHomeRequestManager.h
//  Borrowing
//
//  Created by Sierra on 2017/9/5.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDHomeRequestManager : NSObject

+(JDHomeRequestManager*_Nullable)sharedInstance;


/**
 首页banner接口(轮播图)
 */
- (void)getBannerWithPosition:(NSString *_Nullable)position callSucceedBack: (void(^_Nullable)(id _Nullable responseObject))callSucceedBack callFailBack:(void(^_Nullable)(NSError * _Nonnull error))callFailBack;
/**
 首页icon列表
 */
- (void)getIconCallSucceedBack: (void(^_Nullable)(id _Nullable responseObject))callSucceedBack callFailBack:(void(^_Nullable)(NSError * _Nonnull error))callFailBack;

/**
 首页列表
 */
- (void)getproductWithIsRecommend:(NSString *_Nullable)isRecommend pageSize:(NSString *_Nullable)pageSize pageIndex:(NSString *_Nullable)pageIndex orderParam:(NSString *_Nullable)orderParam advertiserType:(NSString *_Nullable)advertiserType orderType:(NSString *_Nullable)orderType ID:(NSString *_Nullable)ID callSucceedBack: (void(^_Nullable)(id _Nullable responseObject))callSucceedBack callFailBack:(void(^_Nullable)(NSError * _Nonnull error))callFailBack;

/**
 查找产品详情

 */
- (void)getProductDetailWithId:(NSString *_Nullable)ID callSucceedBack: (void(^_Nullable)(id _Nullable responseObject))callSucceedBack callFailBack:(void(^_Nullable)(NSError * _Nonnull error))callFailBack;


@end
