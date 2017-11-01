//
//  JDMyTableViewCell.h
//  Borrowing
//
//  Created by Sierra on 2017/8/28.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDBorrowMyCellModel : NSObject

/**图片*/
@property (nonatomic, copy) NSString *cellIconImg;
/**标题*/
@property (nonatomic, copy) NSString *cellTitle;

@end


@interface JDMyTableViewCell : UITableViewCell

/**数据源*/
@property (nonatomic, strong) JDBorrowMyCellModel *cellDic;

@end
