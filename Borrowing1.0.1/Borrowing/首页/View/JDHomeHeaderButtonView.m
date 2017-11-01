//
//  JDHomeHeaderButtonView.m
//  Borrowing
//
//  Created by Sierra on 2017/8/23.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDHomeHeaderButtonView.h"
#import "JDHomeHeaderButton.h"

@interface JDHomeHeaderButtonView ()

/**背景*/
@property (nonatomic, strong) UIView *bgView;


@end

@implementation JDHomeHeaderButtonView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

- (void)setIconArr:(NSArray<JDIcon_M *> *)iconArr
{
    _iconArr = iconArr;
    
    [self initSubviews];
}

- (void)initSubviews
{
    CGFloat buttonW = kWindowW*0.25;
    
    for (int i = 0; i < self.iconArr.count; i ++ ) {
        
        NSInteger  x = i / 4;
        NSInteger  y = i % 4;
        
        JDHomeHeaderButton *button = [[JDHomeHeaderButton alloc] initWithFrame:CGRectMake( buttonW*y, x * 85, buttonW, 85)];
        
        button.iconDic = self.iconArr[i];
        
        button.tag = 1000 + i;
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bgView addSubview:button];
    }
}


- (UIView *)bgView
{
    if (!_bgView) {
        
        _bgView = [UIView viewWithBackgroundColor:WhiteColor superView:self];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(0);
        }];
    }
    return _bgView;
}





- (void)buttonClick:(UIButton *)sender
{
    NZLog(@"%ld",(long)sender.tag)
    ;
    
    if ([self.delegate respondsToSelector:@selector(homeHeaderButtonViewDidButton:)]) {
        
        [self.delegate homeHeaderButtonViewDidButton:self.iconArr[sender.tag - 1000]];
    }
}


@end
