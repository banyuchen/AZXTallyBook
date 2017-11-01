//
//  JDHomeHeaderButton.m
//  Borrowing
//
//  Created by Sierra on 2017/8/23.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDHomeHeaderButton.h"

@implementation JDHomeHeaderButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setTitleColor:RGBCOLOR(124, 124, 124) forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.y = self.height * 0.10;
    self.imageView.height = self.height * 0.5;
    self.imageView.width = self.imageView.height;
    self.imageView.centerX = self.width * 0.5;
    
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.bottom;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}



- (void)setIconDic:(JDIcon_M *)iconDic
{
    _iconDic = iconDic;
    
    [self setTitle:iconDic.productTypeName forState:UIControlStateNormal];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
        
        [cachePath stringByAppendingPathComponent:@"imageCache"];
        
        NSString *imagePath = [NSString stringWithFormat:@"%@/%lu", cachePath, (unsigned long)[iconDic.images hash]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSData *da = nil;
        // 判断一下图片在本地在不在
        if ([fileManager fileExistsAtPath:imagePath]) {
            // 如果在, 直接就取
            da = [NSData dataWithContentsOfFile:imagePath];
        }else {
            // 如果不在, 就重新下载(self.theExhib.worksPic是网址)
            da = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconDic.images]];
            // 把图片流写入本地
            [da writeToFile:imagePath atomically:YES];
        }
        
        // 把NSData流转化成UIImage对象
        UIImage *ima = [UIImage imageWithData:da];
        // 调用自己的方法imageWithImageSimple scaldToSize: (Size后面填写的你要缩小成的图片分辨率)
        ima = [self imageWithImageSimple:ima scaledToSize:CGSizeMake(100, 100)];
        // 回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            [self.avatarImgView setImage:ima];
            
            
            [self setImage:ima forState:UIControlStateNormal];
            
            [self setImage:ima forState:UIControlStateSelected];
        });
        
    });
    
    
}


- (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext (newSize);
    [image drawInRect : CGRectMake ( 0 , 0 ,newSize. width ,newSize. height )];
    
    UIImage  *newImage = UIGraphicsGetImageFromCurrentImageContext ();
    
    UIGraphicsEndImageContext ();
    
    return newImage;
}

@end
