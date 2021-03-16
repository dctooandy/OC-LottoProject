//
//  WeiLiViewController.m
//  Lotto
//
//  Created by brownie on 2014/2/6.
//  Copyright (c) 2014年 brownieBBK. All rights reserved.
//

#import "WeiLiViewController.h"
#import "Constant.h"
@interface WeiLiViewController ()
{
    BOOL disMode;
    UIButton *dataAnalyze;
    UIImageView *buttonButtom;
    //號碼
    UIButton *shakeButton;
    UIImageView *treeImageView;
    int treeNumber;
    
    NSMutableSet *disNumSet;
    UIImageView *numBallOne;
    UIImageView *numBallTwo;
    UIImageView *numBallThree;
    UIImageView *numBallFour;
    UIImageView *numBallFive;
    UIImageView *numBallSix;
    UIImageView *subNumBallOne;
    UILabel *disModeLabel;
    UILabel *subNumLabel;
    GloBalAnalysisViewController *weiliAnalysisSubView;
    //2/6
    UIImageView *currentImageView;
}
@end

@implementation WeiLiViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor orangeColor];
        [self setUI];
        [self setAnalysisSubView];
        treeNumber = 2;
        disNumSet = [[NSMutableSet alloc] init];
        disMode = NO;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self becomeFirstResponder];        
    //刪除三步驟
    //號碼消除
    [self resetNumArray:WeiLiBallCount];
    //樹消除
    [self makeTree];
    //球消除
    [self hideNumBall];
    //標簽消除
    [self dismissCountNumberInNumberImageView];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self shakeBefore];
    [self nowShake];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //號碼圖 暫時消除
    [self hideNumberImageView];
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
- (void)didChangeStatusBarFrame:(NSNotification*)notification
{
    CGRect mainViewRect = mainBackImageView.frame;
    CGRect frameViewRect = frameImageView.frame;
    mainViewRect.size.height = SCREEN_HEIGHT-statusBarHeight;
    frameViewRect.size.height = SCREEN_HEIGHT-statusBarHeight-dressingView.frame.size.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
     {
        [mainBackImageView setFrame:mainViewRect];
        [frameImageView setFrame:frameViewRect];
    } completion:nil];
}
-(void)setUI
{
    [super setUI];
    [self.view addSubview:mainBackImageView];
    [self.view addSubview:dressingView];
    [self makeTree];
    [self.view addSubview:frameImageView];
    [self.view addSubview:backButton];
    [self.view addSubview:clearDataButton];
    currentNumberImageView.image = [UIImage imageNamed:@"3_number of times.png"];
    [self setNumberInNumImageView:SIX_BALL_COUNT];
    [self.view addSubview:currentNumberImageView];
    [currentNumberImageView addSubview:countLabel];
    [self.view addSubview:mailToButton];
    disModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, pHeight(3), pWidth(80), pWidth(10))];
    [disModeLabel setCenter:CGPointMake([countLabel center].x,  pHeight(7)) ];
    disModeLabel.textAlignment = NSTextAlignmentCenter;
    disModeLabel.backgroundColor = [UIColor clearColor];
    disModeLabel.textColor = [UIColor blackColor];
    disModeLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:10.0];
    [currentNumberImageView addSubview:disModeLabel];

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
    //放球
    [self setNumBall];
    //按鈕外壺
    buttonButtom = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-pWidth(73), SCREEN_HEIGHT-pWidth(110), pWidth(146), pWidth(106))];
    buttonButtom.image = [UIImage imageNamed:@"3_vase.png"];
    [self.view addSubview:buttonButtom];
    //搖號按鈕
    shakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shakeButton setImage:[UIImage imageNamed:@"3_Button-up.png"] forState:UIControlStateNormal];
    [shakeButton setImage:[UIImage imageNamed:@"3_Button-down.png"] forState:UIControlStateSelected];
    [shakeButton setImage:[UIImage imageNamed:@"3_Button-down.png"] forState:UIControlStateHighlighted];
    [shakeButton setFrame:CGRectMake(SCREEN_WIDTH/2-pWidth(42.5), SCREEN_HEIGHT-pWidth(99),pWidth(83), pWidth(83))];
    [shakeButton addTarget:self action:@selector(shakeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shakeButton];
}

