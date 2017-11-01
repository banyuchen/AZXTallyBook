//
//  JDProductDetailHeaderView.m
//  Borrowing
//
//  Created by Sierra on 2017/9/4.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDProductDetailHeaderView.h"
#import "JDDetailLblView.h"

@interface JDProductDetailHeaderView ()

/**商家*/
@property (nonatomic, strong) UIView *productHeaderView;

/**商家图标*/
@property (nonatomic, strong) UIImageView *productImgView;
/**商家名*/
@property (nonatomic, strong) UILabel *productNameLbl;
/**商家说明*/
@property (nonatomic, strong) UILabel *productCharacteristicLbl;

/**线条1*/
@property (nonatomic, strong) UIView *line1;

/**可贷额度*/
@property (nonatomic, strong) JDDetailLblView *loanMoneyView;
/**日利率*/
@property (nonatomic, strong) JDDetailLblView *interestRateDayView;
/**已经放款*/
@property (nonatomic, strong) JDDetailLblView *securedLoanView;
/**成功率*/
@property (nonatomic, strong) JDDetailLblView *successRateView;
/**可贷款期限*/
@property (nonatomic, strong) JDDetailLblView *loanTimeView;

/**线条2*/
@property (nonatomic, strong) UIView *line2;

/**产品介绍*/
@property (nonatomic, strong) UILabel *productDescripLbl;

/**线条三*/
@property (nonatomic, strong) UIView *line3;

@end

@implementation JDProductDetailHeaderView

- (void)setProduct:(JDProduct_M *)product
{
    _product = product;
    
    [self.productImgView sd_setImageWithURL:[NSURL URLWithString:product.productImg]];
    
    self.productNameLbl.text = product.productName;
    
    self.productCharacteristicLbl.text = product.productCharacteristic;
    
    [self line1];
    
    JDDetailLblViewModel *loanMoneyM = [[JDDetailLblViewModel alloc] init];
    loanMoneyM.detailTitle = @"可贷款额度";
    loanMoneyM.descStr = [NSString stringWithFormat:@"%@-%@",product.startLoanMoney,product.endLoanMoney];
    loanMoneyM.unitStr = @"元";
    self.loanMoneyView.detailModel = loanMoneyM;
    
    JDDetailLblViewModel *interestRateDayM = [[JDDetailLblViewModel alloc] init];
    interestRateDayM.detailTitle = @"日利率低至";
    NSString *interestRateDayStr = [NSString stringWithFormat:@"%.2f",[product.interestRateDay floatValue]];
    interestRateDayM.descStr = interestRateDayStr;
    interestRateDayM.unitStr = @"%";
    self.interestRateDayView.detailModel = interestRateDayM;
    
    JDDetailLblViewModel *securedLoanM = [[JDDetailLblViewModel alloc] init];
    securedLoanM.detailTitle = @"已放款";
    securedLoanM.descStr = product.securedLoan;
    securedLoanM.unitStr = @"人";
    self.securedLoanView.detailModel = securedLoanM;
    
    JDDetailLblViewModel *successRateM = [[JDDetailLblViewModel alloc] init];
    successRateM.detailTitle = @"成功率";
    successRateM.descStr = product.successRate;
    successRateM.unitStr = @"%";
    self.successRateView.detailModel = successRateM;
    
    
    JDDetailLblViewModel *loanTimeM = [[JDDetailLblViewModel alloc] init];
    loanTimeM.detailTitle = @"可贷期限";
    loanTimeM.descStr = [NSString stringWithFormat:@"%@-%@",product.startLoanTime,product.endLoanTime];
    loanTimeM.unitStr = @"个月";
    self.loanTimeView.detailModel = loanTimeM;
    
    [self line3];
}


#pragma mark - 懒加载
- (UIView *)productHeaderView
{
    if (!_productHeaderView) {
        
        _productHeaderView = [UIView viewWithBackgroundColor:WhiteColor superView:self];
        
        [_productHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.top.mas_equalTo(0);
            make.width.mas_equalTo(kWindowW);
            make.height.mas_equalTo(75);
        }];
    }
    return _productHeaderView;
}


- (UIImageView *)productImgView
{
    if (!_productImgView) {
        
        _productImgView = [[UIImageView alloc] init];
        
        [self.productHeaderView addSubview:_productImgView];
        
        _productImgView.layer.masksToBounds = YES;
        
        _productImgView.layer.cornerRadius = 6;
        
        [_productImgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(18);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    return _productImgView;
}

- (UILabel *)productNameLbl
{
    if (!_productNameLbl) {
        
        _productNameLbl = [UILabel labelWithText:@"" font:kFont(16) textColor:RGBCOLOR(51, 51, 51) backGroundColor:ClearColor superView:self.productHeaderView];
        
        [_productNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(self.productImgView.mas_right).mas_equalTo(kMargin);
            make.top.mas_equalTo(self.productImgView.mas_top);
        }];
    }
    return _productNameLbl;
}

- (UILabel *)productCharacteristicLbl
{
    if (!_productCharacteristicLbl) {
        
        _productCharacteristicLbl = [UILabel labelWithText:@"" font:kFont(12) textColor:RGBCOLOR(183,183,183) backGroundColor:ClearColor superView:self.productHeaderView];
        
        _productCharacteristicLbl.numberOfLines = 2;
        
        [_productCharacteristicLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(self.productNameLbl.mas_bottom).mas_equalTo(5);
            make.right.mas_equalTo(-kMargin);
            make.left.mas_equalTo(self.productImgView.mas_right).mas_equalTo(kMargin);
            
        }];
    }
    return _productCharacteristicLbl;
}

