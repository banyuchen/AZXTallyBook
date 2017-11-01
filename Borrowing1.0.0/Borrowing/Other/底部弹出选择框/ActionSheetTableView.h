//
//  ActionSheetTableView.h
//  DingDing
//
//  Created by WenhuaLuo on 16/12/7.
//  Copyright © 2016年 Meity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActionSheetTableViewDelegate <NSObject>

- (void)actionSheetDidSelectRow:(id)result keyTag:(NSString *)keyTag;

@end

@interface ActionSheetTableView : UITableView

- (instancetype)initWithActionDelegate:(id /**<ActionSheetTableViewDelegate>*/)delegate;

- (void)actionSheetWithTitles:(NSArray *)titles frame:(CGRect)frame keyTag:(NSString *)keyTag headView:(UIView *)headView;

//更换之前的数组
//@property (nonatomic, strong) NSArray *actionTitleArr;

@property(nonatomic,weak) id<ActionSheetTableViewDelegate> actionDelegate;

- (void)show;

- (void)dismiss;

@end
