//
//  ActionSheetTableCell.m
//  DingDing
//
//  Created by WenhuaLuo on 16/12/7.
//  Copyright © 2016年 Meity. All rights reserved.
//

#import "ActionSheetTableCell.h"

@interface ActionSheetTableCell()

@end

@implementation ActionSheetTableCell

+ (instancetype)jobListCellWithTableView:(UITableView *)tableView
{
    static NSString *jobListID = @"jobList";
    
    ActionSheetTableCell *cell = [tableView dequeueReusableCellWithIdentifier:jobListID];
    
    if (cell == nil) {
        cell = [[ActionSheetTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:jobListID];
    }
    else
    {
        [cell removeFromSuperview];
        cell = [[ActionSheetTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:jobListID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titleLbl = [UILabel labelWithText:@"" font:[UIFont systemFontOfSize:15] textColor:ThemeColor backGroundColor:ClearColor superView:self];
        
        self.titleLbl.highlightedTextColor = WhiteColor;
        
        CGFloat leftM = 80;
        
        CGFloat width = ScreenWidth - 2 * leftM;
        
        self.titleLbl.frame = CGRectMake(0, 0, width, 44);
        
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setJob:(NSString *)job
{
    _job = job;
    
    self.titleLbl.text = job;
}

@end
