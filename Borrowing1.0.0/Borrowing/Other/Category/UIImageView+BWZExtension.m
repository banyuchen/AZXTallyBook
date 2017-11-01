//
//  UIImageView+BWZExtension.m
//  Honghai
//
//  Created by 班文政 on 2017/6/6.
//  Copyright © 2017年 Nado. All rights reserved.
//

#import "UIImageView+BWZExtension.h"
#import "UIImageView+WebCache.h"
#import "UIImage+BWZExtension.h"

@implementation UIImageView (BWZExtension)

- (void)setHeader:(NSString *)url
{
    [self setCircleHeader:url];
}

- (void)setCircleHeader:(NSString *)url
{
    UIImage *placeholder = [UIImage circleImage:CoverSquareDefault];
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image == nil) return;
        
        self.image = [image circleImage];
    }];
}

- (void)setRectHeader:(NSString *)url
{
    UIImage *placeholder = [UIImage imageNamed:@"pig_yellow"];
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
}

@end
