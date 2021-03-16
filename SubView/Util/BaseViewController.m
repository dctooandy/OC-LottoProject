//
//  BaseViewController.m
//  Lotto180320
//
//  Created by AndyChen on 2020/7/30.
//  Copyright © 2020 AndyChen. All rights reserved.
//

#import "BaseViewController.h"
#import "Constant.h"
@interface BaseViewController ()
{
    
}
@end

@implementation BaseViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarFrame:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
        numArray = [[NSMutableArray alloc] init];
        countArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)backToMainView:(UIButton *)sender
{
    sender.selected = YES;
    [self dismissViewControllerAnimated:YES completion:^
     {
         sender.selected = NO;
     }];
}
-(void)deleteDataButton:(UIButton *)sender
{
    
}
-(void)disNumMode
{
    
}
- (void)didChangeStatusBarFrame:(NSNotification*)notification
{
}
#pragma mark -
#pragma mark ResetNumber
-(void)resetNumArray:( int )sender
{
    [numArray removeAllObjects];
    [countArray removeAllObjects];
    for(int i = 1; i <=sender; i++)
    {
        NSNumber *nsi = [NSNumber numberWithInt:i];
        [numArray addObject:nsi];
    }
}
-(void)setUI
{
    if (mainBackImageView == nil)
    {
        //背景
        mainBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, statusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-statusBarHeight)];
        mainBackImageView.image = [UIImage imageNamed:@"00_BG 11.png"];
    }
    if ( dressingView == nil)
    {
        //上面的裝飾
        dressingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, statusBarHeight, SCREEN_WIDTH, pWidth(26))];
        dressingView.image = [UIImage imageNamed:@"00_curtain.png"];
    }
    if ( frameImageView == nil)
    {
        //外框
        frameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, statusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-statusBarHeight)];
        frameImageView.image = [UIImage imageNamed:@"00_frame.png"];
    }
    if ( backButton == nil)
    {
        //返回按鈕
        backButton = [CustomBackButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(pWidth(2), statusBarHeight+pHeight(5),pWidth(95), pWidth(120))];
        backButton.tag = 1;
        [backButton addTarget:self action:@selector(backToMainView:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ( clearDataButton == nil)
    {
        //刪除資料按鈕
        clearDataButton = [CustomClearDataButton buttonWithType:UIButtonTypeCustom];
        [clearDataButton setFrame:CGRectMake(SCREEN_WIDTH-pWidth(7)-pWidth(95), statusBarHeight+pHeight(5),pWidth(95), pWidth(120))];
        clearDataButton.tag = 2;
        [clearDataButton addTarget:self action:@selector(deleteDataButton:) forControlEvents:UIControlEventTouchUpInside];
        [clearDataButton addTarget:self action:@selector(disNumMode) forControlEvents:UIControlEventTouchUpOutside];
    }
    if ( currentNumberImageView == nil)
    {
        //目前搖了幾次幾號
        currentNumberImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-pWidth(113), -pHeight(86), pWidth(226), pWidth(84))];
        currentNumberImageView.alpha = 0.0;
    }
    if ( countLabel == nil)
    {
        //號碼Label
        countLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentNumberImageView.frame.size.width/2-pWidth(41), currentNumberImageView.frame.size.height/2-pWidth(37), pWidth(40), pWidth(30))];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.backgroundColor = [UIColor clearColor];
        countLabel.textColor = [UIColor whiteColor];
        countLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:20.0];
    }
    if ( mailToButton == nil)
    {
        //郵寄
        mailToButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mailToButton setImage:[UIImage imageNamed:@"00_e-mail up.png"] forState:UIControlStateNormal];
        [mailToButton setImage:[UIImage imageNamed:@"00_e-mail down.png"] forState:UIControlStateSelected];
        [mailToButton setImage:[UIImage imageNamed:@"00_e-mail down.png"] forState:UIControlStateHighlighted];
        [mailToButton setFrame:CGRectMake(0, SCREEN_HEIGHT-pWidth(112),pWidth(96), pWidth(112))];
        [mailToButton addTarget:self action:@selector(mailToUser:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
-(void)setNumberInNumImageView:(int)sender
{
    CGRect theRect;
    int ig = 0 ;
    switch (sender) {
        case FOUR_BALL_COUNT:
            ig = pWidth(50);
            theRect = CGRectMake(pWidth(22.5), pWidth(40), pWidth(30), pWidth(30));
            break;
        case FIVE_BALL_COUNT:
            ig = pWidth(38);
            theRect = CGRectMake(pWidth(22.5), pWidth(40), pWidth(30), pWidth(30));
            break;
        case SIX_BALL_COUNT:
            ig = pWidth(32);
            theRect = CGRectMake(pWidth(18), pWidth(40), pWidth(30), pWidth(30));
            break;
        default:
            theRect = CGRectMake(0, 0, 0, 0);
            break;
    }
    for (int i = 0; i<sender; i++)
     {
         UIImageView *littleNum = [[UIImageView alloc] initWithFrame:CGRectMake(theRect.origin.x+i*ig, theRect.origin.y, theRect.size.width, theRect.size.height)];
         littleNum.tag = (i+1);
         [currentNumberImageView addSubview:littleNum];
     }
}

-(NSArray *)makeActivityItems
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return [NSArray arrayWithObjects:viewImage, nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)mailToUser:(UIButton *)sender
{
    sender.selected = YES;
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:[self makeActivityItems] applicationActivities:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        [activityVC setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError)
         {
             if([activityType isEqualToString: UIActivityTypePrint])
             {
                 NSLog(@"UIActivityTypePrint");
             }
             if([activityType isEqualToString: UIActivityTypeCopyToPasteboard]){
                 NSLog(@"UIActivityTypeCopyToPasteboard");
             }
             if([activityType isEqualToString: UIActivityTypeAssignToContact]){
                 NSLog(@"UIActivityTypeAssignToContact");
             }
             if([activityType isEqualToString: UIActivityTypeMessage]){
                 NSLog(@"UIActivityTypeMessage");
             }
             if([activityType isEqualToString: UIActivityTypeMail]){
                 NSLog(@"Mail");
             }
             if([activityType isEqualToString: UIActivityTypeSaveToCameraRoll]){
                 NSLog(@"UIActivityTypeSaveToCameraRoll");
             }
             if([activityType isEqualToString: UIActivityTypePostToFacebook]){
                 NSLog(@"UIActivityTypePostToFacebook");
             }
             if([activityType isEqualToString: UIActivityTypePostToTwitter]){
                 NSLog(@"UIActivityTypePostToTwitter");
             }
             if([activityType isEqualToString: UIActivityTypePostToWeibo]){
                 NSLog(@"UIActivityTypePostToWeibo");
             }
             if([activityType isEqualToString: @"WebShow"]){
                 NSLog(@"看Crayon POP");
             }
             float version = [[[UIDevice currentDevice] systemVersion] floatValue];
             if (version>=7.0)
             {
                 if([activityType isEqualToString: UIActivityTypeAddToReadingList]){
                     NSLog(@"UIActivityTypeAddToReadingList");
                 }
                 if([activityType isEqualToString: UIActivityTypePostToFlickr]){
                     NSLog(@"UIActivityTypePostToFlickr");
                 }
                 if([activityType isEqualToString: UIActivityTypePostToVimeo]){
                     NSLog(@"UIActivityTypePostToVimeo");
                 }
                 if([activityType isEqualToString: UIActivityTypePostToTencentWeibo]){
                     NSLog(@"UIActivityTypePostToTencentWeibo");
                 }
                 if([activityType isEqualToString: UIActivityTypeAirDrop]){
                     NSLog(@"UIActivityTypeAirDrop");
                 }
             }
             
         }];
    }
    else
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
        
        if ([activityVC respondsToSelector:@selector(setCompletionHandler:)])
        {
            [activityVC setCompletionHandler:^(NSString *activityType, BOOL completed)
             {
                 if([activityType isEqualToString: UIActivityTypePrint])
                 {
                     NSLog(@"UIActivityTypePrint");
                 }
                 if([activityType isEqualToString: UIActivityTypeCopyToPasteboard]){
                     NSLog(@"UIActivityTypeCopyToPasteboard");
                 }
                 if([activityType isEqualToString: UIActivityTypeAssignToContact]){
                     NSLog(@"UIActivityTypeAssignToContact");
                 }
                 if([activityType isEqualToString: UIActivityTypeMessage]){
                     NSLog(@"UIActivityTypeMessage");
                 }
                 if([activityType isEqualToString: UIActivityTypeMail]){
                     NSLog(@"Mail");
                 }
                 if([activityType isEqualToString: UIActivityTypeSaveToCameraRoll]){
                     NSLog(@"UIActivityTypeSaveToCameraRoll");
                 }
                 if([activityType isEqualToString: UIActivityTypePostToFacebook]){
                     NSLog(@"UIActivityTypePostToFacebook");
                 }
                 if([activityType isEqualToString: UIActivityTypePostToTwitter]){
                     NSLog(@"UIActivityTypePostToTwitter");
                 }
                 if([activityType isEqualToString: UIActivityTypePostToWeibo]){
                     NSLog(@"UIActivityTypePostToWeibo");
                 }
                 if([activityType isEqualToString: @"WebShow"]){
                     NSLog(@"看Crayon POP");
                 }
                 float version = [[[UIDevice currentDevice] systemVersion] floatValue];
                 if (version>=7.0)
                 {
                     if([activityType isEqualToString: UIActivityTypeAddToReadingList]){
                         NSLog(@"UIActivityTypeAddToReadingList");
                     }
                     if([activityType isEqualToString: UIActivityTypePostToFlickr]){
                         NSLog(@"UIActivityTypePostToFlickr");
                     }
                     if([activityType isEqualToString: UIActivityTypePostToVimeo]){
                         NSLog(@"UIActivityTypePostToVimeo");
                     }
                     if([activityType isEqualToString: UIActivityTypePostToTencentWeibo]){
                         NSLog(@"UIActivityTypePostToTencentWeibo");
                     }
                     if([activityType isEqualToString: UIActivityTypeAirDrop]){
                         NSLog(@"UIActivityTypeAirDrop");
                     }
                 }
                 
             }];
        }
#endif
    }
    [self presentViewController:activityVC animated:YES completion:^
     {
         sender.selected = NO;
     }];
}
@end
