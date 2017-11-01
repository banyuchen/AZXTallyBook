//
//  JDStatisticsManager.m
//  Borrowing
//
//  Created by Sierra on 2017/9/6.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDStatisticsManager.h"
#import "XMGHTTPSessionManager.h"

@interface JDStatisticsManager ()

/** 任务管理者 */
@property (nonatomic, strong) XMGHTTPSessionManager *manager;
@end

@implementation JDStatisticsManager

+ (JDStatisticsManager*)sharedInstance {
    
    static JDStatisticsManager *personalDate;
    static dispatch_once_t demoglobalclassonce;
    dispatch_once(&demoglobalclassonce, ^{
        personalDate = [[JDStatisticsManager alloc] init];
    });
    return personalDate;
}

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
 @param ua 是否微信（0否1是）
 @param uid 32位MD5加密一个唯一标识（例如 MD5（dkch+uid））
 @param modelname 简要描述（例：礼券点击）
 @param modeltype （5请求接口 6曝光 7点击）
 @param callSucceedBack <#callSucceedBack description#>
 @param callFailBack <#callFailBack description#>
 */
- (void)getCountInfoWithPreid:(NSString *_Nullable)preid awardtype:(NSString *_Nullable)awardtype activityid:(NSString *_Nullable)activityid appos:(NSString *_Nullable)appos appkey:(NSString *_Nullable)appkey business:(NSString *_Nullable)business i:(NSString *_Nullable)i f:(NSString *_Nullable)f ua:(NSString *_Nullable)ua uid:(NSString *_Nullable)uid modelname:(NSString *_Nullable)modelname modeltype:(NSString *_Nullable)modeltype  callSucceedBack: (void(^_Nullable)(id _Nullable responseObject))callSucceedBack callFailBack:(void(^_Nullable)(NSError * _Nonnull error))callFailBack{
    
    
    preid = [XMToolClass isBlankString:preid] ? @"0" : preid;
    activityid = [XMToolClass isBlankString:activityid] ? @"" : activityid;
    
    
    //传入的参数
    NSDictionary *parameters =
    @{
      @"preid":preid,
      @"awardtype":@"2",
      @"activityid":activityid,
      @"appos":@"2",
      @"appkey":appkey,
      @"business":@"dkcs",
      @"i":i,
      @"f":f,
      @"ua":@"0",
      @"uid":uid,
      @"modelname":@"礼券点击",
      @"modeltype":@"7",
      };
    
    NSString *url = [@"https://buy.bianxianmao.com/award/countInfo" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *url = @"https://buy.bianxianmao.com/award/countInfo" ;
    
    // 发送请求
    [self.manager POST:url parameters:[XMToolClass parseParams:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([[responseObject valueForKey:@"success"] boolValue]) {
            
            callSucceedBack(responseObject);
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        callFailBack(error);
        
        [SVProgressHUD dismiss];
        APPDELEGATE.window.userInteractionEnabled = YES;
        [CommonMethod altermethord:TipFailure andmessagestr:TipFailureDetail andconcelstr:@"确定"];
    }];
    
    
}


- (void)addPVUVWithAppId:(NSString *_Nullable)appId userId:(NSString *_Nullable)userId appEntranceId:(NSString *_Nullable)appEntranceId position:(NSString *_Nullable)position token:(NSString *_Nullable)token pattern:(NSString *_Nullable)pattern callSucceedBack: (void(^_Nullable)(id _Nullable responseObject))callSucceedBack callFailBack:(void(^_Nullable)(NSError * _Nonnull error))callFailBack{
    
    appId = [XMToolClass isBlankString:appId] ? @"" :  appId;
    userId = [XMToolClass isBlankString:[DBSave account].ID] ? @""  : [DBSave account].ID;
    appEntranceId = [XMToolClass isBlankString:appEntranceId] ? @"" :  appEntranceId;
    position = [XMToolClass isBlankString:position] ? @"" :  position;
    pattern = [XMToolClass isBlankString:pattern] ? @"" :  pattern;
    
    //传入的参数
    NSDictionary *parameters =
    @{
      @"appId":appId,
      @"userId":userId,
      @"appEntranceId":appEntranceId,
      @"position":position,
      @"token":token,
      @"pattern":pattern,
      };
    
    
    NSString *url = [[NSString stringWithFormat:@"%@/pvuv", LOGINURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // 发送请求
    [self.manager POST:url parameters:[XMToolClass parseParams:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            callSucceedBack(responseObject);
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        callFailBack(error);
        
//        [SVProgressHUD dismiss];
//        APPDELEGATE.window.userInteractionEnabled = YES;
//        [CommonMethod altermethord:TipFailure andmessagestr:TipFailureDetail andconcelstr:@"确定"];
    }];
    
    
}


/**
 贷款超市添加PVUV
 
 @param appId 接口appKey，应用的唯一标识（在开发者后台接口配置处可查看）
 @param userId app用户id，需保证唯一性。变现猫视其为用户唯一标识。 （无账户体系、用户未登录时传递not_login标识，默认为not_login）
 @param position    记录PV的位置(金贷款超市使用：1首页、2贷款、3福利页、4我的页面； 6立即申请 7 统计单个商品的，用于统计各个商品的PVUV待定)
                    10-18新加的(11首页banner 、12 首页icon、13福利页banner、14信用卡点击申请、15保险专柜申请、
 @param token 用户token
 @param pattern 10 贷款超市
 @param type  android  2 IOS  3 h5
 @param productId 商品ID
 */
- (void)addloanShopPVUVWithAppId:(NSString *_Nullable)appId userId:(NSString *_Nullable)userId position:(NSString *_Nullable)position token:(NSString *_Nullable)token pattern:(NSString *_Nullable)pattern type:(NSString *_Nullable)type productId:(NSString *_Nullable)productId  callSucceedBack: (void(^_Nullable)(id _Nullable responseObject))callSucceedBack callFailBack:(void(^_Nullable)(NSError * _Nonnull error))callFailBack
{
    
    appId = [XMToolClass isBlankString:appId] ? @"" :  appId;
    userId = [XMToolClass isBlankString:[DBSave account].ID] ? @""  : [DBSave account].ID;
    position = [XMToolClass isBlankString:position] ? @"" :  position;
    token = [XMToolClass isBlankString:token] ? @"" :  token;
    pattern = [XMToolClass isBlankString:pattern] ? @"" :  pattern;
    type = [XMToolClass isBlankString:type] ? @"" :  type;
    productId = [XMToolClass isBlankString:productId] ? @"0" :  productId;
    
    //传入的参数
    NSDictionary *parameters =
    @{
      @"appId":appId,
      @"userId":userId,
      @"position":position,
      @"token":token,
      @"pattern":pattern,
      @"type":type,
      @"productId":productId,
      };
    
    
    NSString *url = [[NSString stringWithFormat:@"%@/pvuv/addloanShopPVUV", LOGINURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // 发送请求
    [self.manager POST:url parameters:[XMToolClass parseParams:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            callSucceedBack(responseObject);
            
        }else{
            
//            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message       "]];
//            [SVProgressHUD dismissWithDelay:kDelayTime];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        callFailBack(error);
        
//        [SVProgressHUD dismiss];
//        APPDELEGATE.window.userInteractionEnabled = YES;
//        [CommonMethod altermethord:TipFailure andmessagestr:TipFailureDetail andconcelstr:@"确定"];
    }];
    
    
    
}



/**
 添加浏览记录
 
 @param useId 用户ID
 @param productId 产品ID
 @param callSucceedBack <#callSucceedBack description#>
 @param callFailBack <#callFailBack description#>
 */
- (void)addBrowseLogWithUseId:(NSString *_Nullable)useId productId:(NSString *_Nullable)productId  callSucceedBack: (void(^_Nullable)(id _Nullable responseObject))callSucceedBack callFailBack:(void(^_Nullable)(NSError * _Nonnull error))callFailBack
{
    
    productId = [XMToolClass isBlankString:productId] ? @"" : productId;
    useId = [XMToolClass isBlankString:useId] ? @"" : useId;
    
    NSDictionary *parameters2 =
    @{
      @"userId":useId,
      @"productId":productId,
      };
    
    NSString *url2 = [[NSString stringWithFormat:@"%@/browselog/addBrowseLog", LINEURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [XMToolClass httpRequestInit];
    
    // 发送请求
    [manager GET:url2 parameters:parameters2 progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            callSucceedBack(responseObject);
            
        }else{
            
//            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"errorCode"]];
//            [SVProgressHUD dismissWithDelay:kDelayTime];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        callFailBack(error);
        
//        [SVProgressHUD dismiss];
//        APPDELEGATE.window.userInteractionEnabled = YES;
//        [CommonMethod altermethord:TipFailure andmessagestr:TipFailureDetail andconcelstr:@"确定"];
    }];
    
}



- (XMGHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [XMGHTTPSessionManager manager];
    }
    return _manager;
}


@end
