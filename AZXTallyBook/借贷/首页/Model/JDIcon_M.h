//
//  JDIcon_M.h
//  Borrowing
//
//  Created by Sierra on 2017/8/25.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDIcon_M : NSObject
/**图片 */
@property (nonatomic , copy) NSString              * images;
/**icon名字 */
@property (nonatomic , copy) NSString              * productTypeName;
/**是否删除 */
@property (nonatomic , copy) NSString              * isDeleted;
/** */
@property (nonatomic , copy) NSString              * ID;
/** */
@property (nonatomic , copy) NSString              * sortNumber;
/**更新时间 */
@property (nonatomic , copy) NSString              * updated;
/**创建时间 */
@property (nonatomic , copy) NSString              * created;


@property (nonatomic , copy) NSString              * linkUrl;
@property (nonatomic , copy) NSString              * appLinkUrl;

/** 分类ID */
@property (nonatomic , copy) NSString              * productClassId;

/**类型：1商品 2 链接 */
@property (nonatomic , copy) NSString              * type;

@end