-(void)disNumMode
{
    disMode = !disMode;
    NSLog(@"disMode : %@", (disMode == YES) ? @"篩選模式": @"非篩選模式" );
    [disModeLabel setText:(disMode == YES) ? @"篩     選":@""];
    [disNumSet removeAllObjects];
}
-(void)deleteDataButton:(UIButton *)sender
{
    sender.selected = YES;
    [self makeBulrView];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         currentImageView.alpha = 1.0;
         
     } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
          {
             //刪除三步驟
             //號碼消除
             [self resetNumArray:WeiLiBallCount];
             //樹消除
             [self makeTree];
             //球消除
             [self hideNumBall];
             //標簽消除
             [self dismissCountNumberInNumberImageView];
             currentImageView.alpha = 0.0;
         } completion:^(BOOL finished)
          {
             sender.selected = NO;
         }];
     }];
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
-(void)dataAnalyze:(UIButton *)sender
{
    [DEFAULTS setObject:[NSNumber numberWithInt:WEI_LI_BALL_COUNT] forKey:@"AnalysisCellBallCount"];
    [DEFAULTS synchronize];
    sender.selected = YES;
    weiliAnalysisSubView.playType = [NSString stringWithFormat:@"%d",DBTYPE_WEI_LI];
    weiliAnalysisSubView.dataArray = [countArray mutableCopy];
    [self presentViewController:weiliAnalysisSubView animated:YES completion:^
     {
         sender.selected = NO;
     }];
}
#define DBL_EPSILON __DBL_EPSILON__
-(void)makeTree
{
    if (treeImageView == nil)
    {
        float treeHeight = SCREEN_HEIGHT-statusBarHeight*2-pWidth(110)-pHeight(26)*2-pHeight(86);
        treeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-pWidth(158), statusBarHeight*2+pHeight(26)*2+pHeight(86), pWidth(320), treeHeight)];
        [self.view addSubview:treeImageView];
    }
    treeImageView.image = [UIImage imageNamed:@"tree0001.png"];
}
-(void)shakeBefore
{
    [self fourBigButtonCloseOrOpen:NO];
    [self showNumberImageView];
}
-(void)nowShake
{
    if (treeNumber ==2)
    {
        [self hideNumBall];
    }
    if (treeNumber>29)
    {
        treeImageView.image = [UIImage imageNamed:@"tree0030.png"];
        treeNumber = 2;
        shakeButton.userInteractionEnabled = YES;
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             shakeButton.alpha = 0.0;
         } completion:^(BOOL finished)
         {
             shakeButton.selected = NO;
             shakeButton.alpha = 1.0;
             shakeButton.transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
             [self shakeStick];
         }];
        
        //算球
        [self weiliSpin];
        //秀球
        [self showNumBall];
        
    }else
    {
        if (treeNumber<3)
        {
            [self turnRunShakeButton];
        }
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             treeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"tree00%i",treeNumber]];
         } completion:^(BOOL finished)
         {
             treeNumber++;
             [self performSelector:@selector(nowShake) withObject:nil afterDelay:0.05];
         }];
    }
}
-(void)shakeButton:(UIButton *)sender
{
    [self shakeBefore];
    [self nowShake];
}

