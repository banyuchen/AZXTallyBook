//
//  DDPCAView.m
//  DingTalent
//
//  Created by WenhuaLuo on 17/4/20.
//  Copyright © 2017年 Nado. All rights reserved.
//

#import "DDPCAView.h"
#import "PGPickerView.h"

@interface DDPCAView()<PGPickerViewDataSource, PGPickerViewDelegate>
{
    NSInteger _row1;
    
    NSInteger _row2;
    
    NSInteger _row3;
    
    NSInteger _maxSection;
}
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

/**<#name#>*/
@property (nonatomic, strong) PGPickerView *pickView;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) NSDictionary *selectDict;

@property (nonatomic, strong) NSArray *cityArr;

@end

@implementation DDPCAView

- (instancetype)initWithDelegate:(id/**PCAViewDelegate*/)delegate showSection:(NSInteger)section
{
    if (self = [super init]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"DDPCAView" owner:self options:nil] lastObject];
        
        self.pcaDelegate = delegate;
        
        _maxSection = section;
        
        
        PGPickerView *pickerView = [[PGPickerView alloc]initWithFrame:CGRectMake(0, 40, kWindowW, kPCAHeight - 40)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        
        [self addSubview:pickerView];
        
        self.pickView = pickerView;
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.frame = CGRectMake(0, kWindowH, kWindowW, kPCAHeight);
    
    
//    self.pickerView.delegate = self;
//    
//    self.pickerView.dataSource = self;
    
    self.selectDict = @{@"provinceID":@"", @"cityID":@"", @"areaID":@"", @"provinceName":@"", @"cityName":@"", @"areaName":@""};
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cityData" ofType:@"plist"];
    
    self.cityArr = [NSArray arrayWithContentsOfFile:filePath];
    
    
    if (self.cityArr) {
        
        NSDictionary *provinceDict = self.cityArr[0];
        
        NSDictionary *cityDict = provinceDict[@"citys"][0];
        
        NSDictionary *areaDict = cityDict[@"areas"][0];
        
        self.selectDict = @{
                            @"provinceID":provinceDict[@"provinceID"],
                            @"cityID":cityDict[@"cityID"],
                            @"areaID":areaDict[@"areaID"],
                            @"provinceName":provinceDict[@"province"],
                            @"cityName":cityDict[@"city"], @"areaName":areaDict[@"area"]
                            };
        
        _row1 = 0;
        _row2 = 0;
        _row3 = 0;
        
        [self.pickView reloadAllComponents];
    }
}


- (UIView *)coverView
{
    if (!_coverView) {
        
        _coverView= [UIView viewWithBackgroundColor:BlackColor superView:nil];
        
        _coverView.frame = APPDELEGATE.window.bounds;
        
        _coverView.alpha = 0.3;
        
        UITapGestureRecognizer *coverTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        
        [_coverView addGestureRecognizer:coverTap];
        
    }
    return _coverView;
}

- (void)show
{
    
    [APPDELEGATE.window addSubview:self.coverView];
    
    [APPDELEGATE.window addSubview:self];
    
    [UIView animateWithDuration:kShowDisTime animations:^{
        self.y = kWindowH - kPCAHeight;
    }];
    
}

- (void)dismiss
{
    
    [UIView animateWithDuration:kShowDisTime animations:^{
        
        self.y = kWindowH;
        
    } completion:^(BOOL finished) {
        
        [self.coverView removeFromSuperview];
        
        [self removeFromSuperview];
    }];
}



#pragma mark - pickerView


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _maxSection;//3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.cityArr count];
    }
    else if (component == 1) {
        
        NSArray *array = self.cityArr[_row1][@"citys"];
        
        if ([array isKindOfClass:[NSDictionary class]]) {
            return 1;
        }
        
        else if ((NSNull*)array != [NSNull null]) {
            
            return array.count;
        }
        return 0;
    }
    else {
        
        NSArray *array = self.cityArr[_row1][@"citys"];
        
        if ([array isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *cityDict = self.cityArr[_row1][@"citys"];
            return [cityDict[@"areas"] count];
        }
        else if ((NSNull*)array != [NSNull null]) {
            
            NSArray *array1 = array[_row2][@"areas"];
            
            if ((NSNull*)array1 != [NSNull null]) {
                return array1.count;
            }
            return 0;
        }
        return 0;
    }

}
//设置组件中每行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kWindowW / 2;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWindowW / 2, 35)];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];         //用label来设置字体大小
    
    if(component == 0) {
        label.text = self.cityArr[row][@"province"];
    }
    else if (component == 1)
    {
        NSArray *array = self.cityArr[_row1][@"citys"];
        
        if ([array isKindOfClass:[NSDictionary class]]) {
            
            label.text = self.cityArr[_row1][@"citys"][@"city"];
        }
        else
            label.text = array[row][@"city"];
    }
    else
    {
        NSArray *array = self.cityArr[_row1][@"citys"];
        
        if ([array isKindOfClass:[NSDictionary class]]) {
            
            NSArray *disArr = self.cityArr[_row1][@"citys"][@"areas"];
            
            label.text = disArr[row][@"area"];
        }
        else
            label.text = array[_row2][@"areas"][row][@"area"];
    }
    
    //  设置横线的颜色，实现显示或者隐藏
    ((UILabel *)[pickerView.subviews objectAtIndex:1]).backgroundColor = SeparatorCOLOR;
    
    ((UILabel *)[pickerView.subviews objectAtIndex:2]).backgroundColor = SeparatorCOLOR;
    
    
    return label;

}

