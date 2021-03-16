//
//  MainViewController.m
//  Lotto
//
//  Created by brownie on 2014/1/27.
//  Copyright (c) 2014年 brownieBBK. All rights reserved.
//

#import "MainViewController.h"
#import "Constant.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <SystemConfiguration/SystemConfiguration.h>
//#import "GADBannerView.h"
//#import "GADRequest.h"
@interface MainViewController ()<ADBannerViewDelegate>
{
    PecordNavigationViewcontroller *pecordViewController;
    BingoViewController *bingoViewController;
    BigLottoViewController *bigViewController;
    Star4ViewController *star4ViewController;
    Star3ViewController *star3ViewController;
    UIImageView *mainBackImageView;
    UIImageView *frameImageView;
    //2/6
    WeiLiViewController *weiliViewController;
    Five39ViewController *five39ViewController;
    Thirty8ViewController *thirty8ViewController;
    Thirty9ViewController *thirty9ViewController;
    Forty9ViewController *forty9ViewController;
    
    //2/12
    BOOL backFromBackground;
    //307
    BOOL IsFirstLunchApp;
//    ADBannerView *adView;
}
@end

@implementation MainViewController
@synthesize mainButtonScrollView;

@synthesize holderView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.view.backgroundColor = [UIColor orangeColor];
//        [nsc addObserver:self selector:@selector(viewWillAppear:) name:@"AddADMODBanner" object:nil];
        
        backFromBackground = YES;
        [self setUI];
        [self setButtons];
        [self setUpAllViewController];
        [self setUpAdBannerview];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    BOOL bStatusBarHide = [UIApplication sharedApplication].statusBarHidden;
//    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
//    if(!bStatusBarHide)
//        screenHeight -= 20;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    backFromBackground = [DEFAULTS boolForKey:@"BackFromBack"];
    IsFirstLunchApp = [DEFAULTS boolForKey:@"IsFirstLaunch"];
    
    if (backFromBackground == YES)
    {
//        [SINGLETON fadeInWithView:bannerView_];
    }
    if (IsFirstLunchApp == YES)
    {
        [DEFAULTS setBool:NO forKey:@"IsFirstLaunch"];
        [DEFAULTS synchronize];
        IsFirstLunchApp = NO;
//        [SINGLETON fadeInWithView:bannerView_];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [DEFAULTS setBool:NO forKey:@"BackFromBack"];
    [DEFAULTS synchronize];
//    [SINGLETON fadeOutWithView:bannerView_];
}
#pragma mark -
#pragma mark 初始設定
-(void)setUI
{
    float barHeight = statusBarHeight;


    self.mainButtonScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, barHeight, SCREEN_WIDTH, SCREEN_HEIGHT-barHeight)];
    self.mainButtonScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+barHeight*2);
    //背景
    mainBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, statusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-statusBarHeight)];
    mainBackImageView.image = [UIImage imageNamed:@"00_BG 11.png"];

    [self.view addSubview:mainBackImageView];
    [self.view addSubview:self.mainButtonScrollView];
    //加匡
    frameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x-pWidth(6), barHeight, SCREEN_WIDTH+pWidth(12), SCREEN_HEIGHT-barHeight)];
    frameImageView.image = [UIImage imageNamed:@"0_frame.png"];
    frameImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:frameImageView];
    //307
