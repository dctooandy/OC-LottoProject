//
//  BingoViewController.m
//  Lotto
//
//  Created by brownie on 2014/1/28.
//  Copyright (c) 2014年 brownieBBK. All rights reserved.
//

#import "BingoViewController.h"
#import "Constant.h"
@interface BingoViewController ()
{
    UIButton *dataAnalyze;
    UIImageView *buttonButtom;
    UIButton *shakeButton;
    BOOL isKnocked;
    NSMutableArray *bingoArray;
    //2/6
    GloBalAnalysisViewController *bingoAnalysisSubView;
    //2/6
    UIImageView *currentImageView;
}
@end

@implementation BingoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor orangeColor];
        bingoArray = [[NSMutableArray alloc] init];
        [self setUI];
        [self setAnalysisSubViewAtBingoView];        
        isKnocked = NO;
        [self resetEggNum];
        [self setRandNumOnBall];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self becomeFirstResponder];    
    [countArray removeAllObjects];
    if (isKnocked)
    {
        [shakeButton setImage:[UIImage imageNamed:@"6_Button-down.png"] forState:UIControlStateNormal];
        [shakeButton setImage:[UIImage imageNamed:@"6_Button-down.png"] forState:UIControlStateSelected];
        isKnocked = NO;
        [self closeEgg];
        [self resetEggNum];
        [self setRandNumOnBall];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self shakeStick];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
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
    float barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    if (barHeight>20)
    {
        barHeight = 40.0;
    }else
    {
        barHeight = 20.0;
    }
    [super setUI];
    [self.view addSubview:mainBackImageView];
    [self.view addSubview:dressingView];
    [self makeBranchAndEgg];
    [self.view addSubview:backButton];
    [self.view addSubview:clearDataButton];
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
    

    //搖號按鈕
    shakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shakeButton setImage:[UIImage imageNamed:@"6_Button-down.png"] forState:UIControlStateNormal];
    [shakeButton setImage:[UIImage imageNamed:@"6_Button-down.png"] forState:UIControlStateSelected];
    [shakeButton setImage:[UIImage imageNamed:@"6_Button-down.png"] forState:UIControlStateHighlighted];
    [shakeButton setFrame:CGRectMake(SCREEN_WIDTH/2-pWidth(42.5), SCREEN_HEIGHT-pWidth(97),pWidth(66), pWidth(84))];
    [shakeButton addTarget:self action:@selector(shakeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shakeButton];
    [self.view bringSubviewToFront:backButton];
    [self.view bringSubviewToFront:clearDataButton];
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
              [countArray removeAllObjects];
              if (isKnocked)
              {
                  [shakeButton setImage:[UIImage imageNamed:@"6_Button-down.png"] forState:UIControlStateNormal];
                  [shakeButton setImage:[UIImage imageNamed:@"6_Button-down.png"] forState:UIControlStateSelected];
                  isKnocked = NO;
                  [self closeEgg];
                  [self resetEggNum];
                  [self setRandNumOnBall];
              }
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
    [DEFAULTS setObject:[NSNumber numberWithInt:NINE_BALL_COUNT] forKey:@"AnalysisCellBallCount"];
    [DEFAULTS synchronize];
    sender.selected = YES;
    bingoAnalysisSubView.playType = [NSString stringWithFormat:@"%d",DBTYPE_BINGO];
    bingoAnalysisSubView.dataArray = [countArray mutableCopy];
    [self presentViewController:bingoAnalysisSubView animated:YES completion:^
     {
         sender.selected = NO;
     }];
}
-(void)setAnalysisSubViewAtBingoView
{
    if (bingoAnalysisSubView == nil)
    {
        bingoAnalysisSubView = [[GloBalAnalysisViewController alloc] init];
        bingoAnalysisSubView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        bingoAnalysisSubView.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}
-(void)makeBranchAndEgg
{
    int diffForBranchEgg = 0;
    diffForBranchEgg = pWidth(147);
    float totalHeight = SCREEN_HEIGHT * 0.7;
     
    for (int j = 0; j<3; j++)
    {
        UIImageView *branchDown = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - pWidth(164), SCREEN_HEIGHT/2 - (totalHeight/2) + (j+1)*(totalHeight/3) - pWidth(58), pWidth(328), pWidth(58))];
        branchDown.image = [UIImage imageNamed:@"6_branch.png"];
        [self.view addSubview:branchDown];
        //蛋
        for (int i = 0; i<3; i++)
        {
            UIImageView *eggImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(SCREEN_WIDTH/3) + ((SCREEN_WIDTH/3) - pWidth(86))/2, SCREEN_HEIGHT/2 - (totalHeight/2) + (j)*(totalHeight/3), pWidth(86), pWidth(170))];
            UIButton *eggButton = [UIButton buttonWithType:UIButtonTypeCustom];
            eggButton.backgroundColor = [UIColor clearColor];
            eggButton.frame = eggImageView.frame;
            [eggButton addTarget:self action:@selector(knockKnock:) forControlEvents:UIControlEventTouchUpInside];
            eggButton.tag = 7+i-j*3;
            
            UIImageView *numImageView = [[UIImageView alloc] initWithFrame:CGRectMake(pWidth(2), eggImageView.frame.size.height-125, pWidth(82), pWidth(82))];

            UIImageView *eggDown = [[UIImageView alloc] initWithFrame:CGRectMake(0, eggImageView.frame.size.height-80, pWidth(86), pWidth(80))];
            eggDown.image = [UIImage imageNamed:@"6_break egg-down.png"];
            UIImageView *eggUp = [[UIImageView alloc] initWithFrame:CGRectMake(pWidth(1), 0, pWidth(84), pWidth(76))];
            eggUp.image = [UIImage imageNamed:@"6_break egg-up.png"];
            
            UIImageView *fullEgg = [[UIImageView alloc] initWithFrame:CGRectMake(0, eggImageView.frame.size.height-116, pWidth(86), pWidth(116))];
            fullEgg.image = [UIImage imageNamed:@"6_egg.png"];
            eggDown.tag = 1;
            eggUp.tag = 1;
            fullEgg.tag = 2;
            numImageView.tag = 3;
            eggDown.alpha = 0.0;
            eggUp.alpha = 0.0;
            numImageView.alpha = 0.0;
            [eggImageView addSubview:numImageView];
            [eggImageView addSubview:eggDown];
            [eggImageView addSubview:eggUp];
            [eggImageView addSubview:fullEgg];
            eggImageView.tag = 7+i-j*3;

            [self.view addSubview:eggImageView];
            [self.view addSubview:eggButton];
        }
 
    }
}
-(void)closeEgg
{
    for (UIImageView *currentView in self.view.subviews)
    {
        if ([currentView isKindOfClass:[UIImageView class]])
        {
            for (UIImageView *eggItemsView in currentView.subviews)
            {
                if (eggItemsView.tag==2)
                {
                    eggItemsView.alpha = 1.0;
                }else
                {
                    eggItemsView.alpha = 0.0;
                }
            }
        }
    }
}
-(void)shakeButton:(UIButton *)sender
{
    if (isKnocked)
    {
        [shakeButton setImage:[UIImage imageNamed:@"6_Button-down.png"] forState:UIControlStateNormal];
        [shakeButton setImage:[UIImage imageNamed:@"6_Button-down.png"] forState:UIControlStateSelected];
        [shakeButton setImage:[UIImage imageNamed:@"6_Button-down.png"] forState:UIControlStateHighlighted];
        isKnocked = NO;
        [self closeEgg];
        [self resetEggNum];
        [self setRandNumOnBall];
        [self shakeStick];
    }else
    {
        [self addNumInCountArray];
        [shakeButton setImage:[UIImage imageNamed:@"6_Button-up.png"] forState:UIControlStateSelected];
        [shakeButton setImage:[UIImage imageNamed:@"6_Button-up.png"] forState:UIControlStateNormal];
        isKnocked = YES;
        [self.view.layer removeAllAnimations];

        shakeButton.userInteractionEnabled = NO;
        shakeButton.selected = YES;
        [self fourBigButtonCloseOrOpen:NO];
        __block int bingoEggsCount ;
        bingoEggsCount = 0;

        for (UIView *currentView in self.view.subviews)
        {
            if ([currentView isKindOfClass:[UIImageView class]]&&[currentView.subviews count]>0)
            {
                int randTime =rand()%3;
                [UIView animateWithDuration:randTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
                {
                    for (UIImageView *eggItemsView in currentView.subviews)
                    {
                        if (eggItemsView.tag==2)
                        {
                            eggItemsView.alpha = 0.0;
                        }else
                        {
                            eggItemsView.alpha = 1.0;
                        }
                    }

                } completion:^(BOOL finished)
                {
                        ++bingoEggsCount;
                        if (bingoEggsCount == BINGO_BALL_COUNT)
                        {
                            shakeButton.userInteractionEnabled = YES;
                            shakeButton.selected = NO;
                            [self fourBigButtonCloseOrOpen:YES];
                        }
                    
                }];
            }
            
        }
    }
    
}
-(void)knockKnock:(UIButton *)sender
{
    NSLog(@"sender tag :%i",(int)sender.tag);
    isKnocked = YES;
    for (UIImageView *currentView in self.view.subviews)
    {
        if ([currentView isKindOfClass:[UIImageView class]]&&[currentView.subviews count]>0&&currentView.tag==sender.tag)
        {
            currentView.transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(5));
            [UIView animateWithDuration:0.1
                                  delay:0
                                options:
             UIViewAnimationOptionBeginFromCurrentState|
             UIViewAnimationOptionAutoreverse |
             UIViewAnimationOptionCurveLinear
                             animations:^{
                            [UIView setAnimationRepeatCount:2];
                            currentView.transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-5));

                             } completion:^(BOOL finished)
            {
                if (finished)
                {
                    NSLog(@"finished");
                    currentView.transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));

                    for (UIView *currentImageItem in currentView.subviews)
                    {
                        if ([currentImageItem isKindOfClass:[UIImageView class]])
                        {
                            if (currentImageItem.tag == 2)
                            {
                                currentImageItem.alpha = 0.0;
                            }else
                            {
                                currentImageItem.alpha = 1.0;
                            }
                        }
                    }
                }
                             }
             ];
        }
    }
}
-(void)addNumInCountArray
{
    NSArray *firstNineArray = [bingoArray mutableCopy];
    [countArray addObject:firstNineArray];
}
-(void)resetEggNum
{
    [bingoArray removeAllObjects];
    for (int j =0; j<BINGO_BALL_COUNT; j++)
    {
            int randSeed = (arc4random() % 4);
            [bingoArray addObject:[NSNumber numberWithInt:BINGO_BALL_RAND*j+randSeed+1]];
    }

//    NSLog(@"bingoArray :%@",bingoArray);
}
-(void)setRandNumOnBall
{
    for (int j =0; j<BINGO_BALL_COUNT; j++)
    {
        for (UIView *currentView in self.view.subviews)
        {
            if ([currentView isKindOfClass:[UIImageView class]]&&[currentView.subviews count]>0&&currentView.tag==(j+1))
            {
                for (UIImageView *currentImageItem in currentView.subviews)
                {
                    if ([currentImageItem isKindOfClass:[UIImageView class]])
                    {
                        if (currentImageItem.tag==3)
                        {
                            currentImageItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"00_ball %i.png",[[bingoArray objectAtIndex:j] intValue]]];

                        }
                    }
                }
            }
        }
    }
}
-(void)shakeStick
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:
     UIViewAnimationOptionBeginFromCurrentState|
     UIViewAnimationOptionAutoreverse |
     UIViewAnimationOptionCurveLinear |
     UIViewAnimationOptionAllowUserInteraction
     animations:^
    {
        [UIView setAnimationRepeatCount:5];
         shakeButton.transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-5));
     } completion:^(BOOL finished)
    {
        if (finished)
        {
        shakeButton.transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
        }
     }];
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
@end
