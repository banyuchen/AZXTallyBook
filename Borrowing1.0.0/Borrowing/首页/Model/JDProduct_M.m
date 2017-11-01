//
//  JDProduct_M.m
//  Borrowing
//
//  Created by Sierra on 2017/8/25.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDProduct_M.h"

@implementation JDProduct_M

+ (NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{ @"ID" : @"id" };
}

- (NSString *)securedLoan
{
    if ([_securedLoan floatValue] > 10000) {
        
        _securedLoan = [NSString stringWithFormat:@"%.2f万",[_securedLoan floatValue]*0.0001];
        
        return _securedLoan;
        
    }else{
        
        return _securedLoan;
    }
}

@end
