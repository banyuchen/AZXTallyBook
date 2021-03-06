//
//  JDStatisticsManager.h
//  Borrowing
//
//  Created by Sierra on 2017/9/6.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDStatisticsManager : NSObject

+(JDStatisticsManager*_Nullable)sharedInstance;



/**
 https://buy.bianxianmao.com/award/countInfo

 @param preid 填礼券ID
 @param awardtype 固定写2
 @param activityid 若无活动ID填0
 @param appos (1 安卓 2 IOS 3 WEB)
 @param appkey <#appkey description#>
 @param business 贷款超市固定写（dkcs）
 @param i IMEI
 @param f IDFA
 @param ua （0否1是）
 @param uid 32位MD5加密一个唯一标识（例如 MD5（dkch+uid））
 @param modelname 简要描述（例：礼券点击）
 @param modeltype （5请求接口 6曝光 7点击）
 @param callSucceedBack <#callSucceedBack description#>
 @param callFailBack <#callFailBack description#>
 */
- (void)getCountInfoWithPreid:(NSString *_Nullable)preid awardtype:(NSString *_Nullable)awardtype activityid:(NSString *_Nullable)activityid appos:(NSString *_Nullable)appos appkey:(NSString *_Nullable)appkey business:(NSString *_Nullable)business i:(NSString *_Nullable)i f:(NSString *_Nullable)f ua:(NSString *_Nullable)ua uid:(NSString *_Nullable)uid modelname:(NSString *_Nullable)modelname modeltype:(NSString *_Nullable)modeltype  callSucceedBack: (void(^_Nullable)(id _Nullable responseObject))callSucceedBack callFailBack:(void(^_Nullable)(NSError * _Nonnull error))callFailBack;



/**
 添加PVUV

 @param appId 接口appKey，应用的唯一标识（在开发者后台接口配置处可查看）
 @param userId app用户id，需保证唯一性。变现猫视其为用户唯一标识。 （无账户体系、用户未登录时传递not_login标识，默认为not_login）
 @param appEntranceId 用户入口ID
 @param position 记录PV的位置(金贷款超市使用：1首页、2贷款、3福利页、4我的页面；5详情页 6立即申请 7:12345+商品ID，用于统计各个商品的PVUV待定)
 @param token 用户token
 @param pattern 业务id 1夺宝luck 2直播live 3特卖buy 4广告ad 5书城book 6游戏game 7段子joke 8福利社fui 9积分商城jifen10贷款超市
 @param callSucceedBack <#callSucceedBack description#>
 @param callFailBack <#callFailBack description#>
 */
- (void)addPVUVWithAppId:(NSString *_Nullable)appId userId:(NSString *_Nullable)userId appEntranceId:(NSString *_Nullable)appEntranceId position:(NSString *_Nullable)position token:(NSString *_Nullable)token pattern:(NSString *_Nullable)pattern callSucceedBack: (void(^_Nullable)(id _Nullable responseObject))callSucceedBack callFailBack:(void(^_Nullable)(NSError * _Nonnull error))callFailBack;



/**
 贷款超市添加PVUV

 @param appId 接口appKey，应用的唯一标识（在开发者后台接口配置处可查看）
 @param userId app用户id，需保证唯一性。变现猫视其为用户唯一标识。 （无账户体系、用户未登录时传递not_login标识，默认为not_login）
 @param position 记录PV的位置(金贷款超市使用：1首页、2贷款、3福利页、4我的页面；5详情页 6立即申请 ，用于统计各个商品的PVUV待定)
 @param token 用户token
 @param pattern 10 贷款超市
 @param type  android  2 IOS  3 h5
 @param productId 商品ID
 @param callSucceedBack <#callSucceedBack description#>
 @param callFailBack <#callFailBack description#>
 */
- (void)addloanShopPVUVWithAppId:(NSString *_Nullable)appId userId:(NSString *_Nullable)userId position:(NSString *_Nullable)position token:(NSString *_Nullable)token pattern:(NSString *_Nullable)pattern type:(NSString *_Nullable)type productId:(NSString *_Nullable)productId  callSucceedBack: (void(^_Nullable)(id _Nullable responseObject))callSucceedBack callFailBack:(void(^_Nullable)(NSError * _Nonnull error))callFailBack;

/**
 添加浏览记录

 @param useId 用户ID
 @param productId 产品ID
 @param callSucceedBack <#callSucceedBack description#>
 @param callFailBack <#callFailBack description#>
 */
- (void)addBrowseLogWithUseId:(NSString *_Nullable)useId productId:(NSString *_Nullable)productId  callSucceedBack: (void(^_Nullable)(id _Nullable responseObject))callSucceedBack callFailBack:(void(^_Nullable)(NSError * _Nonnull error))callFailBack;



@end
