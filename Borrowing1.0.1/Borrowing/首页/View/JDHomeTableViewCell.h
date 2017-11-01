//
//  JDHomeTableViewCell.h
//  Borrowing
//
//  Created by Sierra on 2017/8/25.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDProduct_M.h"

/**--------------------------------------------------------信用卡&&保险--------------------------------------------------------------------------**/
@interface JDHomeTableViewCell : UITableViewCell

/**数据源*/
@property (nonatomic, strong) NSArray *dataArr;
/**数据源*/
@property (nonatomic, strong) JDProduct_M *productDic;

@end

/**--------------------------------------------------------借贷cell--------------------------------------------------------------------------**/

@interface JDHomeBrowingTableViewCell : UITableViewCell


/**数据源*/
@property (nonatomic, strong) NSArray *dataArr;
/**数据源*/
@property (nonatomic, strong) JDProduct_M *productDic;

@end
