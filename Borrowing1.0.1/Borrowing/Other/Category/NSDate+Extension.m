//
//  NSDate+Extension.m
//  绿马车服
//
//  Created by WenhuaLuo on  16/11/10.
//  Copyright © 2016年 绿绿马. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
+(NSDate *)getToday{
    return [[NSDate date] dateByAddingTimeInterval:8 * 60 * 60];
}
@end
