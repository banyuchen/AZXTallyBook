//
//  DBSave.h
//  Snatch
//
//  Created by Sierra on 2017/8/2.
//  Copyright © 2017年 Sierra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBAccount.h"

@interface DBSave : NSObject

+ (void)setObject:(id)value forKey:(NSString *)defaultName;

+ (id)objectForKey:(NSString *)defaultName;


+ (DBAccount *)account;

+ (void)save:(DBAccount *)account;

@end
