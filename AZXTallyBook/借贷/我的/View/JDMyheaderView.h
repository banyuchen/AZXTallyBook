//
//  JDMyheaderView.h
//  Borrowing
//
//  Created by Sierra on 2017/8/28.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JDMyheaderViewDelegate <NSObject>

- (void)myheaderViewDidSelectLogoInBtn;

@end

@interface JDMyheaderView : UIView

/**数据源*/
@property (nonatomic, strong) DBAccount *account;

/**数据源*/
@property (nonatomic, strong) NSArray *arrDic;

/**<#name#>*/
@property (nonatomic, weak) id<JDMyheaderViewDelegate> delegate;
@end