- (UIView *)line1
{
    if (!_line1) {
        
        _line1 = [UIView viewWithBackgroundColor:SeparatorCOLOR superView:self.productHeaderView];
        
        [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(kMargin);
            make.right.mas_equalTo(-kMargin);
            
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _line1;
}


- (JDDetailLblView *)loanMoneyView
{
    if (!_loanMoneyView) {
        
        _loanMoneyView = [[JDDetailLblView alloc] init];
        
        [self addSubview:_loanMoneyView];
        
        [_loanMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.productHeaderView.mas_bottom).mas_equalTo(21);
            
            make.width.mas_equalTo(kWindowW*0.5 - 20);
            make.height.mas_equalTo(39);
        }];
    }
    return _loanMoneyView;
}

- (JDDetailLblView *)interestRateDayView
{
    if (!_interestRateDayView) {
        
        _interestRateDayView = [[JDDetailLblView alloc] init];
        
        [self addSubview:_interestRateDayView];
        
        [_interestRateDayView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(kWindowW*0.5 - kMargin);
//            make.right.mas_equalTo(-kMargin);
            
            make.width.mas_equalTo(kWindowW *0.5 -2*kMargin);
            make.top.mas_equalTo(self.loanMoneyView.mas_top);
            make.height.mas_equalTo(self.loanMoneyView.mas_height);
        }];
    }
    return _interestRateDayView;
}


- (JDDetailLblView *)securedLoanView
{
    if (!_securedLoanView) {
        
        _securedLoanView = [[JDDetailLblView alloc] init];
        
        [self addSubview:_securedLoanView];
        
        [_securedLoanView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.loanMoneyView.mas_bottom).mas_equalTo(29);
            
            make.width.mas_equalTo(kWindowW*0.5 - 20);
            make.height.mas_equalTo(39);
            
        }];
    }
    return _securedLoanView;
}

- (JDDetailLblView *)successRateView
{
    if (!_successRateView) {
        
        _successRateView = [[JDDetailLblView alloc] init];
        
        [self addSubview:_successRateView];
        
        [_successRateView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(kWindowW*0.5 - kMargin);
//            make.right.mas_equalTo(-kMargin);
            make.width.mas_equalTo(kWindowW *0.5 -2*kMargin);
            make.top.mas_equalTo(self.securedLoanView.mas_top);
            make.height.mas_equalTo(self.loanMoneyView.mas_height);
        }];
    }
    return _successRateView;
}

- (JDDetailLblView *)loanTimeView
{
    if (!_loanTimeView) {
        
        _loanTimeView = [[JDDetailLblView alloc] init];
        
        [self addSubview:_loanTimeView];
        
        [_loanTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.securedLoanView.mas_bottom).mas_equalTo(29);
            
            make.width.mas_equalTo(kWindowW*0.5 - 20);
            make.height.mas_equalTo(39);
        }];
    }
    return _loanTimeView;
}

- (UIView *)line2
{
    if (!_line2) {
        
        _line2 = [UIView viewWithBackgroundColor:RGBCOLOR(244,244,248) superView:self];
        
        [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(5);
            
            make.top.mas_equalTo(self.loanTimeView.mas_bottom).mas_equalTo(21);
            
        }];
    }
    return _line2;
}


- (UILabel *)productDescripLbl
{
    if (!_productDescripLbl) {
        
        _productDescripLbl = [UILabel labelWithText:@"产品介绍" font:kFont(16) textColor:BlackGrayColor backGroundColor:ClearColor superView:self];
        
        [_productDescripLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(self.line2.mas_bottom).mas_equalTo(10);
            make.centerX.mas_equalTo(0);
            
        }];
        
        UIView *line1 = [UIView viewWithBackgroundColor:[XMToolClass getColorWithHexString:@"999999"] superView:self];
        
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(_productDescripLbl.mas_left).mas_equalTo(-8);
            make.centerY.mas_equalTo(_productDescripLbl.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(33, 0.5));
        }];
        
        
        UIView *line2 = [UIView viewWithBackgroundColor:[XMToolClass getColorWithHexString:@"999999"] superView:self];
        
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(_productDescripLbl.mas_right).mas_equalTo(8);
            make.centerY.mas_equalTo(_productDescripLbl.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(33, 0.5));
        }];
    }
    return _productDescripLbl;
}

- (UIView *)line3
{
    if (!_line3) {
        
        _line3 = [UIView viewWithBackgroundColor:SeparatorCOLOR superView:self];
        
        [_line3 mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            
            make.top.mas_equalTo(self.productDescripLbl.mas_bottom).mas_equalTo(10);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _line3;
}

@end
