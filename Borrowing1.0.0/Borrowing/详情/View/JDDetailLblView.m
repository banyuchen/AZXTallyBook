//
//  JDDetailLblView.m
//  Borrowing
//
//  Created by Sierra on 2017/9/4.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDDetailLblView.h"

@interface JDDetailLblView ()

/**标题*/
@property (nonatomic, strong) UILabel *titleLbl;
/**内容*/
@property (nonatomic, strong) UILabel *descLbl;

/**线条*/
@property (nonatomic, strong) UIView *line;

@end

@implementation JDDetailLblView


- (void)setDetailModel:(JDDetailLblViewModel *)detailModel
{
    _detailModel = detailModel;
    
    self.titleLbl.text = detailModel.detailTitle;
    
    self.descLbl.attributedText = [NSString attributedStringWithColorTitle:detailModel.descStr normalTitle:detailModel.unitStr frontTitle:@"" normalColor:RGBCOLOR(102,102,102) diffentColor:RGBCOLOR(69, 153, 252) normalFont:kFont(14) differentFont:kFont(16)];
    
    [self line];
}

- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        
        _titleLbl = [UILabel labelWithText:@"" font:kFont(16) textColor:RGBCOLOR(102,102,102) backGroundColor:ClearColor superView:self];
        
        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(6);
            make.top.mas_equalTo(0);
            
        }];
    }
    return _titleLbl;
}



- (UILabel *)descLbl
{
    if (!_descLbl) {
        
        _descLbl = [UILabel labelWithText:@"" font:kFont(14) textColor:RGBCOLOR(102,102,102) backGroundColor:ClearColor superView:self];
        
        [_descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(self.titleLbl.mas_left);
            make.top.mas_equalTo(self.titleLbl.mas_bottom).mas_equalTo(8);
        }];
    }
    return _descLbl;
}


- (UIView *)line
{
    if (!_line) {
        
        _line = [UIView viewWithBackgroundColor:SeparatorCOLOR superView:self];
        
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(0.5);
        }];
    }
    return _line;
}

@end


@implementation JDDetailLblViewModel

@end
