
//
//  Star3ViewController.m
//  Lotto
//
//  Created by brownie on 2014/1/27.
//  Copyright (c) 2014年 brownieBBK. All rights reserved.
//

#import "Star3ViewController.h"
#import "Constant.h"
@interface Star3ViewController ()
{
    UIImageView *treeImageView;
    UIButton *dataAnalyze;
    UIImageView *birdWindLeft;
    UIImageView *birdWindRight;
    UIImageView *birdBody;
    UIButton *shakeButton;
    UIButton *canSameNum;
    UIButton *noSameNum;
    
    UIImageView *featherBig1;
    UIImageView *featherSmall1;
    UIImageView *featherSmall2;
    UIImageView *featherBig2;
    UIImageView *featherBig3;
    UIImageView *middleFeather;
    NSMutableDictionary *featherRectDict;
    NSMutableDictionary *featherDefaultRectDict;
    BOOL isSmall;
    
    BOOL spinSameNum;
    UIImageView *numBallOne;
    UIImageView *numBallTwo;
    UIImageView *numBallThree;
    
    UIImageView *currentImageView;
    UIImageView *customAlertView;
    
    UIImageView *redArrow;
    UIImageView *readyShakePhone;
    BOOL firstOpen;
    //2/5
    GloBalAnalysisViewController *star3AnalysisSubView;
    float barHeight ;
    BOOL isFirstShake;
}
@end
@implementation Star3ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

        self.view.backgroundColor = [UIColor orangeColor];
        featherRectDict = [[NSMutableDictionary alloc] init];
        featherDefaultRectDict = [[NSMutableDictionary alloc] init];
        barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        [self setUI];
        isSmall = YES;        
        [self resetNumArray:STAR3_PER_NUM];
        [self makeBulrView];
        [self makeCustomAlertView];
        spinSameNum = NO;
        noSameNum.selected = YES;
        firstOpen = YES;
        [self setAnalysisSubView];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    isFirstShake = NO;    
    [countArray removeAllObjects];
    [self clearWinds];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self becomeFirstResponder];
    if (firstOpen)
    {
        firstOpen = NO;
        [self teachYouHowToPlay];
    }
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setUI
{
    [super setUI];
    [self.view addSubview:mainBackImageView];
    [self.view addSubview:dressingView];

    //不可重覆
    if (noSameNum == nil){
        noSameNum = [UIButton buttonWithType:UIButtonTypeCustom];
        [noSameNum setImage:[UIImage imageNamed:@"00_button-not repeat up.png"] forState:UIControlStateNormal];
        [noSameNum setImage:[UIImage imageNamed:@"00_button-not repeat down.png"] forState:UIControlStateSelected];
        [noSameNum setImage:[UIImage imageNamed:@"00_button-not repeat down.png"] forState:UIControlStateHighlighted];
        [noSameNum setFrame:CGRectMake(pWidth(75), statusBarHeight + pWidth(20+5)+dressingView.frame.size.height,pWidth(86), pWidth(38))];
        CGPoint bCenter = noSameNum.center;
        bCenter.x = SCREEN_WIDTH/2 - pWidth(86)/2 - pWidth(20);
        noSameNum.center = bCenter;
        noSameNum.tag = 1;
        [noSameNum addTarget:self action:@selector(sameNumOrNot:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:noSameNum];
    }
    
    //可重覆
    if (canSameNum == nil){
        canSameNum = [UIButton buttonWithType:UIButtonTypeCustom];
        [canSameNum setImage:[UIImage imageNamed:@"00_button-repeat up.png"] forState:UIControlStateNormal];
        [canSameNum setImage:[UIImage imageNamed:@"00_button-repeat down.png"] forState:UIControlStateSelected];
        [canSameNum setImage:[UIImage imageNamed:@"00_button-repeat down.png"] forState:UIControlStateHighlighted];
        [canSameNum setFrame:CGRectMake(pWidth(160), statusBarHeight + pWidth(20+5)+dressingView.frame.size.height,pWidth(86), pWidth(38))];
        CGPoint bCenter = canSameNum.center;
        bCenter.x = SCREEN_WIDTH/2 + pWidth(86)/2 + pWidth(20);
        canSameNum.center = bCenter;
        canSameNum.tag = 2;
        [canSameNum addTarget:self action:@selector(sameNumOrNot:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:canSameNum];
    }
    [self.view addSubview:backButton];
    [self.view addSubview:clearDataButton];

    if (treeImageView == nil){
        treeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - pWidth(151), SCREEN_HEIGHT - pWidth(174) - 4, pWidth(302), pWidth(174))];
        treeImageView.image = [UIImage imageNamed:@"1_tree.png"];
        [self.view addSubview:treeImageView];
    }
    [self.view addSubview:frameImageView];
    [self.view addSubview:mailToButton];
    //資料分析
    if (dataAnalyze == nil){
        dataAnalyze = [UIButton buttonWithType:UIButtonTypeCustom];
        [dataAnalyze setImage:[UIImage imageNamed:@"00_button-data up.png"] forState:UIControlStateNormal];
        [dataAnalyze setImage:[UIImage imageNamed:@"00_button-data down.png"] forState:UIControlStateSelected];
        [dataAnalyze setImage:[UIImage imageNamed:@"00_button-data down.png"] forState:UIControlStateHighlighted];
        [dataAnalyze setFrame:CGRectMake(SCREEN_WIDTH-pWidth(86), SCREEN_HEIGHT-pWidth(72),pWidth(86), pWidth(72))];
        [dataAnalyze addTarget:self action:@selector(dataAnalyze:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:dataAnalyze];
    }

    [self setBird];
    [self setNumBall];
    //搖號按鈕
    if (shakeButton == nil){
        shakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shakeButton setImage:[UIImage imageNamed:@"1_button-shake up.png"] forState:UIControlStateNormal];
        [shakeButton setImage:[UIImage imageNamed:@"1_button-shake down.png"] forState:UIControlStateSelected];
        [shakeButton setImage:[UIImage imageNamed:@"1_button-shake down.png"] forState:UIControlStateHighlighted];
        [shakeButton setFrame:CGRectMake(SCREEN_WIDTH/2-pWidth(36), SCREEN_HEIGHT-pWidth(74)-5,pWidth(72), pWidth(74))];
        [shakeButton addTarget:self action:@selector(shakeButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shakeButton];
    }
    [self.view bringSubviewToFront:backButton];
    [self.view bringSubviewToFront:clearDataButton];
}

-(void)deleteDataButton:(UIButton *)sender
{
    isFirstShake = NO;
    sender.selected = YES;
    sender.userInteractionEnabled = NO;
    [countArray removeAllObjects];
    [self clearWinds];
    [self makeBulrView];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
    {
        currentImageView.alpha = 1.0;
    } completion:^(BOOL finished)
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
        {
            currentImageView.alpha = 0.0;
        } completion:^(BOOL finished)
        {
                  sender.selected = NO;
                sender.userInteractionEnabled = YES;
        }];
    }];
}
-(void)dataAnalyze:(UIButton *)sender
{
    sender.selected = YES;
    [DEFAULTS setObject:[NSNumber numberWithInt:THREE_BALL_COUNT] forKey:@"AnalysisCellBallCount"];
    [DEFAULTS synchronize];
    star3AnalysisSubView.playType = [NSString stringWithFormat:@"%d",DBTYPE_STAR_3];
    star3AnalysisSubView.dataArray = [countArray mutableCopy];
    [self presentViewController:star3AnalysisSubView animated:YES completion:^
     {
         sender.selected = NO;
     }];
}
-(void)sameNumOrNot:(UIButton *)sender
{
    
    if (sender.tag%2 ==0)
    {
        NSLog(@"可重覆");
        if (spinSameNum != YES)
        {
            isFirstShake = NO;
            [self makeBulrView];
            [SINGLETON fadeInWithView:currentImageView];
            [SINGLETON fadeInWithView:customAlertView];
        }
        
    }else
    {
        NSLog(@"不可重覆");
        if (spinSameNum != NO)
        {
            isFirstShake = NO;
            [self makeBulrView];
            [SINGLETON fadeInWithView:currentImageView];
            [SINGLETON fadeInWithView:customAlertView];
        }
    }
}
-(void)shakeButton:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    sender.selected = YES;
    [self fourBigButtonCloseOrOpen:NO];

    __block int animationCount ;
    animationCount = 0;
    isSmall = !isSmall;
    float defaultFeatherX = pWidth(20);
    float defaultFeatherY = pWidth(60);
    CGPoint midFeaherCenter = middleFeather.center;
    for (UIImageView *currentView in self.view.subviews)
    {
        if ([currentView isKindOfClass:[UIImageView class]]&&currentView.tag)
        {
                if (isSmall)
                {//變小
                    [UIView animateWithDuration:0.3
                                          delay:0.0
                                        options:UIViewAnimationOptionBeginFromCurrentState
                                     animations:^
                     {
                         [self hideNumBall];
                         if (currentView.tag<300)
                         {
                             NSString *currentString = [[NSString stringWithFormat:@"%i",(int)currentView.tag] substringFromIndex:2];
                             float currentTag = [currentString floatValue];
                             if (currentTag<6)
                             {
                                 currentView.center = middleFeather.center;
                                 currentView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0)), .5, .5);
                             }else
                             {
                             }
                         }else
                         {
                             currentView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0)), 1, 1);
                             currentView.center = CGPointMake(currentView.center.x, currentView.center.y-30);
                         }

                     } completion:^(BOOL finished)
                     {
                             animationCount++;
                             if (animationCount == 17)
                             {
                                 sender.userInteractionEnabled = YES;
                                 [self fourBigButtonCloseOrOpen:YES];
                                 sender.selected = NO;
                                 [self resetNumArray:STAR3_PER_NUM];
                                 if (isFirstShake)
                                 {
                                     [self shakeButton:shakeButton];
                                 }
                                 
                         }
                     }];
                }else
                {//變大
                    isFirstShake = YES;

                    [UIView animateWithDuration:0.3
                                          delay:0.0
                                        options:UIViewAnimationOptionBeginFromCurrentState
                                     animations:^
                     {
                         if (currentView.tag>=200&&currentView.tag<300)
                         {//右邊
                             float currentTag = (float)(currentView.tag - 200);
                             if (currentTag<6)
                             {
                                 if (((int)currentTag%2)==0)
                                 {
                                     float viewX = (midFeaherCenter.x + defaultFeatherX + pWidth(58)*(3 - currentTag/2)*0.6) + pWidth(10)*(currentTag/2);
                                     float viewY = midFeaherCenter.y + defaultFeatherY + pWidth(10)*(3 - currentTag/2) - pWidth(10)*(currentTag/2);
                                     NSLog(@"右邊大羽 viewX :%f , viewY :%f ",viewX,viewY);
                                     currentView.center = CGPointMake(viewX, viewY);
                                 }else
                                 {
                                     float viewX = (midFeaherCenter.x + defaultFeatherX + pWidth(56)*(3 - currentTag/2)*0.6) + pWidth(10)*(currentTag/2);
                                     float viewY = midFeaherCenter.y + defaultFeatherY + pWidth(14)*(3 - currentTag/2) - pWidth(10)*(currentTag/2) ;
                                     NSLog(@"右邊小羽 viewX :%f , viewY :%f ",viewX,viewY);
                                     currentView.center = CGPointMake(viewX, viewY);
                                 }
                             
                                 currentView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(DEGREES_TO_RADIANS((68-currentTag*8))), 0.5*((float)(6+2.5*currentTag/3)/10), 0.5*((float)(6+2.5*currentTag/3)/10));
                             }
                         }else if(currentView.tag<200)
                         {//左邊
                             float currentTag = (float)(currentView.tag - 100);
                             if (currentTag<6)
                             {
                                 if (((int)currentTag%2)==0)
                                 {
                                     float viewX = SCREEN_WIDTH - ((midFeaherCenter.x + defaultFeatherX + pWidth(58)*(3 - currentTag/2)*0.6) + pWidth(10)*(currentTag/2));
                                     float viewY = midFeaherCenter.y + defaultFeatherY + pWidth(10)*(3 - currentTag/2) - pWidth(10)*(currentTag/2);
                                     NSLog(@"左邊大羽 viewX :%f , viewY :%f ",viewX,viewY);
                                     currentView.center = CGPointMake(viewX, viewY);
                                 }else
                                 {
                                     float viewX = SCREEN_WIDTH - ((midFeaherCenter.x + defaultFeatherX + pWidth(56)*(3 - currentTag/2)*0.6) + pWidth(10)*(currentTag/2));
                                     float viewY = midFeaherCenter.y + defaultFeatherY + pWidth(14)*(3 - currentTag/2) - pWidth(10)*(currentTag/2) ;
                                     NSLog(@"左邊小羽 viewX :%f , viewY :%f ",viewX,viewY);
                                     currentView.center = CGPointMake(viewX, viewY);
                                 }
                                 currentView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-(68-currentTag*8))), 0.5*((float)(6+2.5*currentTag/3)/10), 0.5*((float)(6+2.5*currentTag/3)/10));
                             }
                         }else
                         {
                             currentView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0)), 1.25, 1.25);
                             currentView.center = CGPointMake(currentView.center.x, currentView.center.y+30);
                         }
                     } completion:^(BOOL finished)
                     {
                         if (finished)
                         {
                             animationCount++;
                             if (animationCount ==17)
                             {
                                 sender.userInteractionEnabled = YES;
                                 sender.selected = NO;
                                 //開始 甩點數
                                 [self star3Spin];
                             }
                         }
                     }];
                }
        }
    }
}
-(void)setBird
{
    //放鳥
    //鳥身
    float birdBodyTop = CGRectGetMinY(treeImageView.frame) - pWidth(180*0.47);
    birdBody = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-pWidth(28), birdBodyTop, pWidth(80), pWidth(180))];
    birdBody.image = [UIImage imageNamed:@"1_bird's body.png"];
    [self.view addSubview:birdBody];
    //左翼
    float birdWindLeftTop = CGRectGetMinY(birdBody.frame) + pWidth(18);
    birdWindLeft = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-pWidth(85), birdWindLeftTop, pWidth(110), pWidth(134))];
    birdWindLeft.image = [UIImage imageNamed:@"1_bird's wing-L.png"];
    [self.view addSubview:birdWindLeft];
    //右翼
    float birdWindRightTop = CGRectGetMinY(birdBody.frame) + pWidth(40);
    birdWindRight = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+pWidth(13), birdWindRightTop, pWidth(58), pWidth(114))];
    birdWindRight.image = [UIImage imageNamed:@"1_bird's wing-R.png"];
    [self.view addSubview:birdWindRight];
    //羽毛
    //中間
    float middleFeatherTop = CGRectGetMinY(birdBody.frame) - pWidth(210);
    if (middleFeather == nil)
    {
        middleFeather = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-pWidth(29),middleFeatherTop, pWidth(56), pWidth(230))];
        middleFeather.image = [UIImage imageNamed:@"1_bird's feather-1.png"];
        middleFeather.tag = 300;
        //    NSLog(@"center :%@",NSStringFromCGPoint(middleFeather.center));
        [self.view addSubview:middleFeather];
    }
