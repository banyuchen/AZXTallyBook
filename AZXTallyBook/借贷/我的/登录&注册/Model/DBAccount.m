//
//  DBAccount.m
//  Snatch
//
//  Created by Sierra on 2017/8/2.
//  Copyright © 2017年 Sierra. All rights reserved.
//

#import "DBAccount.h"

@implementation DBAccount

- (instancetype)initWithDict:(NSDictionary *)dict
{
    
    if (self = [super init]) {
        
        
        self.ggkUrl = [NSDictionary changeType:dict[@"ggkUrl"]];
        self.ID = [NSDictionary changeType:dict[@"id"]];
        self.redirectUrl = [NSDictionary changeType:dict[@"redirectUrl"]];
        self.buyUrl = [NSDictionary changeType:dict[@"buyUrl"]];
        self.idfa = [NSDictionary changeType:dict[@"idfa"]];
        self.appId = [NSDictionary changeType:dict[@"appId"]];
        self.appEntrance = [NSDictionary changeType:dict[@"appEntrance"]];
        self.imei = [NSDictionary changeType:dict[@"imei"]];
        self.userToken = [NSDictionary changeType:dict[@"userToken"]];
        self.appKey = [NSDictionary changeType:dict[@"appKey"]];
        self.account = [NSDictionary changeType:dict[@"account"]];
        self.appUid = [NSDictionary changeType:dict[@"appUid"]];
        self.face = [NSDictionary changeType:dict[@"face"]];
        self.nickname = [NSDictionary changeType:dict[@"nickname"]];
        
    }
    return self;
}

+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([DBAccount class], &count);
    for (int index = 0; index < count; index ++) {
        Ivar ivar = ivars[index];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([DBAccount class], &count);
        
        for (int index = 0; index < count; index ++) {
            Ivar ivar = ivars[index];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            
            [self setValue:value forKey:key];
        }
    }
    return self;
}


@end