#pragma mark -
#pragma mark 威力彩 開始甩
-(void)weiliSpin
{
    int totalNum = WeiLiBallCount;
    if (disMode == YES)
    {
        NSMutableArray * newNumArray = [[NSMutableArray alloc] init];
        for (int i = 1; i <= WeiLiBallCount; i++)
        {
            [newNumArray addObject: [NSNumber numberWithInt:i]];
        }
        for (NSNumber* i in [disNumSet allObjects])
        {
            if ([newNumArray containsObject:i] == YES)
            {
                [newNumArray removeObject:i];
            }
        }
        if (([[disNumSet allObjects] count] + 6) <= 49)
        {
            totalNum -= [[disNumSet allObjects] count];
        }
        numArray = newNumArray;
        if ([numArray count] < 6)
        {
            totalNum = 6;
            do {
                [numArray addObject:[NSNumber numberWithInt:0]];
            } while ([numArray count] < 6);
            
        }
        for (int i = totalNum; i > 1; i--)
        {
            [numArray exchangeObjectAtIndex:i - 1 withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
        }
    }else
    {
        for (int i = 0; i<WeiLiBallCount; i++)
        {
            int rand = (arc4random() % WeiLiBallCount);
            if (i!=rand)
            {
                NSNumber *temp = [numArray objectAtIndex:i];
                NSNumber *randNumber=[numArray objectAtIndex:rand];
                [numArray replaceObjectAtIndex:i withObject:randNumber];
                [numArray replaceObjectAtIndex:rand withObject:temp];
            }
            
        }
    }
}
#pragma mark -
#pragma mark 製作球
-(void)setNumBall
{
    float defaultHeight = [treeImageView frame].size.height;
    float defaultTopOffset = statusBarHeight*2+pHeight(26)*2+pHeight(86);
    numBallOne = [[UIImageView alloc] initWithFrame:CGRectMake(pWidth(50)*375/320, defaultTopOffset+(defaultHeight*0.1), pWidth(60), pWidth(60))];
    numBallTwo = [[UIImageView alloc] initWithFrame:CGRectMake(pWidth(50)*375/320, defaultTopOffset+(defaultHeight*0.35), pWidth(70), pWidth(70))];
    numBallThree = [[UIImageView alloc] initWithFrame:CGRectMake(pWidth(30)*375/320, defaultTopOffset+(defaultHeight*0.7), pWidth(60), pWidth(60))];
    numBallFour = [[UIImageView alloc] initWithFrame:CGRectMake(pWidth(180)*375/320, defaultTopOffset+(defaultHeight*0.2), pWidth(80), pWidth(80))];
    numBallFive = [[UIImageView alloc] initWithFrame:CGRectMake(pWidth(240)*375/320, defaultTopOffset+(defaultHeight*0.4), pWidth(60), pWidth(60))];
    numBallSix = [[UIImageView alloc] initWithFrame:CGRectMake(pWidth(180)*375/320, defaultTopOffset+(defaultHeight*0.8), pWidth(65), pWidth(65))];

    
    CGPoint subBallRect = CGPointMake(CGRectGetMaxX(numBallThree.frame), CGRectGetMaxY(numBallThree.frame));
    subNumBallOne = [[UIImageView alloc] initWithFrame:CGRectMake(subBallRect.x -5, subBallRect.y, 35, 35)];

    subNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 10)];
    [subNumLabel setCenter:CGPointMake([subNumBallOne center].x,  [subNumBallOne center].y + 20) ];
    subNumLabel.textAlignment = NSTextAlignmentCenter;
    subNumLabel.backgroundColor = [UIColor clearColor];
    subNumLabel.textColor = [UIColor whiteColor];
    subNumLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:10.0];
    subNumLabel.text = @"特別號";
    
    numBallOne.alpha = 0.0;
    numBallTwo.alpha = 0.0;
    numBallThree.alpha = 0.0;
    numBallFour.alpha = 0.0;
    numBallFive.alpha = 0.0;
    numBallSix.alpha = 0.0;
    subNumBallOne.alpha = 0.0;
    subNumLabel.alpha = 0.0;
    [self.view addSubview:numBallOne];
    [self.view addSubview:numBallTwo];
    [self.view addSubview:numBallThree];
    [self.view addSubview:numBallFour];
    [self.view addSubview:numBallFive];
    [self.view addSubview:numBallSix];
    [self.view addSubview:subNumBallOne];
    [self.view addSubview:subNumLabel];
}
-(void)showNumBall
{
    numBallOne.image = [UIImage imageNamed:[NSString stringWithFormat:@"00_ball %@.png",[numArray objectAtIndex:0]]];
    numBallTwo.image = [UIImage imageNamed:[NSString stringWithFormat:@"00_ball %@.png",[numArray objectAtIndex:1]]];
    numBallThree.image = [UIImage imageNamed:[NSString stringWithFormat:@"00_ball %@.png",[numArray objectAtIndex:2]]];
    numBallFour.image = [UIImage imageNamed:[NSString stringWithFormat:@"00_ball %@.png",[numArray objectAtIndex:3]]];
    numBallFive.image = [UIImage imageNamed:[NSString stringWithFormat:@"00_ball %@.png",[numArray objectAtIndex:4]]];
    numBallSix.image = [UIImage imageNamed:[NSString stringWithFormat:@"00_ball %@.png",[numArray objectAtIndex:5]]];
    int rand = (arc4random() % WeiLiSubBallCount);
    subNumBallOne.image = [UIImage imageNamed:[NSString stringWithFormat:@"00_ball %d.png",rand]];
    [disNumSet addObject:[numArray objectAtIndex:0]];
    [disNumSet addObject:[numArray objectAtIndex:1]];
    [disNumSet addObject:[numArray objectAtIndex:2]];
    [disNumSet addObject:[numArray objectAtIndex:3]];
    [disNumSet addObject:[numArray objectAtIndex:4]];
    [disNumSet addObject:[numArray objectAtIndex:5]];
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
        numBallOne.alpha = 1.0;
        numBallTwo.alpha = 1.0;
        numBallThree.alpha = 1.0;
        numBallFour.alpha = 1.0;
        numBallFive.alpha = 1.0;
        numBallSix.alpha = 1.0;
        subNumBallOne.alpha = 1.0;
        subNumLabel.alpha = 1.0;
     } completion:^(BOOL finished)
     {
         [self changeCountLabel];
     }];
    //    NSLog(@"Big_lotto :%@",numArray);
}
-(void)changeCountLabel
{
    NSArray *firstSixArray = [numArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 6)]];
    [countArray addObject:firstSixArray];
    NSLog(@"第 %i 次",(int)[countArray count]);
    countLabel.text = [NSString stringWithFormat:@"%i",(int)[countArray count]];
    [self changeNumberInNumImageView];
    [self fourBigButtonCloseOrOpen:YES];
}
-(void)hideNumBall
{
    [UIView animateWithDuration:0.05
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
        numBallOne.alpha = 0.0;
        numBallTwo.alpha = 0.0;
        numBallThree.alpha = 0.0;
        numBallFour.alpha = 0.0;
        numBallFive.alpha = 0.0;
        numBallSix.alpha = 0.0;
        subNumBallOne.alpha = 0.0;
        subNumLabel.alpha = 0.0;
     } completion:nil];
}
-(void)changeNumberInNumImageView
{
    NSMutableIndexSet *currentIndexSet = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 6)];
    
    NSArray *firstSixArray = [[NSArray arrayWithArray:[numArray objectsAtIndexes:currentIndexSet]] sortedArrayUsingSelector:@selector(compare:)];
    for (UIImageView *matchImageView in currentNumberImageView.subviews)
    {
        if ([matchImageView isKindOfClass:[UIImageView class]]&&matchImageView.tag)
        {
            matchImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"00_ball %@.png",[firstSixArray objectAtIndex:matchImageView.tag-1]]];
        }
    }
}
-(void)dismissCountNumberInNumberImageView
{
    //標簽刪除
    countLabel.text = @"";
    //號碼球消失
    for (UIImageView *matchImageView in currentNumberImageView.subviews)
    {
        if ([matchImageView isKindOfClass:[UIImageView class]]&&matchImageView.tag)
        {
            matchImageView.image = nil;
        }
    }
}
-(void)turnRunShakeButton
{
    shakeButton.selected = YES;
    shakeButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:2.5
                          delay:0
                        options:
     UIViewAnimationOptionBeginFromCurrentState|
     UIViewAnimationOptionCurveLinear
                     animations:^
     {
         shakeButton.transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
     } completion:^(BOOL finished)
     {
     }];
}
-(void)setAnalysisSubView
{
    if (weiliAnalysisSubView == nil)
    {
        weiliAnalysisSubView = [[GloBalAnalysisViewController alloc] init];
        weiliAnalysisSubView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        weiliAnalysisSubView.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}
-(void)showNumberImageView
{
    CGRect numberImageViewRect = currentNumberImageView.frame;
    numberImageViewRect.origin.y = pHeight(64) + statusBarHeight;
    if (currentNumberImageView.alpha == 0)
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
         {
             currentNumberImageView.alpha = 1.0;
             [currentNumberImageView setFrame:numberImageViewRect];
         } completion:^(BOOL finished)
         {
             
         }];
    }
}
-(void)hideNumberImageView
{
    CGRect numberImageViewRect = currentNumberImageView.frame;
    numberImageViewRect.origin.y = -pHeight(84);
    currentNumberImageView.alpha = 0.0;
    [currentNumberImageView setFrame:numberImageViewRect];
}
-(void)fourBigButtonCloseOrOpen:(BOOL)asYouWish
{
    backButton.userInteractionEnabled = asYouWish;
    clearDataButton.userInteractionEnabled = asYouWish;
    dataAnalyze.userInteractionEnabled = asYouWish;
    mailToButton.userInteractionEnabled = asYouWish;
}
-(NSArray *)makeActivityItems
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return [NSArray arrayWithObjects:viewImage, nil];
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
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
-(void)shakeStick
{
    [UIView animateWithDuration:0.2
                          delay:1
                        options:
     UIViewAnimationOptionBeginFromCurrentState|
     UIViewAnimationOptionAutoreverse |
     UIViewAnimationOptionCurveLinear |
     UIViewAnimationOptionAllowUserInteraction
                     animations:^
     {
         [UIView setAnimationRepeatCount:7];
         shakeButton.transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-10));
     } completion:^(BOOL finished)
     {
         if (finished)
         {
             shakeButton.transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
         }
     }];
}

@end
