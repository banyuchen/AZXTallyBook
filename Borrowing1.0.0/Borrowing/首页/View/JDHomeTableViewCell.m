//
//  JDHomeTableViewCell.m
//  Borrowing
//
//  Created by Sierra on 2017/8/25.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDHomeTableViewCell.h"


#pragma mark -------------------------------------------------------信用卡&&保险--------------------------------------------------------------------------
@interface JDHomeTableViewCell ()

/**cell背景*/
@property (nonatomic, strong) UIView *bgView;

/**商品图片*/
@property (nonatomic, strong) UIImageView *productImgView;
/**商品名*/
@property (nonatomic, strong) UILabel *productNameLbl;
/**亮点*/
@property (nonatomic, strong) UILabel *tagLbl;
/**优势说明*/
@property (nonatomic, strong) UILabel *advantageLbl;

@end

@implementation JDHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    
    [self.productImgView sd_setImageWithURL:[NSURL URLWithString:@"http://www.33lc.com/article/UploadPic/2012-9/20129299251882758.jpg"]];
    
    self.productNameLbl.text = @"光大银行信用卡";
    
    [self tagLbl];
    
    self.advantageLbl.text = @"5分钟急速办卡，刷卡满额送豪礼";
    
}

- (void)setProductDic:(JDProduct_M *)productDic
{
    _productDic = productDic;
    
    [self.productImgView sd_setImageWithURL:[NSURL URLWithString:productDic.productImg]];
    
    self.productNameLbl.text = productDic.productName;
    
    self.tagLbl.text = productDic.highlights;
    
    self.advantageLbl.text = productDic.productCharacteristic;
}

- (UIView *)bgView
{
    if (!_bgView) {
        
        _bgView = [UIView viewWithBackgroundColor:WhiteColor superView:self.contentView];
        
        _bgView.layer.cornerRadius = 4;
        
        _bgView.layer.masksToBounds = YES;
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.top.mas_equalTo(8);
            make.size.mas_equalTo(CGSizeMake(kWindowW - 16, 120));
        }];
    }
    return _bgView;
}

- (UIImageView *)productImgView
{
    if (!_productImgView) {
        
        UIView *view = [UIView viewWithBackgroundColor:ClearColor superView:self.bgView];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.mas_equalTo(0);
            make.width.mas_equalTo(92);
            make.height.mas_equalTo(118);
        }];
        
        _productImgView = [[UIImageView alloc] init];
        
        _productImgView.contentMode = UIViewContentModeScaleAspectFit;
        
        _productImgView.clipsToBounds = YES;
        
        _productImgView.layer.masksToBounds = YES;
        
        _productImgView.layer.cornerRadius = 6;
        
        [view addSubview:_productImgView];
        
        [_productImgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.centerX.mas_equalTo(0);
            make.width.height.mas_equalTo(80);
        }];
        
        UIView *line = [UIView viewWithBackgroundColor:[XMToolClass getColorWithHexString:@"e5e5e5"] superView:self.bgView];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(kMargin);
            make.bottom.mas_equalTo(_productImgView.mas_bottom).mas_equalTo(-kMargin+14);
            make.left.mas_equalTo(92 + 6);
            make.width.mas_equalTo(0.5);
        }];
    }
    return _productImgView;
}

- (UILabel *)productNameLbl
{
    if (!_productNameLbl) {
        
        _productNameLbl = [UILabel labelWithText:@"" font:kFont(18) textColor:BlackNameColor backGroundColor:ClearColor superView:self.bgView];
        
        _productNameLbl.font = [UIFont systemFontOfSize:18 weight:UIFontWeightThin];
        
        [_productNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(92 + 6 + kMargin);
            make.top.mas_equalTo(kMargin);
        }];
    }
    return _productNameLbl;
}

- (UILabel *)tagLbl
{
    if (!_tagLbl) {
        
        _tagLbl = [UILabel labelWithText:@"" font:kFont(15) textColor:[XMToolClass getColorWithHexString:@"ff7f66"] backGroundColor:ClearColor superView:self.bgView];
        
        [_tagLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(self.productImgView.mas_centerY);
            make.left.mas_equalTo(self.productNameLbl.mas_left);
        }];
    }
    return _tagLbl;
}

- (UILabel *)advantageLbl
{
    if (!_advantageLbl) {
        
        _advantageLbl = [UILabel labelWithText:@"" font:kFont(14) textColor:GrayContentColor backGroundColor:ClearColor superView:self.bgView];
        
        _advantageLbl.numberOfLines = 1;
        
        [_advantageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.mas_equalTo(-kMargin);
            make.bottom.mas_equalTo(self.productImgView.mas_bottom).mas_equalTo(-kMargin+14);
            make.left.mas_equalTo(self.productNameLbl.mas_left);
        }];
    }
    return _advantageLbl;
}
@end

#pragma mark -------------------------------------------------------借贷cell--------------------------------------------------------------------------

@interface JDHomeBrowingTableViewCell ()

/**cell背景*/
@property (nonatomic, strong) UIView *bgView;

/**商品图片*/
@property (nonatomic, strong) UIImageView *productImgView;
/**商品名*/
@property (nonatomic, strong) UILabel *productNameLbl;

/**线条*/
@property (nonatomic, strong) UIView *line;

/**最高额度*/
@property (nonatomic, strong) UILabel *maximaLoanLbl;
/**日利率*/
@property (nonatomic, strong) UILabel *dailyRateLbl;
/**已放款*/
@property (nonatomic, strong) UILabel *securedLoanLbl;
/**描述*/
@property (nonatomic, strong) UILabel *productDesLbl;

