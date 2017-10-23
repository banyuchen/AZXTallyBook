//
//  JDFAQTableViewCell.h
//  Borrowing
//
//  Created by Sierra on 2017/9/5.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark **************************************数据结构(模型)*******************************************
@interface JDFAQHeaderViewModel : UIView

/**问题几*/
@property (nonatomic, copy) NSString *part;
/**问题*/
@property (nonatomic, copy) NSString *question;
/**答案*/
@property (nonatomic, copy) NSString *answerStr;

/**是否展开*/
@property (nonatomic, assign) BOOL isUnfold;

@end


#pragma mark ****************************************问题描述cell***************************************************

@interface JDFAQTableViewCell : UITableViewCell

/**数据源*/
@property (nonatomic, strong) JDFAQHeaderViewModel *headerModel;

@property (nonatomic, strong) JDFAQHeaderViewModel *answerModel;

@end

