//
//  ActionSheetTableView.m
//  DingDing
//
//  Created by WenhuaLuo on 16/12/7.
//  Copyright © 2016年 Meity. All rights reserved.
//

#import "ActionSheetTableView.h"
#import "ActionSheetTableCell.h"




@interface ActionSheetTableView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *titlesArr;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, assign) CGFloat showHeight;

@property (nonatomic, copy) NSString *keyTag;
@end

@implementation ActionSheetTableView


- (instancetype)initWithActionDelegate:(id /**<ActionSheetTableViewDelegate>*/)delegate
{
    self = [super init];
    
    if ( self )
    {
        self.actionDelegate = delegate;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.delegate = self;
        
        self.dataSource = self;
        
        //self.scrollEnabled = NO;
        
        UIView *coverView = [UIView viewWithBackgroundColor:BlackColor superView:nil];
        
        coverView.frame = APPDELEGATE.window.bounds;
        
        coverView.alpha = 0.3;
        
        UITapGestureRecognizer *coverTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        
        [coverView addGestureRecognizer:coverTap];
        
        self.coverView = coverView;
        

    }
    return self;
}

- (void)actionSheetWithTitles:(NSArray *)titles frame:(CGRect)frame keyTag:(NSString *)keyTag headView:(UIView *)headView
{
    if (headView) {
        self.tableHeaderView = headView;
    }
    
    self.titlesArr = titles;
    
    self.frame = frame;
    
    self.showHeight = frame.size.height;
    
    self.keyTag = keyTag;
    
    [self reloadData];
}


- (void)show
{
    
    [APPDELEGATE.window addSubview:self.coverView];
    
    [APPDELEGATE.window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.y = ScreenHeight - self.showHeight;
    }];
    
}

- (void)dismiss
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.y = ScreenHeight;
        
    } completion:^(BOOL finished) {
        
        [self.coverView removeFromSuperview];
        
        [self removeFromSuperview];
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titlesArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ActionSheetTableCell *cell = [ActionSheetTableCell jobListCellWithTableView:tableView];
    
    id title = self.titlesArr[indexPath.row];
    
    if ([title isKindOfClass:[NSDictionary class]]) {
        cell.job = title[@"name"];
    }
    else
        cell.job = self.titlesArr[indexPath.row];
    
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.contentView.bounds];
    
    cell.titleLbl.highlightedTextColor = ThemeColor;
    
    cell.titleLbl.textColor = RGBCOLOR(120, 120, 120);
    
    cell.titleLbl.width = ScreenWidth;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.actionDelegate respondsToSelector:@selector(actionSheetDidSelectRow:keyTag:)]) {
        [self.actionDelegate actionSheetDidSelectRow:self.titlesArr[indexPath.row] keyTag:self.keyTag];
    }
    
    [self dismiss];
}

@end