//左半邊
    float midFeaherOneTop = CGRectGetMinY(birdBody.frame) - pWidth(180);
    float midFeaherTwoTop = CGRectGetMinY(birdBody.frame) - pWidth(190);
    float midFeaherLeft = CGRectGetMinX(middleFeather.frame);
    float midFeaherRight = CGRectGetMaxX(middleFeather.frame);
    float midFeaherCenterY = CGRectGetMinY(birdBody.frame) - pWidth(105);
    for (float i = 0; i<8; i++)
    {
        UIImageView *feahers = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"1_bird's feather-%i.png",((int)i%2)==0?1:2]]];
        if (i>5)
        {
            if (((int)i%2)==0)
            {
                [feahers setFrame:CGRectMake(midFeaherLeft - pWidth(45),
                                             midFeaherOneTop,
                                             pWidth(56),
                                             pWidth(230))];
            }else
            {
                [feahers setFrame:CGRectMake(midFeaherLeft - pWidth(15),
                                             midFeaherTwoTop,
                                             pWidth(26),
                                             pWidth(226))];
            }
            feahers.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-(68-i*8))), 1*((float)(6+2.5*i/3)/10), 1*((float)(6+2.5*i/3)/10));
        }else
        {
            feahers.center = CGPointMake(SCREEN_WIDTH/2, midFeaherCenterY);
            feahers.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0)), .5, .5);
        }
        feahers.tag = (100+i);

        [self.view addSubview:feahers];
    }
