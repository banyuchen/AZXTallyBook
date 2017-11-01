//
//  JDMyTableViewCell.m
//  Borrowing
//
//  Created by Sierra on 2017/8/28.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDMyTableViewCell.h"

@interface JDMyTableViewCell ()

/**图标*/
@property (nonatomic, strong) UIImageView *cellImgView;
/**标题*/
@property (nonatomic, strong) UILabel *titleLbl;
/**箭头*/
@property (nonatomic, strong) UIImageView *rightImgView;

@end

@implementation JDMyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellDic:(JDBorrowMyCellModel *)cellDic
{
    _cellDic = cellDic;
    
    self.cellImgView.image = [UIImage imageNamed:cellDic.cellIconImg];
    
    self.titleLbl.text = cellDic.cellTitle;
}

- (UIImageView *)cellImgView
{
    if (!_cellImgView) {
        
        _cellImgView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:_cellImgView];
        
        [_cellImgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(2*kMargin);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _cellImgView;
}

- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        
        _titleLbl = [UILabel labelWithText:@"" font:kFont(14) textColor:BlackGrayColor backGroundColor:ClearColor superView:self.contentView];
        
        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(self.cellImgView.mas_right).mas_equalTo(kMargin);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _titleLbl;
}

- (UIImageView *)rightImgView
{
    if (!_rightImgView) {
        
        _rightImgView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:_rightImgView];
        
        [_rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-kMargin);
        }];
    }
    return _rightImgView;
}

@end

@implementation JDBorrowMyCellModel


@end
