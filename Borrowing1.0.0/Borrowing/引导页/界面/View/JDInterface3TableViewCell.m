//
//  JDInterface3TableViewCell.m
//  Borrowing
//
//  Created by Sierra on 2017/8/23.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDInterface3TableViewCell.h"

@interface JDInterface3TableViewCell ()

/**图标*/
@property (nonatomic, strong) UIImageView *imgView;
/**银行卡*/
@property (nonatomic, strong) UILabel *bankLbl;
/**到账时间*/
@property (nonatomic, strong) UILabel *timeLbl;

@end

@implementation JDInterface3TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellArr:(NSArray *)cellArr
{
    _cellArr = cellArr;
    
    self.imgView.image = [UIImage imageNamed:cellArr[0]];
    
    self.bankLbl.attributedText = [NSString attributedStringWithColorTitle:cellArr[2] normalTitle:@"" frontTitle:[NSString stringWithFormat:@"%@   ",cellArr[1]] normalColor:BlackNameColor diffentColor:BlackNameColor normalFont:kFont(14) differentFont:kFont(11)];
    
    self.timeLbl.text = cellArr[3];
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        
        _imgView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(kMargin);
            
        }];
    }
    return _imgView;
}

- (UILabel *)bankLbl
{
    if (!_bankLbl) {
        
        _bankLbl = [UILabel labelWithText:@"" font:kFont(14) textColor:BlackNameColor backGroundColor:ClearColor superView:self.contentView];
        
        [_bankLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(self.imgView.mas_right).mas_equalTo(kMargin);
            make.centerY.mas_equalTo(self.imgView.mas_centerY).mas_equalTo(-9);
            
        }];
    }
    return _bankLbl;
}

- (UILabel *)timeLbl
{
    if (!_timeLbl) {
        
        _timeLbl = [UILabel labelWithText:@"" font:kFont(11) textColor:BlackGrayColor backGroundColor:ClearColor superView:self.contentView];
        
        [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.imgView.mas_right).mas_equalTo(kMargin);
            make.centerY.mas_equalTo(self.imgView.mas_centerY).mas_equalTo(7.5);
        }];
    }
    return _timeLbl;
}
@end
