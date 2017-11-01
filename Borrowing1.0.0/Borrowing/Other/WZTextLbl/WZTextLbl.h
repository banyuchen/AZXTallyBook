//
//  WZTextLbl.h
//  WZRichText
//
//  Created by 班文政 on 2017/8/22.
//  Copyright © 2017年 BanWenZheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, WZTextLblRegularType) {
    WZTextLblRegularTypeNone      = 0,
    WZTextLblRegularTypeAboat     = 1 << 0,//@类型
    WZTextLblRegularTypeTopic     = 1 << 1,//##类型  话题
    WZTextLblRegularTypeUrl       = 1 << 2,//url类型
};


@class WZTextLbl;
@class WZTextLblModel;


/**-------------------------------------WZTextLbl代理-------------------------------------*/

@protocol WZTextLblDelegate <NSObject>

//model图片被点击
- (void)labelImageClickLinkInfo:(WZTextLblModel *)linkInfo;

//http链接点击   model内设置链接的对应点击
- (void)labelLinkClickLinkInfo:(WZTextLblModel *)linkInfo linkUrl:(NSString *)linkUrl;

//http链接点击   model内设置链接的对应长按
- (void)labelLinkLongPressLinkInfo:(WZTextLblModel *)linkInfo linkUrl:(NSString *)linkUrl;

//正则文字点击
- (void)labelRegularLinkClickWithclickedString:(NSString *)clickedString;

//label自身被点击
- (void)labelClickedWithExtend:(id)extend;



@end

@interface WZTextLbl : UILabel


@property (nonatomic ,strong) NSArray<WZTextLblModel *> *messageModels;
@property (nonatomic ,assign) WZTextLblRegularType regularType;

@property (nonatomic ,strong) UIColor *linkTextColor;
@property (nonatomic ,strong) UIColor *selectedBackgroudColor;
@property (nonatomic , weak ) id delegate;
@property (nonatomic ,strong) id extend;                //扩展参数提供传递任意类型属性

//model图片被点击
@property (nonatomic, copy) void (^imageClickBlock)(WZTextLblModel *linkInfo);
//http链接点击   model内设置链接的对应点击
@property (nonatomic, copy) void (^linkClickBlock)(WZTextLblModel *linkInfo, NSString *linkUrl);
//http链接长按   model内设置链接的对应长按
@property (nonatomic, copy) void (^linkLongPressBlock)(WZTextLblModel *linkInfo, NSString *linkUrl);
//正则文字点击
@property (nonatomic, copy) void (^regularLinkClickBlock)(NSString *clickedString);

@property (nonatomic, copy) void (^labelClickedBlock)(id extend);


//添加正则表达式规则
- (void)addRegularString:(NSString *)regularString;


@end



/**-------------------------------------WZTextLbl数据模型-------------------------------------*/
@interface WZTextLblModel : NSObject

@property (nonatomic , copy ) NSString *message;        //显示的文字

//用于添加图片
@property (nonatomic ,strong) UIImage *image;           //富文本图片
@property (nonatomic , copy ) NSString *imageName;      //富文本图片名称
@property (nonatomic ,assign) CGSize imageShowSize;    //富文本图片要显示的大小  默认17*17
@property (nonatomic , copy ) NSString *imageClickBackStr;           //图片点击反馈字符串


@property (nonatomic ,strong) id extend;                //扩展参数提供传递任意类型属性
- (void)replaceUrlWithString:(NSString *)string;        //替换网络链接为指定文案

@end