@end

@implementation JDHomeBrowingTableViewCell


- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    
    
    [self.productImgView sd_setImageWithURL:[NSURL URLWithString:@"http://www.33lc.com/article/UploadPic/2012-9/20129299251882758.jpg"]];
    
    self.productNameLbl.text = @"光大银行信用卡";
    
    
}

- (void)setProductDic:(JDProduct_M *)productDic
{
    _productDic = productDic;
    
    [self.productImgView sd_setImageWithURL:[NSURL URLWithString:productDic.productImg]];
    
    self.productNameLbl.text = productDic.productName;
    
    self.maximaLoanLbl.attributedText = [NSString attributedStringWithColorTitle:@"最高额度" normalTitle:[NSString stringWithFormat:@"%@元",productDic.endLoanMoney] frontTitle:@"" diffentColor:BlackNameColor];
    
    NSString *interestRateDayStr = [NSString stringWithFormat:@"%.2f",[productDic.interestRateDay floatValue]];
    self.dailyRateLbl.text = [NSString stringWithFormat:@"日利率低至%@%%",interestRateDayStr];
    
    self.securedLoanLbl.text = [NSString stringWithFormat:@"%@人已放款",productDic.securedLoan];
    
    self.productDesLbl.text = productDic.productCharacteristic;
}

- (UIView *)bgView
{
    if (!_bgView) {
        
        _bgView = [UIView viewWithBackgroundColor:WhiteColor superView:self.contentView];
        
        _bgView.layer.cornerRadius = 4;
        
        _bgView.layer.masksToBounds = YES;
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.mas_equalTo(8);
            make.size.mas_equalTo(CGSizeMake(kWindowW - 16, 120));
        }];
    }
    return _bgView;
}

- (UIImageView *)productImgView
{
    if (!_productImgView) {
        
        _productImgView = [[UIImageView alloc] init];
        
        [self.bgView addSubview:_productImgView];
        
        _productImgView.contentMode = UIViewContentModeScaleAspectFill;
        
        _productImgView.clipsToBounds = YES;
        
        _productImgView.layer.masksToBounds = YES;
        
        _productImgView.layer.cornerRadius = 6;
        
        [_productImgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.size.mas_equalTo(CGSizeMake(50, 50));
            
            make.left.mas_equalTo(22);
            
            make.top.mas_equalTo(18);
        }];
        
    }
    return _productImgView;
}


- (UIView *)line
{
    if (!_line) {
        
        _line = [UIView viewWithBackgroundColor:[XMToolClass getColorWithHexString:@"e5e5e5"] superView:self.bgView];
        
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.productImgView.mas_right).mas_equalTo(26);
            make.top.mas_equalTo(kMargin);
            make.bottom.mas_equalTo(-kMargin);
            make.width.mas_equalTo(0.5);
        }];
    }
    return _line;
}

- (UILabel *)productNameLbl
{
    if (!_productNameLbl) {
        
        _productNameLbl = [UILabel labelWithText:@"" font:kFont(13) textColor:BlackContentColor backGroundColor:ClearColor superView:self.bgView];
        
        [_productNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(self.productImgView.mas_centerX);
            make.top.mas_equalTo(self.productImgView.mas_bottom).mas_equalTo(10);
        }];
    }
    return _productNameLbl;
}

- (UILabel *)maximaLoanLbl
{
    if (!_maximaLoanLbl) {
        
        _maximaLoanLbl = [UILabel labelWithText:@"" font:kFont(18) textColor:RGBCOLOR(60, 145, 251) backGroundColor:ClearColor superView:self.bgView];
        
        _maximaLoanLbl.font = [UIFont systemFontOfSize:18 weight:UIFontWeightThin];
        
        [_maximaLoanLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(kMargin);
            make.left.mas_equalTo(self.line.mas_right).mas_equalTo(kMargin);
            
        }];
    }
    return _maximaLoanLbl;
}

- (UILabel *)dailyRateLbl
{
    if (!_dailyRateLbl) {
        
        _dailyRateLbl = [UILabel labelWithText:@"" font:kFont(14) textColor:BlackContentColor backGroundColor:ClearColor superView:self.bgView];
        
        [_dailyRateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.mas_equalTo(2.5);
            make.left.mas_equalTo(self.maximaLoanLbl.mas_left);
        }];
    }
    return _dailyRateLbl;
}

- (UILabel *)securedLoanLbl
{
    if (!_securedLoanLbl) {
        
        _securedLoanLbl = [UILabel labelWithText:@"" font:kFont(14) textColor:BlackContentColor backGroundColor:ClearColor superView:self.bgView];
        
        [_securedLoanLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.mas_equalTo(-kMargin);
            make.centerY.mas_equalTo(2.5);
        }];
    }
    return _securedLoanLbl;
}

- (UILabel *)productDesLbl
{
    if (!_productDesLbl) {
        
        _productDesLbl = [UILabel labelWithText:@"" font:kFont(13) textColor:GrayContentColor backGroundColor:ClearColor superView:self.bgView];
        
        _productDesLbl.numberOfLines = 1;
        
        [_productDesLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.mas_equalTo(-kMargin);
            make.left.mas_equalTo(self.maximaLoanLbl.mas_left);
            make.bottom.mas_equalTo(-kMargin);
        }];
    }
    return _productDesLbl;
}

@end
