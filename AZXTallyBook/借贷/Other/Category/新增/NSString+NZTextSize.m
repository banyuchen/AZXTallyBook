//
//  NSString+NZTextSize.m
//  NZJob
//
//  Created by WenhuaLuo on 15/7/27.
//  Copyright (c) 2015年 WenhuaLuo. All rights reserved.
//

#import "NSString+NZTextSize.h"

@implementation NSString (NZTextSize)

#pragma mark - 自定义方法，不同颜色的字
+ (NSMutableAttributedString *)multableAttributeStr:(NSString *)str stringColor:(UIColor *)color
{
    NSMutableAttributedString *mulStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSRange range = NSMakeRange(0, [mulStr length]);
    
    [mulStr setAttributes:@{NSForegroundColorAttributeName : color} range:range];
    
    return mulStr;
    
}

+ (NSMutableAttributedString *)attributedStringWithColorTitle:(NSString *)title normalTitle:(NSString *)normalTitle frontTitle:(NSString *)frontTitle diffentColor:(UIColor *)color
{
    NSAttributedString *frontStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",frontTitle]];
    
    //OrangeColor
    NSMutableAttributedString *goodsNameStr = [self multableAttributeStr:[NSString stringWithFormat:@"%@",title] stringColor:color];
    
    NSAttributedString *secondTipsStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",normalTitle]];
    
    NSMutableAttributedString *finishTipMulStr = [[NSMutableAttributedString alloc]init];
    
    [finishTipMulStr appendAttributedString:frontStr];
    
    [finishTipMulStr appendAttributedString:goodsNameStr];
    
    [finishTipMulStr appendAttributedString:secondTipsStr];
    
    return finishTipMulStr;
    
}


+ (NSMutableAttributedString *)attributedStringWithFirstTitle:(NSString *)firstTitle secrondTitle:(NSString *)secrondTitle thirdTitle:(NSString *)thirdTitle fourTitle:(NSString *)fourTitle firstColor:(UIColor *)firstColor secrondColor:(UIColor *)secrondColor thirdColor:(UIColor *)thirdColor fourColor:(UIColor *)fourColor{
    
    //不同颜色&
    NSMutableAttributedString*mulAttriStr =  [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@%@", firstTitle, secrondTitle, thirdTitle,fourTitle]];
    
    //第一个
    [mulAttriStr addAttribute:NSForegroundColorAttributeName value:firstColor range:NSMakeRange(0,firstTitle.length)];
    
    //第二个
    [mulAttriStr addAttribute:NSForegroundColorAttributeName value:secrondColor range:NSMakeRange(firstTitle.length,secrondTitle.length)];
    
    //第三个
    [mulAttriStr addAttribute:NSForegroundColorAttributeName value:thirdColor range:NSMakeRange([NSString stringWithFormat:@"%@%@",firstTitle,secrondTitle].length,thirdTitle.length)];
    
    //第四个
    [mulAttriStr addAttribute:NSForegroundColorAttributeName value:fourColor range:NSMakeRange([NSString stringWithFormat:@"%@%@%@",firstTitle,secrondTitle,thirdTitle].length, fourTitle.length)];
    
    return mulAttriStr;
}

+ (NSMutableAttributedString *)attributedStringWithColorTitle:(NSString *)title normalTitle:(NSString *)normalTitle frontTitle:(NSString *)frontTitle normalColor:(UIColor *)normalColor diffentColor:(UIColor *)color normalFont:(UIFont *)normalFont differentFont:(UIFont *)font
{
    //不同颜色&大小的字
    NSMutableAttributedString*mulAttriStr =  [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@", frontTitle, title, normalTitle]];
    
    [mulAttriStr addAttribute:NSForegroundColorAttributeName value:normalColor range:NSMakeRange(0,frontTitle.length)];
    [mulAttriStr addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0,frontTitle.length)];
    
    if (color) {
        [mulAttriStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(frontTitle.length,title.length)];
        [mulAttriStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(frontTitle.length,title.length)];
    }
    
    if (font) {
        [mulAttriStr addAttribute:NSForegroundColorAttributeName value:normalColor range:NSMakeRange(frontTitle.length+title.length,normalTitle.length)];
        [mulAttriStr addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(frontTitle.length+title.length,normalTitle.length)];
    }
    
    return mulAttriStr;
    
}



+ (NSMutableAttributedString *)attributeWithTitle:(NSString *)title behindText:(NSString *)behindText imageName:(NSString *)imageName attchY:(CGFloat)attchY
{
    NSString *frontText = title ? title : @"";
    // 创建一个富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:frontText];
    
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:imageName];
//    attch.
    // 设置图片大小
    attch.bounds = CGRectMake(0, attchY, attch.image.size.width, attch.image.size.height);
    
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    
    [attri appendAttributedString:string];
    
    if (behindText) {
        
        NSAttributedString *behind = [[NSAttributedString alloc]initWithString:behindText];
        
        [attri appendAttributedString:behind];
    }
    
    return attri;
}


+ (NSMutableAttributedString *)attributeWithTitle:(NSString *)title behindText:(NSString *)behindText centerImageName:(NSString *)imageName height:(CGFloat)height
{
    NSString *frontText = title ? title : @"";
    // 创建一个富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:frontText];
    
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:imageName];
    //    attch.
    // 设置图片大小
    CGFloat attchY = (height-attch.image.size.height)/2.0-2;
    attch.bounds = CGRectMake(0, attchY, attch.image.size.width, attch.image.size.height);
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    
    [attri appendAttributedString:string];
    
    if (behindText) {
        
        NSAttributedString *behind = [[NSAttributedString alloc]initWithString:behindText];
        
        [attri appendAttributedString:behind];
    }
    
    return attri;
}



/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


#pragma mark 转换成JSON字符串
/**
 *  @brief NSDictionary转换成JSON字符串
 *
 *  @return  JSON字符串
 */

+ (NSString *)JSONString:(id)data{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData == nil) {
#ifdef DEBUG
        NSLog(@"fail to get JSON from dictionary: %@, error: %@", self, error);
#endif
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}


@end