//右半邊
    for (float i = 0; i<8; i++)
    {
        UIImageView *feahers = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"1_bird's feather-%i.png",((int)i%2)==0?1:2]]];
        if (i>5)
        {
            if (((int)i%2)==0)
            {
                [feahers setFrame:CGRectMake(midFeaherRight + pWidth(45) - pWidth(56),
                                             midFeaherOneTop,
                                             pWidth(56),
                                             pWidth(230))];
            }else
            {
                [feahers setFrame:CGRectMake(midFeaherRight + pWidth(15) - pWidth(26),
                                             midFeaherTwoTop,
                                             pWidth(26),
                                             pWidth(226))];
            }
            feahers.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(DEGREES_TO_RADIANS((68-i*8))), 1*((float)(6+2.5*i/3)/10), 1*((float)(6+2.5*i/3)/10));
        }else
        {
            feahers.center = CGPointMake(SCREEN_WIDTH/2, midFeaherCenterY);
            feahers.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0)), .5, .5);
        }
        feahers.tag = (200+i);
        [self.view addSubview:feahers];
    }

    [self.view bringSubviewToFront:middleFeather];
    [self.view bringSubviewToFront:birdWindLeft];
    [self.view bringSubviewToFront:birdWindRight];
    [self.view bringSubviewToFront:birdBody];
}
#pragma mark -
#pragma mark 三星彩 開始甩
-(void)star3Spin
{
    if (spinSameNum)
    {
        for (int i = 0; i<10; i++)
        {
            int rand = (arc4random() % STAR3_PER_NUM);
            NSNumber *randNumber=[numArray objectAtIndex:rand];
            [numArray replaceObjectAtIndex:i withObject:randNumber];
        }
    }else
    {
        for (int i = 0; i<10; i++)
        {
            int rand = (arc4random() % STAR3_PER_NUM);
            if (i!=rand)
            {
                NSNumber *temp = [numArray objectAtIndex:i];
                NSNumber *randNumber=[numArray objectAtIndex:rand];
                [numArray replaceObjectAtIndex:i withObject:randNumber];
                [numArray replaceObjectAtIndex:rand withObject:temp];
            }
        }
    }
    [self showNumBall];
    NSLog(@"numArray :%@",numArray);
}

