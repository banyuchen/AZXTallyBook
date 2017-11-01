//
//  JDInterfaceFooterView.h
//  Borrowing
//
//  Created by Sierra on 2017/8/22.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//借贷申请 footerView

#import <UIKit/UIKit.h>

@protocol JDInterfaceFooterViewDelegate <NSObject>

- (void)interfaceFooterViewDidGoBorrowBtn;

@end

@interface JDInterfaceFooterView : UIView

@property (nonatomic, weak) id<JDInterfaceFooterViewDelegate> delegate;

@end
