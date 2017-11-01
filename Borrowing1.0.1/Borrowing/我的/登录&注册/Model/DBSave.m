//
//  DBSave.m
//  Snatch
//
//  Created by Sierra on 2017/8/2.
//  Copyright © 2017年 Sierra. All rights reserved.
//

#import "DBSave.h"

#define kMessagePath(path) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:path]

@implementation DBSave

+ (void)setObject:(id)value forKey:(NSString *)defaultName{
    //存储数据
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    //立刻同步
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (id)objectForKey:(NSString *)defaultName
{
    //利用NSUserDefaults，就能直接访问软件的偏好设置（Lobarary/Preferences）
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}


/**
 *  存储帐号信息
 */
+ (void)save:(DBAccount *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:kMessagePath(@"account.plist")];
}

/**
 *  获得上次存储的帐号
 *
 */
+ (DBAccount *)account
{
    DBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:kMessagePath(@"account.plist")];
    
    return account;
}


@end
