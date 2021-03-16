//
//  Constant.h
//  Lotto
//
//  Created by brownie on 2014/1/27.
//  Copyright (c) 2014年 brownieBBK. All rights reserved.
//
#import "Singleton.h"
#import "BaseViewController.h"
#import "MainViewController.h"
#import "Star3ViewController.h"
#import "Star4ViewController.h"
#import "BigLottoViewController.h"

#import "BingoViewController.h"
#import "PecordNavigationViewcontroller.h"
#import "UIImage+StackBlur.h"
#import "IrregularShapedButton.h"
//Custom Cell
#import "AllDataCell.h"
#import "PecordListCell.h"
// CoreData
#import "SortTable.h"
// 2/2
#import "SortListViewController.h"

#import "SortAndAllDataDetailViewcontroller.h"
//2/5
#import "GloBalAnalysisViewController.h"
//2/6
#import "WeiLiViewController.h"
#import "Five39ViewController.h"
#import "Thirty8ViewController.h"
#import "Thirty9ViewController.h"
#import "Forty9ViewController.h"
#import "CustomBackButton.h"
#import "CustomClearDataButton.h"

#import <iAd/iAd.h>
#define DEFAULTS [[Singleton sharedInstance] defaults]
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define isIPhoneWithNotch ([[UIScreen mainScreen] bounds].size.height >= 812) && (!isIPad)
#define isIPad ([[UIScreen mainScreen] bounds].size.width >= 768)
#define statusBarHeight (isIPhoneWithNotch ? 44 : 20)
#define pHeight(x) ((SCREEN_HEIGHT * x) / 812.0)
#define pWidth(x) ((SCREEN_WIDTH * x) / 375.0)

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)
#define BUTTON_LINE_COUNT 10
#define BUTTON_SIZE pWidth(SCREEN_WIDTH/3 - 60)
#define BUTTON_LINE_HIGH BUTTON_SIZE*0.68
#define STAR3_PER_NUM 10
#define STAR4_PER_NUM 10
#define BIGLOTTO_PER_NUM 49
#define WEILI_PER_NUM 38
#define FIVE39_PER_NUM 39
#define THIRTY9_PER_NUM 39
#define THIRTY8_PER_NUM 38
#define FORTY9_PER_NUM 49
#define BINGO_BALL_RAND 4
#define BINGO_BALL_COUNT 9
#define SINGLETON [Singleton sharedInstance]
//各種 總體球數
#define THREE_BALL_COUNT 3
#define FOUR_BALL_COUNT 4
#define FIVE_BALL_COUNT 5
#define SIX_BALL_COUNT 6
#define WEI_LI_BALL_COUNT 6
#define NINE_BALL_COUNT 9

//各種 Type
#define DBTYPE_STAR_3 1
#define DBTYPE_STAR_4 2
#define DBTYPE_BIG_LOTTO 3
#define DBTYPE_WEI_LI 4
#define DBTYPE_FIVE_THREE_NINE 5
#define DBTYPE_BINGO 6
#define DBTYPE_THREE_NINE 7
#define DBTYPE_THREE_EIGHT 8
#define DBTYPE_FOUR_NINE 9
//字體放大縮小倍數
#define FRAME_SCALE_MAX 2
#define FRAME_SCALE_MID 1.5
#define FRAME_SCALE_DEFAULT 1.0

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

//307
#define kSampleAdUnitID @"a153195f9aaf948"

typedef NS_ENUM(int, LottoType) {
    Lotto38BallCount = 38,
    Lotto39BallCount = 39,
    Lotto49BallCount = 49,
    Lotto539BallCount = 39 ,
    BigLottoBallCount = 49,
    BingoRAND = 4,
    BingoCOUNT = 9,
    Star3BallCount = 10,
    Star4BallCount = 10,
    WeiLiBallCount = 38,
    WeiLiSubBallCount = 8
};
