//
//  JDIndividuationTableViewCell.h
//  Borrowing
//
//  Created by Sierra on 2017/8/28.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -------------------------------------------------------------------------传入数据模型-----------------------------------------------------------------------------------------------

@interface JDMyIndividuationModel : UITableViewCell

/**标题*/
@property (nonatomic, copy) NSString *cellName;
/**占位文字*/
@property (nonatomic, copy) NSString *placeholder;
/**输入文字*/
@property (nonatomic, copy) NSString *fieldText;
/**选择文字*/
@property (nonatomic, copy) NSString *choiceText;
/**键盘方式*/
@property(nonatomic) UIKeyboardType keyboardType;

/**省*/
@property (nonatomic, copy) NSString *provice;
/**市*/
@property (nonatomic, copy) NSString *city;
/**区*/
@property (nonatomic, copy) NSString *area;
/**电话*/
@property (nonatomic, copy) NSString *mobile;
/**婚姻 1未婚 2已婚*/
@property (nonatomic, copy) NSString *marriage;
/**文化程度1高中以下2高中以及专科3大学4硕士以及以上*/
@property (nonatomic, copy) NSString *culture;
/**用户名*/
@property (nonatomic, copy) NSString *userName;
/**身份证号*/
@property (nonatomic, copy) NSString *card;
/**借款金额*/
@property (nonatomic, copy) NSString *loanMoney;
/**借款时间类型 1日  2月*/
@property (nonatomic, copy) NSString *loanTimeType;
/**借款时间*/
@property (nonatomic, copy) NSString *loanTime;
/**设备 1 android 2 IOS*/
@property (nonatomic, copy) NSString *equipment;
/**设备号 imei或者idfa*/
@property (nonatomic, copy) NSString *deviceNumber;
/**创建时间*/
@property (nonatomic, copy) NSString *created;
/**用户id*/
@property (nonatomic, copy) NSString *userId;
/**个人意向的ID*/
@property (nonatomic, copy) NSString *ID;

@end

#pragma mark -------------------------------------------------------------------------填写cell-----------------------------------------------------------------------------------------------
@interface JDIndividuationTableViewCell : UITableViewCell

/**标题*/
@property (nonatomic, strong) UILabel *titleLbl;

/**输入框*/
@property (nonatomic, strong) UITextField *textField;


@end

#pragma mark -------------------------------------------------------------------------选择cell-----------------------------------------------------------------------------------------------
@interface JDIndividuationChoiceTableViewCell : UITableViewCell

/**标题*/
@property (nonatomic, strong) UILabel *titleLbl;
/**请选择*/
@property (nonatomic, strong) UILabel *choiceLbl;

@end
