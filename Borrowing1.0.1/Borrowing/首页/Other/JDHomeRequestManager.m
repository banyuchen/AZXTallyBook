//
//  JDHomeRequestManager.m
//  Borrowing
//
//  Created by Sierra on 2017/9/5.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDHomeRequestManager.h"

@implementation JDHomeRequestManager

+ (JDHomeRequestManager*)sharedInstance {
    
    static JDHomeRequestManager *personalDate;
    static dispatch_once_t demoglobalclassonce;
    dispatch_once(&demoglobalclassonce, ^{
        personalDate = [[JDHomeRequestManager alloc] init];
    });
    return personalDate;
}



- (void)getBannerWithPosition:(NSString *_Nullable)position callSucceedBack: (void(^_Nullable)(id _Nullable responseObject))callSucceedBack callFailBack:(void(^_Nullable)(NSError * _Nonnull error))callFailBack{
    
    /**
     首页banner接口(轮播图)
     */
    NSDictionary *parameters2 =
    @{
      @"position":position,
      };
    
    NSString *url2 = [[NSString stringWithFormat:@"%@/banner/getBanner", LINEURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    AFHTTPSessionManager *manager = [XMToolClass httpRequestInit];
    
    // 发送请求
    [manager GET:url2 parameters:parameters2 progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            callSucceedBack(responseObject);
            
        }else{
            
//            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"errorDesc"]];
//            [SVProgressHUD dismissWithDelay:kDelayTime];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        callFailBack(error);
        
        [SVProgressHUD dismiss];
//        APPDELEGATE.window.userInteractionEnabled = YES;
//        [CommonMethod altermethord:TipFailure andmessagestr:TipFailureDetail andconcelstr:@"确定"];
    }];
}


- (void)getIconCallSucceedBack: (void(^_Nullable)(id _Nullable responseObject))callSucceedBack callFailBack:(void(^_Nullable)(NSError * _Nonnull error))callFailBack
{
    /**
     首页icon列表
     */
    NSDictionary *parameters2 =
    @{
      
      };
    
    NSString *url2 = [[NSString stringWithFormat:@"%@/icon/getIcon", LINEURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    AFHTTPSessionManager *manager = [XMToolClass httpRequestInit];
    
    // 发送请求
    [manager GET:url2 parameters:parameters2 progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            callSucceedBack(responseObject);
            
        }else{
            
//            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"errorDesc"]];
//            [SVProgressHUD dismissWithDelay:kDelayTime];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        callFailBack(error);
        
        [SVProgressHUD dismiss];
//        APPDELEGATE.window.userInteractionEnabled = YES;
//        [CommonMethod altermethord:TipFailure andmessagestr:TipFailureDetail andconcelstr:@"确定"];
    }];
}

- (void)getproductWithIsRecommend:(NSString *_Nullable)isRecommend pageSize:(NSString *_Nullable)pageSize pageIndex:(NSString *_Nullable)pageIndex orderParam:(NSString *_Nullable)orderParam advertiserType:(NSString *_Nullable)advertiserType orderType:(NSString *_Nullable)orderType ID:(NSString *_Nullable)ID callSucceedBack: (void(^_Nullable)(id _Nullable responseObject))callSucceedBack callFailBack:(void(^_Nullable)(NSError * _Nonnull error))callFailBack
{
    NSDictionary *parameters2 =
    @{
      @"isRecommend":isRecommend,
      @"pageSize":pageSize,
      @"pageIndex":pageIndex,
      @"orderParam":orderParam,
      @"advertiserType":advertiserType,
      @"orderType":orderType,
      @"id":ID,
      };
    
    NSString *url2 = [[NSString stringWithFormat:@"%@/product/getproduct", LINEURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    AFHTTPSessionManager *manager = [XMToolClass httpRequestInit];
    
    // 发送请求
    [manager GET:url2 parameters:parameters2 progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            callSucceedBack(responseObject);
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"errorDesc"]];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        callFailBack(error);
        
        [SVProgressHUD dismiss];
        APPDELEGATE.window.userInteractionEnabled = YES;
        [CommonMethod altermethord:TipFailure andmessagestr:TipFailureDetail andconcelstr:@"确定"];
    }];
}

- (void)getProductDetailWithId:(NSString *_Nullable)ID callSucceedBack: (void(^_Nullable)(id _Nullable responseObject))callSucceedBack callFailBack:(void(^_Nullable)(NSError * _Nonnull error))callFailBack
{
    /**
     首页列表
     */
    NSDictionary *parameters2 =
    @{
      @"id":ID,
      };
    
    NSString *url2 = [[NSString stringWithFormat:@"%@/product/getproductDetail", LINEURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    AFHTTPSessionManager *manager = [XMToolClass httpRequestInit];
    
    // 发送请求
    [manager GET:url2 parameters:parameters2 progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            callSucceedBack(responseObject);
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"errorDesc"]];
            [SVProgressHUD dismissWithDelay:kDelayTime];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        callFailBack(error);
        
        [SVProgressHUD dismiss];
        APPDELEGATE.window.userInteractionEnabled = YES;
        [CommonMethod altermethord:TipFailure andmessagestr:TipFailureDetail andconcelstr:@"确定"];
    }];
}

@end
