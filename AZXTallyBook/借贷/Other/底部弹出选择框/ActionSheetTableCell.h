//
//  ActionSheetTableCell.h
//  DingDing
//
//  Created by WenhuaLuo on 16/12/7.
//  Copyright © 2016年 Meity. All rights reserved.
//

#import <UIKit/UIKit.h>

//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ActionSheetTableCell : UITableViewCell

+ (instancetype)jobListCellWithTableView:(UITableView *)tableView;


@property (nonatomic, weak) UILabel *titleLbl;

@property (nonatomic, copy) NSString *job;

@end
