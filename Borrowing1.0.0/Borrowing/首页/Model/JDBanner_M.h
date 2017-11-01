//
//  JDBanner_M.h
//  Borrowing
//
//  Created by Sierra on 2017/8/25.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDBanner_M : NSObject
/**图片 */
@property (nonatomic , copy) NSString              * images;
/**链接地址*/
@property (nonatomic , copy) NSString              * linkeUrl;
/**位置 1:首页banner 2:福利页banner*/
@property (nonatomic , copy) NSString              * position;
/**bannerID*/
@property (nonatomic , copy) NSString              * ID;
/**商品ID*/
@property (nonatomic , copy) NSString              * productId;
/***/
@property (nonatomic , copy) NSString              * updated;
/**时间*/
@property (nonatomic , copy) NSString              * created;
/**名称*/
@property (nonatomic , copy) NSString              * bannerName;
/** 商品  2 链接*/
@property (nonatomic , copy) NSString              * bannerType;
/** */
@property (nonatomic , copy) NSString              * creator;
/**状态y  启用  n 禁用*/
@property (nonatomic , copy) NSString              * state;

@end
