//
//  Constants.h
//  Borrowing
//
//  Created by Sierra on 2017/8/22.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define Timestampstr  NSString *timestampstr = [XMToolClass getTimeStamp];


//#define LOGINURL @"http://192.168.18.120:19501"//电脑测试


//#define LINEURL @"http://test.api.bianxianmao.com/loanshop"//测试
//#define LOGINURL @"http://test.api.bianxianmao.com"
//#define ThirdAppkey @"a0b11e41e15041929219fc56dcffc597"//测试
//#define ThirdAppId @"123"


#define ThirdAppkey @"6b6491c90f98435ba10f4890f3179b52"//线上
#define LINEURL @"http://api.bianxianmao.com/loanshop"//线上
#define LOGINURL @"http://api.bianxianmao.com"
#define ThirdAppId @"1057"

#define Tip @"正在加载中"

#define TipFailure @"请再试一遍"
#define TipFailureDetail @"网络开小差了～"

#define TipFinish @"请输入完整信息"

#define TiPDelayTime 0.35

#define kDelayTime 1

#define CityInfo @"cityInfo"//省市区信息

#define NumPerPage @"6" //分页数据，每页的数量

/*----------------颜色------------------------------------------------*/
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#define SeparatorCOLOR [UIColor colorWithRed:205/255.0f green:211/255.0f blue:220/255.0f alpha:1]


#define TableColor [XMToolClass getColorWithHexString:@"f4f4f8"]
//F93069
#define ThemeColor RGBCOLOR(249, 48, 105)

#define ThemeHightColor RGBCOLOR(231, 32, 32)

#define ClearColor [UIColor clearColor]

#define WhiteColor [UIColor whiteColor]

#define BlackColor RGBCOLOR(26, 26, 26)

#define OrangeColor RGBCOLOR(244, 164, 48)

#define OrangeHightColor RGBCOLOR(233, 154, 42)

//333333
#define BlackNameColor RGBCOLOR(51, 51, 51)

//666666
#define BlackContentColor RGBCOLOR(102, 102, 102)

//767778
#define BlackGrayColor RGBCOLOR(124, 124, 124)

//b2b2b2
#define GrayContentColor RGBCOLOR(170, 170, 170)

//999999
#define GrayTipColor RGBCOLOR(153, 153, 153)


#define GrayShallowColor RGBCOLOR(184, 184, 184)


#define GrayLoginColor RGBCOLOR(203, 204, 205)

#define GrayBlackColor RGBCOLOR(149, 149, 149)


#ifdef DEBUG//处于开发阶段
#define NZLog(...) NSLog(__VA_ARGS__)

#else//处于发布阶段
#define NZLog(...)
#endif

#define CoverSquareDefault @"shoumian"
#define CoverLongDefault @"shoumian_long"

#define AvatarDefault @"public_touxiang"

#define AvatarTemp @"http://zhuanxian.nado.cc/data/upload/slides/20170630/201706301000451572.png"

#define ThemeGoodBGImage @"public_themeBG"
#define ThemeEdgeImage @"public_themeEdge"

/*--------------------------------------------------------------------------------*/

#define kWindowH   [UIScreen mainScreen].bounds.size.height //应用程序的屏幕高度
#define kWindowW    [UIScreen mainScreen].bounds.size.width  //应用程序的屏幕宽度

#define kNavigationH 64
#define kMargin 12
#define LoginLeftM 40

#define KActualH(x) ((x / 750.0) * kWindowW)//控件按照设计图的比例计算的高度
#define kButtonMaxH 50
#define kButtonH 44
#define kButtonMidleH 40
#define kButtonMinH 35

#define kTableMinHeight 7

#define kShowDisTime 0.25

#define APPDELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define NZNotificationCenter [NSNotificationCenter defaultCenter]

#define HistoryList @"BrowsingHistoryDataStorage"//浏览记录

//字符串不为空
#define STRING_NOT_EMPTY(string) (string != nil && [string isKindOfClass:[NSString class]] && ![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
//字符串为空
#define STRING_EMPTY(string) (string.length == 0 && [string isKindOfClass:[NSString class]] )
//数组不为空
#define ARRAY_NOT_EMPTY(array) (array && [array isKindOfClass:[NSArray class]] && [array count])
//字典不为空
#define DICTIONARY_NOT_EMPTY(dictionary) (dictionary && [dictionary isKindOfClass:[NSDictionary class]] && [dictionary count])
//--------字号大小----------------------------------------------------------------------------------------------
#define kFont(size) [UIFont systemFontOfSize:(size)]
//偏好设置
#define UserDefault [NSUserDefaults standardUserDefaults]
//用户模型单利
#define KeyUser [NSKeyedUnarchiver unarchiveObjectWithFile:[XMToolClass getKeyedAchievePath]]
//平台
#define sourcePlatformType @""
//移除iOS7之后，cell默认左侧的分割线边距
#define kRemoveCellSeparator \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
cell.separatorInset = UIEdgeInsetsZero;\
cell.layoutMargins = UIEdgeInsetsZero; \
cell.preservesSuperviewLayoutMargins = NO; \
}\


#endif /* Constants_h */
