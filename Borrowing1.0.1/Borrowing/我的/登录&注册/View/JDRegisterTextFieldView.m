//
//  JDRegisterTextFieldView.m
//  Borrowing
//
//  Created by Sierra on 2017/8/30.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDRegisterTextFieldView.h"

@interface JDRegisterTextFieldView ()

@end

@implementation JDRegisterTextFieldView

- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        
        _titleLbl = [UILabel labelWithText:@"" font:kFont(15) textColor:BlackGrayColor backGroundColor:ClearColor superView:self];
        
        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(kMargin);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _titleLbl;
}

- (UITextField *)textField
{
    if (!_textField) {
        
        _textField = [[UITextField alloc] init];
        
        _textField.font = kFont(15);
        
        _textField.textColor = BlackGrayColor;
        
        [self addSubview:_textField];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(90);
            
            make.top.bottom.mas_equalTo(0);
            
            make.right.mas_equalTo(-kMargin);
        }];
        
        [self line];
    }
    return _textField;
}

- (UIView *)line
{
    if (!_line) {
        
        _line = [UIView viewWithBackgroundColor:[XMToolClass getColorWithHexString:@"e5e5e5"] superView:self];
        
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(kMargin);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return _line;
}
@end
