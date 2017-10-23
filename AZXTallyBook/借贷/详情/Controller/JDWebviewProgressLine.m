//
//  JDWebviewProgressLine.m
//  Borrowing
//
//  Created by Sierra on 2017/9/26.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDWebviewProgressLine.h"

@implementation JDWebviewProgressLine

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.backgroundColor = lineColor;
}

-(void)startLoadingAnimation{
    self.hidden = NO;
    self.width = 0.0;
    
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        weakSelf.width = kWindowW * 0.6;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.width = kWindowW * 0.8;
        }];
    }];
    
    
}

-(void)endLoadingAnimation{
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.width = kWindowW;
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
}


@end
