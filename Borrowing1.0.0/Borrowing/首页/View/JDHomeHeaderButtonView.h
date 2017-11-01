//
//  JDHomeHeaderButtonView.h
//  Borrowing
//
//  Created by Sierra on 2017/8/23.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDIcon_M.h"

@protocol JDHomeHeaderButtonViewDelegate <NSObject>

- (void)homeHeaderButtonViewDidButton:(JDIcon_M *)icon;

@end

@interface JDHomeHeaderButtonView : UIView


/**icon*/
@property (nonatomic, strong) NSArray <JDIcon_M *> *iconArr;

/**<#name#>*/
@property (nonatomic, weak) id<JDHomeHeaderButtonViewDelegate> delegate;

@end
