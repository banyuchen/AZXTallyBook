//
//  JDInterface2FooterView.m
//  Borrowing
//
//  Created by Sierra on 2017/8/22.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDInterface2FooterView.h"

@interface JDInterface2FooterView ()

/**可提前还款，利息按天计算，免手续费*/
@property (nonatomic, strong) UILabel *lable1;
/**是否同意合同*/
@property (nonatomic, strong) UIButton *isAgreeBtn;
/**文字说明后续补充*/
@property (nonatomic, strong) UILabel *descLbl;

/**确定*/
@property (nonatomic, strong) UIButton *confirmBtn;


@end

@implementation JDInterface2FooterView


#pragma mark - 是否同意合同
- (void)isAgreeBtnClick
{
    
}

- (UILabel *)lable1
{
    if (!_lable1) {
        
        _lable1 = [UILabel labelWithText:@"可提前还款，利息按天计算，免手续费" font:kFont(12) textColor:BlackGrayColor backGroundColor:ClearColor superView:self];
        
        [_lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(kMargin*1.5);
            
            make.left.mas_equalTo(kMargin);
        }];
    }
    return _lable1;
}


- (UIButton *)isAgreeBtn
{
    if (!_isAgreeBtn) {
        
        _isAgreeBtn = [UIButton buttonWithImage:@"" target:self action:@selector(isAgreeBtnClick) showView:self];
        
        [_isAgreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(self.lable1.mas_bottom).mas_equalTo(8);
            
        }];
    }
    return _isAgreeBtn;
}

- (UILabel *)descLbl
{
    if (!_descLbl) {
        
        _descLbl = [UILabel labelWithText:@"本人已阅读并同意签署个人消费贷款合同、个人信用报告查询授权书" font:kFont(12) textColor:BlackGrayColor backGroundColor:ClearColor superView:self];
        
        [_descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.lable1.mas_bottom).mas_equalTo(8);
            make.left.mas_equalTo(self.isAgreeBtn.mas_right).mas_equalTo(5);
        }];
    }
    return _descLbl;
}



@end
