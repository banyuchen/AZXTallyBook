//
//  DBAccount.h
//  Snatch
//
//  Created by Sierra on 2017/8/2.
//  Copyright © 2017年 Sierra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBAccount : NSObject


@property (nonatomic , copy) NSString              * ggkUrl;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * redirectUrl;
@property (nonatomic , copy) NSString              * idfa;
@property (nonatomic , copy) NSString              * buyUrl;
@property (nonatomic , copy) NSString              * appId;
@property (nonatomic , copy) NSString              * appEntrance;
@property (nonatomic , copy) NSString              * imei;
@property (nonatomic , copy) NSString              * userToken;
@property (nonatomic , copy) NSString              * appKey;
@property (nonatomic , copy) NSString              * account;
@property (nonatomic , copy) NSString              * appUid;
@property (nonatomic , copy) NSString              * face;
@property (nonatomic , copy) NSString              * nickname;


+ (instancetype)accountWithDict:(NSDictionary *)dict;


/*
 
 account = 17625296836;
 appEntrance = "<null>";
 appId = "<null>";
 appKey = a0b11e41e15041929219fc56dcffc597;
 appUid = 17625296836;
 buyUrl = "<null>";
 face = "https://image.bianxianmao.com/face.png";
 ggkUrl = "<null>";
 id = 1568020;
 idfa = "<null>";
 imei = "<null>";
 nickname = "176****6836";
 redirectUrl = "<null>";
 userToken = 7f7b87c7ca6149f09348eb05da002407;
 
 */
@end