- (nullable NSString *)pickerView:(PGPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWindowW / 2, 40)];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];         //用label来设置字体大小
    
    if(component == 0) {
        label.text = self.cityArr[row][@"province"];
    }
    else if (component == 1)
    {
        NSArray *array = self.cityArr[_row1][@"citys"];
        
        if ([array isKindOfClass:[NSDictionary class]]) {
            
            label.text = self.cityArr[_row1][@"citys"][@"city"];
        }
        else
            label.text = array[row][@"city"];
    }
    else
    {
        NSArray *array = self.cityArr[_row1][@"citys"];
        
        if ([array isKindOfClass:[NSDictionary class]]) {
            
            NSArray *disArr = self.cityArr[_row1][@"citys"][@"areas"];
            
            label.text = disArr[row][@"area"];
        }
        else
            label.text = array[_row2][@"areas"][row][@"area"];
    }
    
    
    return label.text;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _row1 = row;
        _row2 = 0;
        _row3 = 0;
        [self.pickView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        if (_maxSection > 2) {
            [self.pickView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
        
        
    }
    else if (component == 1){
        _row2 = row;
        _row3 = 0;
        
        if (_maxSection > 2) {
            [self.pickView reloadComponent:2];
        }
        
        
    }
    else {
        _row3 = row;
    }
    NSInteger city_row1 = [self.pickView selectedRowInComponent:0];
    
    NSInteger city_row2 = [self.pickView selectedRowInComponent:1];
    
    NSInteger city_row3 = _maxSection > 2 ? [self.pickView selectedRowInComponent:2] : 0;
    
    //获取的地址
    NSString *province = @"";
    NSString *city = @"";
    NSString *area = @"";
    
    NSMutableArray *idArr = [NSMutableArray array];
    
    province = self.cityArr[city_row1][@"province"];
    
    [idArr addObject:self.cityArr[city_row1][@"provinceID"]];
    
    
    if ([self.cityArr[city_row1][@"citys"] isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *cityDict = self.cityArr[city_row1][@"citys"];
        
        city = cityDict[@"city"];
        
        area = cityDict[@"areas"][city_row3][@"area"];
        
        [idArr addObject:cityDict[@"cityID"]];
        
        [idArr addObject:cityDict[@"areas"][city_row3][@"areaID"]];
    }
    else
    {
        NSArray *array = self.cityArr[city_row1][@"citys"];
        
        if ((NSNull*)array != [NSNull null]) {
            
            city = self.cityArr[city_row1][@"citys"][city_row2][@"city"];
            
            
            [idArr addObject:self.cityArr[city_row1][@"citys"][city_row2][@"cityID"]];
            
            
            NSArray *array1 = self.cityArr[city_row1][@"citys"][city_row2][@"areas"];
            
            if (((NSNull*)array1 != [NSNull null]) && array1) {
                
                area = array1[city_row3][@"area"];
                
                [idArr addObject:array1[city_row3][@"areaID"]];
            }
            
        }
        
    }
    
    if ([idArr count] > 2) {
        
        //NSLog(@"获取的城市名称－－－%@-----获取的城市id－－－－%@-%@-%@", str, idArr[0], idArr[1], idArr[2]);
        
        self.selectDict = @{@"provinceID":idArr[0], @"cityID":idArr[1], @"areaID":idArr[2], @"provinceName":province, @"cityName":city, @"areaName":area};
    }
    else
    {
        
        //NSLog(@"获取的城市名称－－－%@-----获取的城市id－－－－%@-%@", str, idArr[0], idArr[1]);
        NSLog(@"-----区没有数据");
        self.selectDict = @{@"provinceID":idArr[0], @"cityID":idArr[1], @"areaID":@"", @"provinceName":province, @"cityName":city, @"areaName":@""};
    }
    
    
}


#pragma mark - 点击确定按钮

- (IBAction)selectFinish:(UIButton *)sender {
    
    
    if ([self.pcaDelegate respondsToSelector:@selector(pcaViewDidSelectResult:)]) {
        [self.pcaDelegate pcaViewDidSelectResult:self.selectDict];
    }
    
    [self dismiss];
}

@end
