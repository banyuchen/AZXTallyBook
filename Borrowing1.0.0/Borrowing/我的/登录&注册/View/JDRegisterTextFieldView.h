//
//  JDRegisterTextFieldView.h
//  Borrowing
//
//  Created by Sierra on 2017/8/30.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDRegisterTextFieldView : UIView

/**标题*/
@property (nonatomic, strong) UILabel *titleLbl;
/**输入框*/
@property (nonatomic, strong) UITextField *textField;
/**线条*/
@property (nonatomic, strong) UIView *line;

@end
