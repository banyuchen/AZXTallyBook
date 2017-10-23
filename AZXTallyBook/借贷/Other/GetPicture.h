//
//  GetPicture.h
//  DingDing
//
//  Created by WenhuaLuo on 16/10/25.
//  Copyright © 2016年 Meity. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetPictureDelegate <NSObject>

//[@[base64, UIImage]]
- (void)getPictureResult:(NSArray *)pictureArr keyTag:(NSString *)keyTag;

@end

@interface GetPicture : NSObject

+ (GetPicture *)sharedInstance;

@property(nonatomic,weak) id<GetPictureDelegate> delegate;

- (void)initPhotePickerWithController:(UIViewController *)controller selectMaxNum:(NSInteger)maxNum containArr:(NSArray *)containArr keyTag:(NSString *)keyTag delegate:(id /**<GetPictureDelegate>*/)delegate;

+ (void)altermethord:(NSString *)titlestr andmessagestr:(NSString *)messagestr andconcelstr:concelstr;


@end
