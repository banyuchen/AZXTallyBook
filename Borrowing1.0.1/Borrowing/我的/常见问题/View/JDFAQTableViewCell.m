//
//  JDFAQTableViewCell.m
//  Borrowing
//
//  Created by Sierra on 2017/9/5.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDFAQTableViewCell.h"
#pragma mark **************************************数据结构(模型)*******************************************


@implementation JDFAQHeaderViewModel


@end

#pragma mark ****************************************问题描述cell***************************************************

@interface JDFAQTableViewCell ()

/**问题几*/
@property (nonatomic, strong) UILabel *partLbl;
/**问题*/
@property (nonatomic, strong) UILabel *questionLbl;
/**图标*/
@property (nonatomic, strong) UIButton *iconBtn;

//***********************************展开后cell***********************************/

/**问题解答*/
@property (nonatomic, strong) UILabel *answerLbl;

@end


@implementation JDFAQTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHeaderModel:(JDFAQHeaderViewModel *)headerModel
{
    _headerModel = headerModel;
    
    self.partLbl.text = headerModel.part;
    
    self.questionLbl.text = headerModel.question;
    
    self.iconBtn.selected = headerModel.isUnfold;
}

- (void)setAnswerModel:(JDFAQHeaderViewModel *)answerModel
{
    _answerModel = answerModel;
    
    self.answerLbl.text = answerModel.answerStr;
}

- (UILabel *)partLbl
{
    if (!_partLbl) {
        
        _partLbl = [UILabel labelWithText:@"" font:kFont(16) textColor:RGBCOLOR(239, 35, 0) backGroundColor:ClearColor superView:self.contentView];
        
        [_partLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(kMargin + 2);
            make.top.mas_equalTo(kMargin);
            
            
        }];
    }
    return _partLbl;
}

- (UIButton *)iconBtn
{
    if (!_iconBtn) {
        
        _iconBtn = [UIButton buttonWithImage:@"" target:self action:nil showView:self.contentView];
        
        [_iconBtn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        [_iconBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateSelected];
        
        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.mas_equalTo(-kMargin);
            make.centerY.mas_equalTo(0);
        }];
    }
    
    return _iconBtn;
}

- (UILabel *)questionLbl
{
    if (!_questionLbl) {
        
        _questionLbl = [UILabel labelWithText:@"" font:kFont(16) textColor:BlackNameColor backGroundColor:ClearColor superView:self.contentView];
        
        _questionLbl.numberOfLines = 0;
        
        [_questionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(kMargin *3.5);
            
            make.top.mas_equalTo(kMargin);
            
            make.bottom.mas_equalTo(-kMargin);
        }];
    }
    
    return _questionLbl;
}

//***********************************展开后cell***********************************/

- (UILabel *)answerLbl
{
    if (!_answerLbl) {
        
        _answerLbl = [UILabel labelWithText:@"" font:kFont(14) textColor:BlackGrayColor backGroundColor:ClearColor superView:self.contentView];
        
        _answerLbl.numberOfLines = 0;
        
        [_answerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(kWindowW - 5.5*kMargin);
            make.top.mas_equalTo(kMargin);
            make.bottom.mas_equalTo(-kMargin);
            make.left.mas_equalTo(kMargin *3.5);
            
        }];
    }
    return _answerLbl;
}
@end
