//
//  JDBrowsingHistoryDataStorage.m
//  Borrowing
//
//  Created by Sierra on 2017/9/6.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDBrowsingHistoryDataStorage.h"

@implementation JDBrowsingHistoryDataStorage

+ (JDBrowsingHistoryDataStorage*)sharedInstance {
    
    static JDBrowsingHistoryDataStorage *personalDate;
    static dispatch_once_t demoglobalclassonce;
    dispatch_once(&demoglobalclassonce, ^{
        personalDate = [[JDBrowsingHistoryDataStorage alloc] init];
    });
    return personalDate;
}


- (void)dataBrowsingHistoryStorageWithProductM:(JDProduct_M *)product
{
    
    NSDictionary *dic = [product mj_keyValues];
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"browingHistory.plist"];
    
    // 解档
    NSArray *productArr = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray*productMulArr = [[NSMutableArray alloc] initWithArray:productArr];
    
    //是否包含
    if ([productMulArr containsObject:dic]) {
        
        
        [productMulArr removeObject:dic];
        
        [productMulArr insertObject:dic atIndex:0];
        
    }else{
        
        [productMulArr insertObject:dic atIndex:0];
    }
    
    // NSDocumentDirectory 要查找的文件
    // NSUserDomainMask 代表从用户文件夹下找
    // 在iOS中，只有一个目录跟传入的参数匹配，所以这个集合里面只有一个元素
    [productMulArr writeToFile:filePath atomically:YES];
    
}

@end