//    bannerView_ =[[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
//    bannerView_ =[[GADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-GAD_SIZE_320x50.height, 320, 50)];
//    bannerView_.adUnitID = @"a153195f9aaf948";
//    bannerView_.rootViewController =self;
//    bannerView_.delegate = self;
//    bannerView_.alpha = 0.0;
//    [self.view addSubview:bannerView_];
//    [bannerView_ loadRequest:[GADRequest request]];
}
-(void)setButtons
{
    CGPoint defaultScrollViewCenter = CGPointMake(self.view.center.x-CGRectGetMinX(mainButtonScrollView.frame),BUTTON_LINE_HIGH);
    
    for (int i = 0; i < BUTTON_LINE_COUNT; i ++)
    {
        UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [setButton setFrame:CGRectMake(0, 0, BUTTON_SIZE, BUTTON_SIZE)];
        setButton.center = CGPointMake(defaultScrollViewCenter.x+((i%3==0)?0:(i%3==1)?-BUTTON_LINE_HIGH:+BUTTON_LINE_HIGH), defaultScrollViewCenter.y+((i%3==0)?(i/3*2)*BUTTON_LINE_HIGH:(i/3*2+1)*BUTTON_LINE_HIGH));
        [setButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MainButton%i_up",i]] forState:UIControlStateNormal];
        [setButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MainButton%i_down",i]] forState:UIControlStateHighlighted];
        setButton.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45));
        setButton.tag = i+1;
        [setButton addTarget:self action:@selector(pushToSubview:) forControlEvents:UIControlEventTouchUpInside];
        [mainButtonScrollView addSubview:setButton];
    }
    float totalHeight = ([[mainButtonScrollView subviews] lastObject].frame.origin.y +
                         [[mainButtonScrollView subviews] lastObject].frame.size.height);
    mainButtonScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, totalHeight);
}
-(void)setUpAllViewController
{
    if (star3ViewController == nil)
    {
        star3ViewController = [[Star3ViewController alloc] init];
        star3ViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        star3ViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    if (star4ViewController == nil)
    {
        star4ViewController = [[Star4ViewController alloc] init];
        star4ViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        star4ViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    if (bigViewController == nil)
    {
        bigViewController = [[BigLottoViewController alloc] init];
        bigViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        bigViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    if (bingoViewController == nil)
    {
        bingoViewController = [[BingoViewController alloc] init];
        bingoViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        bingoViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    if (pecordViewController == nil)
    {
        pecordViewController = [[PecordNavigationViewcontroller alloc] init];
        pecordViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        pecordViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    if (weiliViewController == nil)
    {
        weiliViewController = [[WeiLiViewController alloc] init];
        weiliViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        weiliViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    if (five39ViewController == nil)
    {
        five39ViewController = [[Five39ViewController alloc] init];
        five39ViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        five39ViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    if (thirty8ViewController == nil)
    {
        thirty8ViewController = [[Thirty8ViewController alloc] init];
        thirty8ViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        thirty8ViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    if (thirty9ViewController == nil)
    {
        thirty9ViewController = [[Thirty9ViewController alloc] init];
        thirty9ViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        thirty9ViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    if (forty9ViewController == nil)
    {
        forty9ViewController = [[Forty9ViewController alloc] init];
        forty9ViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        forty9ViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}
#pragma mark -
#pragma mark 單元功能
-(void)pushToSubview:(UIButton *)sender
{
    [sender setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MainButton%i_down",(int)sender.tag-1]] forState:UIControlStateNormal];
    switch (sender.tag)
    {
        case 1:
            [self pushToMyView:star3ViewController WithButton:sender];
            break;
        case 2:
            [self pushToMyView:star4ViewController WithButton:sender];
            break;
        case 3:
            [self pushToMyView:bigViewController WithButton:sender];
            break;
        case 4:
            [self pushToMyView:weiliViewController WithButton:sender];
            break;
        case 5:
            [self pushToMyView:five39ViewController WithButton:sender];
            break;
        case 6:
            [self pushToMyView:bingoViewController WithButton:sender];
            break;
        case 7:
            [self pushToMyView:thirty9ViewController WithButton:sender];
            break;
        case 8:
            [self pushToMyView:thirty8ViewController WithButton:sender];
            break;
        case 9:
            [self pushToMyView:forty9ViewController WithButton:sender];
            break;
        case 10:
            [self pushToMyView:pecordViewController WithButton:sender];
            break;
        default:
            break;
    }
    
}
-(void)pushToMyView:(UIViewController *)currentView WithButton:(UIButton *)sender
{
    [self presentViewController:currentView animated:YES completion:^
    {
    [sender setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MainButton%i_up",(int)sender.tag-1]] forState:UIControlStateNormal];
    }];
}
- (void)didChangeStatusBarFrame:(NSNotification*)notification
{
//    NSValue*statusBarFrameValue = [notification.userInfo valueForKey:UIApplicationStatusBarFrameUserInfoKey];
    CGRect mainScrollView = mainButtonScrollView.frame;
    CGRect mainViewRect = mainBackImageView.frame;
    CGRect frameViewRect = frameImageView.frame;
    mainViewRect.size.height = SCREEN_HEIGHT-statusBarHeight;
    frameViewRect.size.height = SCREEN_HEIGHT-statusBarHeight;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
     {
        [mainButtonScrollView setFrame:mainScrollView];
        [mainBackImageView setFrame:mainViewRect];
        [frameImageView setFrame:frameViewRect];
        
    } completion:nil];
}
//#pragma mark GADBannerViewDelegate impl
//// We've received an ad successfully.
//- (void)adViewDidReceiveAd:(GADBannerView *)adView {
//    NSLog(@"Received ad successfully");
//}
//- (void)adView:(GADBannerView *)view
//didFailToReceiveAdWithError:(GADRequestError *)error {
//    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
//}
-(void)setUpAdBannerview
{
    if ([self isAvailableNetworkWithCompleteBlock:nil])
    {
//        NSLog(@"有網路可以去取廣告");
//        adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
//        [adView setFrame:CGRectMake(0, SCREEN_HEIGHT, adView.frame.size.width, adView.frame.size.height)];
//        //    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
//        [adView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
//        adView.delegate = self;
//        [self.view addSubview:adView];
//        [self layoutAnimated:YES];
    }

}

//- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
//{
//    NSLog(@"Banner view is beginning an ad action");
//
//    return YES;
//}
//- (void)bannerViewDidLoadAd:(ADBannerView *)banner
//{
//    NSLog(@"廣告成功");
//    [self layoutAnimated:YES];
////    [UIView animateWithDuration:0.3 animations:^
////    {
////        adView.alpha = 1.0;
////    }];
//}
//- (void)layoutAnimated:(BOOL)animated
//{
//    CGRect contentFrame = self.view.bounds;
//    CGRect bannerFrame = adView.frame;
//    if (adView.bannerLoaded == YES)
//    {
//        NSLog(@"廣告獲取成功");
//        NSLog(@"contentFrame Height :%f \nADView Height :%f",contentFrame.size.height,adView.frame.size.height);
//
//        contentFrame.size.height -= adView.frame.size.height;
//        NSLog(@"contentFrame Height :%f \nADView Height :%f",contentFrame.size.height,adView.frame.size.height);
//        bannerFrame.origin.y = contentFrame.size.height;
//        NSLog(@"bannerFrame  %@",NSStringFromCGRect(bannerFrame));
//    } else
//    {
//        NSLog(@"廣告獲取失敗");
//        bannerFrame.origin.y = contentFrame.size.height;
//    }
//
//    [UIView animateWithDuration:(animated ? 0.6 : 0.0) animations:^{
////        self.view.frame = contentFrame;
//        [self.view layoutIfNeeded];
//        adView.frame = bannerFrame;
//    }];
//}
//- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
//{
//    NSLog(@"廣告失敗");
//    [self layoutAnimated:NO];
//}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
//        adView.currentContentSizeIdentifier =
//        ADBannerContentSizeIdentifierLandscape;
//        [adView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }
    else
    {
//        adView.currentContentSizeIdentifier =
//        ADBannerContentSizeIdentifierPortrait;
//        [adView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }
}

- (BOOL)isAvailableNetworkWithCompleteBlock:(void (^)(BOOL is3GActive))completeBlock
{
    // 0.0.0.0
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    // Reachability flag
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr*)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags) {
        
        NSLog(@"Error");
        return 0;
    }
    
    // ネットワークフラグ
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL nonWifi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    BOOL is3G = flags & kSCNetworkReachabilityFlagsIsWWAN;
    if (((isReachable && !needsConnection) || nonWifi) ? YES : NO)
    {
        NSLog(@"可以連線");
        if (completeBlock)
        {
            if (is3G == YES)
            {
                completeBlock(YES);
            }else
            {
                completeBlock(NO);
            }
        }
        
    }else
    {
        NSLog(@"不可連線");
    }
    
    return ((isReachable && !needsConnection) || nonWifi) ? YES : NO;
}
@end
