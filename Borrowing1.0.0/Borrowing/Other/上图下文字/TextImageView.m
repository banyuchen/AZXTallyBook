//
//  TextImageView.m
//  NDBaseProject
//
//  Created by WenhuaLuo on 17/6/1.
//  Copyright © 2017年 WenhuaLuo. All rights reserved.
//

#import "TextImageView.h"

@interface TextImageView()
{
    NSString *_title;
    NSString *_imageName;
    UIFont *_titleFont;
    UIColor *_titleColor;
    NSString *_keyTag;
    
    UIColor *_numColor;
}


@property (nonatomic, strong) UILabel *numLbl;

@end

@implementation TextImageView

- (void)viewWithImageName:(NSString *)image title:(NSString *)title tag:(NSString *)keyTag titleFont:(UIFont *)font titleColor:(UIColor *)color
{
    _title = title;
    _imageName = image;
    _titleFont = font;
    _titleColor = color;
    _keyTag = keyTag;
    
    [self tipLbl];
    [self topImg];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickEvent)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;

}

- (void)clickEvent
{
    if (_textImageBlock) {
        _textImageBlock(_keyTag);
    }
}

- (UILabel *)tipLbl
{
    if (!_tipLbl) {
        
        _tipLbl = [UILabel labelWithText:_title font:_titleFont textColor:_titleColor backGroundColor:ClearColor superView:self];
        
        _tipLbl.textAlignment = NSTextAlignmentCenter;
        
        [_tipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.bottom.mas_equalTo(-kMargin);
            make.centerX.mas_equalTo(0);
            
        }];
        
    }
    return _tipLbl;
}

- (UIImageView *)topImg
{
    if (!_topImg) {
        
        _topImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_imageName]];
        
        [self addSubview:_topImg];
        
        [_topImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(_topImg.image.size);
            make.bottom.mas_equalTo(self.tipLbl.mas_top).mas_equalTo(-8);
        }];
        
    }
    return _topImg;
}

- (UILabel *)numLbl
{
    if (!_numLbl) {
        
        _numLbl = [UILabel labelWithText:@"" font:kFont(10) textColor:_numColor backGroundColor:ClearColor superView:self];
        
        _numLbl.textAlignment = NSTextAlignmentCenter;
        
        [_numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.topImg.mas_right);
            make.centerY.mas_equalTo(self.topImg.mas_top);
            make.height.mas_equalTo(14);
            make.width.mas_equalTo(14);
        }];
        
        _numLbl.layer.cornerRadius = 7;
        _numLbl.layer.borderColor = _numColor.CGColor;
        _numLbl.layer.borderWidth = 0.5;
        _numLbl.clipsToBounds = YES;
    }
    return _numLbl;
}

- (void)viewWithNum:(NSInteger)num numColor:(UIColor *)color
{
    _numColor = color;
    
    self.numLbl.hidden = num < 1;
    self.numLbl.text = num<100 ? [NSString stringWithFormat:@"%zd", num] : @"99+";
    
    CGFloat width = [NSString sizeWithText:self.numLbl.text font:self.numLbl.font maxSize:CGSizeMake(MAXFLOAT, 14)].width;
    
    if (width > 14) {
        [self.numLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width+8);
        }];
    }
}

@end
