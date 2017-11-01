//
//  JDMyheaderView.m
//  Borrowing
//
//  Created by Sierra on 2017/8/28.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDMyheaderView.h"

@interface JDMyheaderView ()

/**背景*/
@property (nonatomic, strong) UIImageView *bgImgView;

/**头像*/
@property (nonatomic, strong) UIImageView *avatarImgView;

//未登录
/**立即登录*/
@property (nonatomic, strong) UIButton *logoInBtn;

//登录后
/**昵称*/
@property (nonatomic, strong) UILabel *niceLbl;

@end

@implementation JDMyheaderView


#pragma mark - 立即登录
- (void)logoInBtnClick
{
    if ([self.delegate respondsToSelector:@selector(myheaderViewDidSelectLogoInBtn)]) {
        
        [self.delegate myheaderViewDidSelectLogoInBtn];
    }
}

- (void)setAccount:(DBAccount *)account
{
    _account = account;
    
    if (![XMToolClass isBlankString:account.ID]) {
        
        //登录状态
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:account.face]];
        
        self.niceLbl.text = account.nickname;
    }else{
        
        //未登录状态
        self.avatarImgView.image = [UIImage imageNamed:@"mine_default"];
        
        [self logoInBtn];
    }
}


- (UIImageView *)bgImgView
{
    if (!_bgImgView) {
        
        _bgImgView = [[UIImageView alloc] init];
        
        _bgImgView.image = [UIImage imageNamed:@"mine_bg"];
        
        _bgImgView.userInteractionEnabled = YES;
        
        [self addSubview:_bgImgView];
        
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.mas_equalTo(0);
        }];
    }
    return _bgImgView ;
}

- (UIImageView *)avatarImgView
{
    if (!_avatarImgView) {
        
        _avatarImgView = [[UIImageView alloc] init];
        
        _avatarImgView.layer.cornerRadius = 30;
        
        _avatarImgView.layer.masksToBounds = YES;
        
        [self.bgImgView addSubview:_avatarImgView];
        
        [_avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.mas_equalTo(-25);
            make.centerX.mas_equalTo(0);
            
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    }
    return _avatarImgView;
}


- (UIButton *)logoInBtn
{
    if (!_logoInBtn) {
        
        _logoInBtn = [UIButton buttonWithTitle:@"立即登录" font:kFont(14) titleColor:BlackGrayColor backGroundColor:WhiteColor buttonTag:0 target:self action:@selector(logoInBtnClick) showView:self.bgImgView];
        
        _logoInBtn.layer.cornerRadius = 12.5;
        
        _logoInBtn.layer.masksToBounds = YES;
        
        _logoInBtn.layer.borderColor = BlackGrayColor.CGColor;
        
        _logoInBtn.layer.borderWidth = 0.5;
        
        [_logoInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(27.5);
            
            make.size.mas_equalTo(CGSizeMake(90, 25));
        }];
    }
    return _logoInBtn;
}


- (UILabel *)niceLbl
{
    if (!_niceLbl) {
        
        _niceLbl = [UILabel labelWithText:@"" font:kFont(14) textColor:BlackGrayColor backGroundColor:ClearColor superView:self.bgImgView];
        
        [_niceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(35);
            
        }];
    }
    return _niceLbl;
}
@end
