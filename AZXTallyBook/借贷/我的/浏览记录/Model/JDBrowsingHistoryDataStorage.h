//
//  JDBrowsingHistoryDataStorage.h
//  Borrowing
//
//  Created by Sierra on 2017/9/6.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDProduct_M.h"

@interface JDBrowsingHistoryDataStorage : NSObject


+(JDBrowsingHistoryDataStorage*_Nullable)sharedInstance;

- (void)dataBrowsingHistoryStorageWithProductM:(JDProduct_M *_Nullable)product;

@end
