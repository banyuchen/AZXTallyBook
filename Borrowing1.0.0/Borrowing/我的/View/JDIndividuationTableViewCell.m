//
//  JDIndividuationTableViewCell.m
//  Borrowing
//
//  Created by Sierra on 2017/8/28.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDIndividuationTableViewCell.h"

#pragma mark -------------------------------------------------------------------------填写cell-----------------------------------------------------------------------------------------------
@interface JDIndividuationTableViewCell ()

 /**单位*/
@property (nonatomic, strong) UILabel *unitLbl;


@end

@implementation JDIndividuationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        
        _titleLbl = [UILabel labelWithText:@"" font:kFont(13) textColor:BlackGrayColor backGroundColor:ClearColor superView:self.contentView];
        
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
        
        _textField.font = kFont(13);
        
        _textField.textColor = BlackNameColor;
        
        _textField.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:_textField];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(100);
            make.centerY.mas_equalTo(0);
            
            make.height.mas_equalTo(50);
            make.right.mas_equalTo(-kMargin);
        }];
    }
    return _textField;
}

- (UILabel *)unitLbl
{
    if (!_unitLbl) {
        
        _unitLbl = [UILabel labelWithText:@"元" font:kFont(13) textColor:BlackGrayColor backGroundColor:ClearColor superView:self];
        
        [_unitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-kMargin);
        }];
    }
    return _unitLbl;
}

@end

#pragma mark -------------------------------------------------------------------------选择cell-----------------------------------------------------------------------------------------------

@interface JDIndividuationChoiceTableViewCell ()


/**右边箭头*/
@property (nonatomic, strong) UIImageView *rightImgView;

@end

@implementation JDIndividuationChoiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        
        _titleLbl = [UILabel labelWithText:@"" font:kFont(13) textColor:BlackGrayColor backGroundColor:ClearColor superView:self.contentView];
        
        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(kMargin);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _titleLbl;
}

- (UIImageView *)rightImgView
{
    if (!_rightImgView) {
        
        _rightImgView = [[UIImageView alloc] init];
        
        _rightImgView.image = [UIImage imageNamed:@"right_choice"];
        
        [self.contentView addSubview:_rightImgView];
        
        [_rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-kMargin);
            
            make.size.mas_equalTo(CGSizeMake(KActualH(32), KActualH(32)));
        }];
    }
    return _rightImgView;
}

- (UILabel *)choiceLbl
{
    if (!_choiceLbl) {
        
        _choiceLbl = [UILabel labelWithText:@"" font:kFont(13) textColor:RGBCOLOR(223, 223, 223) backGroundColor:ClearColor superView:self.contentView];
        
        [_choiceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(self.rightImgView.mas_left).mas_equalTo(-5);
        }];
    }
    return _choiceLbl;
}

@end


#pragma mark -------------------------------------------------------------------------传入数据模型-----------------------------------------------------------------------------------------------
@implementation JDMyIndividuationModel


+ (NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{ @"ID" : @"id" };
}
@end
