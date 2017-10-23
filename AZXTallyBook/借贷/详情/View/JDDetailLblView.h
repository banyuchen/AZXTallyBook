//
//  JDDetailLblView.h
//  Borrowing
//
//  Created by Sierra on 2017/9/4.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDDetailLblViewModel : NSObject

/**标题*/
@property (nonatomic, copy) NSString *detailTitle;
/**描述*/
@property (nonatomic, strong) NSString *descStr;
/**单位*/
@property (nonatomic, strong) NSString *unitStr;

@end


@interface JDDetailLblView : UIView

/**<#name#>*/
@property (nonatomic, strong) JDDetailLblViewModel *detailModel;

@end