-(void)setNumBall
{
    numBallTwo = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - pWidth(50), SCREEN_HEIGHT*0.3, pWidth(100), pWidth(100))];
    float middelLeft = CGRectGetMinX(numBallTwo.frame);
    float middelRight = CGRectGetMaxX(numBallTwo.frame);
    numBallOne = [[UIImageView alloc] initWithFrame:CGRectMake(middelLeft - pWidth(100) - pWidth(20), SCREEN_HEIGHT*0.4, pWidth(100), pWidth(100))];
    numBallThree = [[UIImageView alloc] initWithFrame:CGRectMake(middelRight + pWidth(20),SCREEN_HEIGHT*0.4, pWidth(100), pWidth(100))];
    numBallOne.alpha = 0.0;
    numBallTwo.alpha = 0.0;
    numBallThree.alpha = 0.0;
    [self.view addSubview:numBallOne];
    [self.view addSubview:numBallTwo];
    [self.view addSubview:numBallThree];
}
-(void)showNumBall
{
    numBallOne.image = [UIImage imageNamed:[NSString stringWithFormat:@"00_ball %@.png",[numArray objectAtIndex:0]]];
    numBallTwo.image = [UIImage imageNamed:[NSString stringWithFormat:@"00_ball %@.png",[numArray objectAtIndex:1]]];
    numBallThree.image = [UIImage imageNamed:[NSString stringWithFormat:@"00_ball %@.png",[numArray objectAtIndex:2]]];
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^
    {
        numBallOne.alpha = 1.0;
        numBallTwo.alpha = 1.0;
        numBallThree.alpha = 1.0;
    } completion:^(BOOL finished)
    {
        [self saveBallRecord];
    }];
}
-(void)saveBallRecord
{
    NSArray *firstThreeArray = [numArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
    [countArray addObject:firstThreeArray];
    [self fourBigButtonCloseOrOpen:YES];
}
-(void)hideNumBall
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
         numBallOne.alpha = 0.0;
         numBallTwo.alpha = 0.0;
         numBallThree.alpha = 0.0;
     } completion:nil];
}
-(void)makeBulrView
{
    if (currentImageView == nil)
    {
        currentImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        currentImageView.alpha = 0.0;
        [self.view addSubview:currentImageView];
    }
    UIGraphicsBeginImageContext(self.view.bounds.size);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    currentImageView.image = [viewImage stackBlur:5];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (customAlertView.alpha == 1.0)
    {
        [self allertButtonAction:[UIButton buttonWithType:UIButtonTypeCustom]];
    }
}
-(void)makeCustomAlertView
{
    if (customAlertView == nil)
    {
        customAlertView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - pWidth(158), SCREEN_HEIGHT/2 - pWidth(106), pWidth(316), pWidth(212))];
        customAlertView.image = [UIImage imageNamed:@"00_FloatingWindow-fan.png"];
        customAlertView.alpha = 0.0;
        //警告標語
        UIImageView *stringImage = [[UIImageView alloc] initWithFrame:CGRectMake(customAlertView.frame.size.width/2-104, 30, 208, 52)];
        stringImage.image = [UIImage imageNamed:@"00_FloatingWindow-word 2.png"];
        [customAlertView addSubview:stringImage];
        //確認按鈕
        UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [yesButton setFrame:CGRectMake(customAlertView.frame.size.width/2-62, 90, 124, 52)];
        [yesButton setImage:[UIImage imageNamed:@"00_FloatingWindow-delete up.png"] forState:UIControlStateNormal];
        [yesButton setImage:[UIImage imageNamed:@"00_FloatingWindow-delete down.png"] forState:UIControlStateHighlighted];
        [customAlertView addSubview:yesButton];
        
        //取消按鈕
        UIButton *noButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [noButton setFrame:CGRectMake(customAlertView.frame.size.width/2-16, 162, 32, 34)];
        [noButton setImage:[UIImage imageNamed:@"00_FloatingWindow-X up.png"] forState:UIControlStateNormal];
        [noButton setImage:[UIImage imageNamed:@"00_FloatingWindow-X down.png"] forState:UIControlStateHighlighted];
        [customAlertView addSubview:noButton];
        [yesButton addTarget:self action:@selector(allertButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [noButton addTarget:self action:@selector(allertButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        yesButton.tag = 500;
        noButton.tag = 1000;
        customAlertView.userInteractionEnabled=YES;
        [self.view addSubview:customAlertView];
    }
}
-(void)allertButtonAction:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 500:
            spinSameNum = !spinSameNum;
            canSameNum.selected = !canSameNum.selected;
            noSameNum.selected = !noSameNum.selected;
            [self resetNumArray:STAR3_PER_NUM];
            currentImageView.image = [currentImageView.image normalize];
            [SINGLETON fadeOutWithView:currentImageView];
            [SINGLETON fadeOutWithView:customAlertView];
            [countArray removeAllObjects];
            [self clearWinds];
            break;
        default:
            currentImageView.image = [currentImageView.image normalize];
            [SINGLETON fadeOutWithView:currentImageView];
            [SINGLETON fadeOutWithView:customAlertView];
            break;
    }
}
-(void)clearWinds
{
    if (!isSmall)
    {
        [self shakeButton:shakeButton];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventSubtypeMotionShake )
    {
        [self shakeButton:shakeButton];
    }
    
    if ([super respondsToSelector:@selector(motionEnded:withEvent:)]) {
        [super motionEnded:motion withEvent:event];
    }
}
-(void)teachYouHowToPlay
{
    //背景模糊
    [self makeBulrView];
    [self fourBigButtonCloseOrOpen:NO];
    [SINGLETON fadeInWithView:currentImageView];
    //秀出 畫面
    if (redArrow == nil)
    {
        redArrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-73, SCREEN_HEIGHT/2-72, 146, 72)];
        redArrow.image = [UIImage imageNamed:@"00_ShakeThePhone-arrow.png"];
        [self.view addSubview:redArrow];
    }
    if (readyShakePhone == nil)
    {
        readyShakePhone = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, SCREEN_HEIGHT/2, 80, 152)];
        readyShakePhone.image = [UIImage imageNamed:@"00_ShakeThePhone-phone.png"];
        readyShakePhone.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-10));
        [self.view addSubview:readyShakePhone];
    }

    [UIView animateWithDuration:0.3
                          delay:0
                        options:
     UIViewAnimationOptionBeginFromCurrentState|     
     UIViewAnimationOptionAutoreverse |
     UIViewAnimationOptionCurveEaseInOut
                     animations:^
    {
        [UIView setAnimationRepeatCount:1];
        readyShakePhone.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(10));

    } completion:^(BOOL finished)
    {
        readyShakePhone.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-10));
        [self dismissRedArrow];
    }];

}
-(void)dismissRedArrow
{
    currentImageView.image = [currentImageView.image normalize];
    [SINGLETON fadeOutWithView:currentImageView];
    [SINGLETON fadeOutWithView:readyShakePhone];
    [SINGLETON fadeOutWithView:redArrow];
    [self fourBigButtonCloseOrOpen:YES];
}
-(void)makeFeatherMove
{
    for (UIImageView *currentView in self.view.subviews)
    {
     if ([currentView isKindOfClass:[UIImageView class]]&&currentView.tag)
     {
         [UIView animateWithDuration:0.1
                               delay:0.0
                             options:
          UIViewAnimationOptionBeginFromCurrentState|
          UIViewAnimationOptionAutoreverse
                          animations:^
                            {
                                if (currentView.tag<300)
                                {
                                    NSString *currentString = [[NSString stringWithFormat:@"%i",(int)currentView.tag] substringFromIndex:2];
                                    float currentTag = [currentString floatValue];
                                    if (currentTag>5)
                                    {
                                        CGFloat radians = atan2f(currentView.transform.b, currentView.transform.a);
                                        CGFloat degrees = radians * (180 / M_PI);

                                        NSLog(@"%f",degrees);
                                        currentView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees)), 1.1, 1.1);
                                        currentView.animationRepeatCount = 1;
                                    }
                                }
                             }
                          completion:nil];
     }
    }
}
-(void)setAnalysisSubView
{
    if (star3AnalysisSubView == nil)
    {
        star3AnalysisSubView = [[GloBalAnalysisViewController alloc] init];
        star3AnalysisSubView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        star3AnalysisSubView.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}
-(void)fourBigButtonCloseOrOpen:(BOOL)asYouWish
{
    backButton.userInteractionEnabled = asYouWish;
    clearDataButton.userInteractionEnabled = asYouWish;
    dataAnalyze.userInteractionEnabled = asYouWish;
    mailToButton.userInteractionEnabled = asYouWish;
    canSameNum.userInteractionEnabled = asYouWish;
    noSameNum.userInteractionEnabled = asYouWish;
    shakeButton.userInteractionEnabled = asYouWish;
}
-(NSArray *)makeActivityItems
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return [NSArray arrayWithObjects:viewImage, nil];
}
- (void)didChangeStatusBarFrame:(NSNotification*)notification
{
    NSValue*statusBarFrameValue = [notification.userInfo valueForKey:UIApplicationStatusBarFrameUserInfoKey];
    CGRect statusBarFrame =[statusBarFrameValue CGRectValue];
    barHeight = statusBarFrame.size.height;
    CGRect mainViewRect = mainBackImageView.frame;
    CGRect birdViewRect = treeImageView.frame;
    CGRect frameViewRect = frameImageView.frame;
    //206
    CGRect shakeButtonFrame = shakeButton.frame;
    CGRect mailButtonFrame = mailToButton.frame;
    CGRect dataAnalyzeButtonFrame = dataAnalyze.frame;
    mainViewRect.size.height = SCREEN_HEIGHT-statusBarHeight;
    birdViewRect.origin.y = SCREEN_HEIGHT-(154+statusBarHeight)-4;
    frameViewRect.size.height = SCREEN_HEIGHT-statusBarHeight-dressingView.frame.size.height;
    shakeButtonFrame.origin.y = SCREEN_HEIGHT-(54+statusBarHeight)-5;
    mailButtonFrame.origin.y = SCREEN_HEIGHT-(92+statusBarHeight);
    dataAnalyzeButtonFrame.origin.y = SCREEN_HEIGHT-(52+statusBarHeight);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
     {
         [mainBackImageView setFrame:mainViewRect];
         [treeImageView setFrame:birdViewRect];
         [frameImageView setFrame:frameViewRect];
         [shakeButton setFrame:shakeButtonFrame];
         [mailToButton setFrame:mailButtonFrame];
         [dataAnalyze setFrame:dataAnalyzeButtonFrame];
     } completion:nil];
}
@end
