//
//  GloBalAnalysisViewController.m
//  Lotto
//
//  Created by brownie on 2014/2/5.
//  Copyright (c) 2014年 brownieBBK. All rights reserved.
//

#import "GloBalAnalysisViewController.h"
#import "Constant.h"
@interface GloBalAnalysisViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CustomClearDataButton *recordDataButton;
    
    //排名總體
    UIButton *sortButton;
    UIButton *allDataButton;
    UITableView *sortDataTableView;
    
    //data
    NSMutableArray *sortCellDataAray;
    UILabel *topCountLabel;
    int wouldChangeYellowCellAtTop;
    int wouldShowCellCountWhenSort;
    int startBallNum;
    int dbTypeNum;
    //206
    NSString *cellIDString;
//    float barHeight ;
}
@end

@implementation GloBalAnalysisViewController
@synthesize dataArray;
@synthesize playType;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor orangeColor];
        sortCellDataAray = [[NSMutableArray alloc] init];
//        barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        dataArray = [[NSArray alloc] init];
        cellIDString = @"";
        [self setUI];
        sortButton.selected = YES;
        wouldChangeYellowCellAtTop = 0;
        wouldShowCellCountWhenSort = 0;
        dbTypeNum = 0;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self makeBallSet];
    [self makeSortCellImageView];
    [self setBackButtonImage];
    sortButton.selected = YES;
    allDataButton.selected = NO;
    [sortDataTableView reloadData];
    topCountLabel.text = [NSString stringWithFormat:@"%i",(int)[dataArray count]];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
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
    //排名按鈕
    sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sortButton setFrame:CGRectMake(SCREEN_WIDTH/2-pWidth(90), statusBarHeight+pHeight(10), pWidth(94), pWidth(42))];
    [sortButton setImage:[UIImage imageNamed:@"00_button-rank up.png"] forState:UIControlStateSelected ];
    [sortButton setImage:[UIImage imageNamed:@"00_button-rank down.png"] forState:UIControlStateNormal];
    [sortButton setImage:[UIImage imageNamed:@"00_button-rank down.png"] forState:UIControlStateHighlighted];
    [sortButton addTarget:self action:@selector(changeTableViewData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sortButton];
    //總體按鈕
    allDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [allDataButton setFrame:CGRectMake(SCREEN_WIDTH/2-pWidth(5), statusBarHeight+pHeight(10), pWidth(94), pWidth(42))];
    [allDataButton setImage:[UIImage imageNamed:@"00_button-total up.png"] forState:UIControlStateSelected];
    [allDataButton setImage:[UIImage imageNamed:@"00_button-total down.png"] forState:UIControlStateNormal];
    [allDataButton setImage:[UIImage imageNamed:@"00_button-total down.png"] forState:UIControlStateHighlighted];
    [allDataButton addTarget:self action:@selector(changeTableViewData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allDataButton];
    
    //目前搖了幾次的ImageView
    UIImageView *currentCountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-pWidth(113), CGRectGetMaxY(allDataButton.frame), pWidth(226), pWidth(52))];
    currentCountImageView.image = [UIImage imageNamed:@"00_DataAnalysis-Number of times.png"];
    [self.view addSubview:currentCountImageView];
    
    //號碼Label
    topCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentCountImageView.frame.size.width/2+pWidth(18), currentCountImageView.frame.size.height/2-pHeight(14), pWidth(40), pWidth(30))];
    topCountLabel.textAlignment = NSTextAlignmentCenter;
    topCountLabel.backgroundColor = [UIColor clearColor];
    topCountLabel.textColor = [UIColor redColor];
    topCountLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:20.0];
    [currentCountImageView addSubview:topCountLabel];
    [self setSortTableView];
    [self.view addSubview:frameImageView];
    [self.view addSubview:backButton];
    //記錄資料按鈕
    recordDataButton = [CustomClearDataButton buttonWithType:UIButtonTypeCustom];
    [recordDataButton setImage:[UIImage imageNamed:@"00_button-save up.png"] forState:UIControlStateNormal];
    [recordDataButton setImage:[UIImage imageNamed:@"00_button-save down.png"] forState:UIControlStateSelected];
    [recordDataButton setImage:[UIImage imageNamed:@"00_button-save down.png"] forState:UIControlStateHighlighted];
    [recordDataButton setFrame:CGRectMake(SCREEN_WIDTH-pHeight(5)-pWidth(90), statusBarHeight+pHeight(5),pWidth(90), pWidth(90))];
    [recordDataButton addTarget:self action:@selector(recordDataButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordDataButton];
    
}

-(void)recordDataButton:(UIButton *)sender
{
    sender.selected = YES;
    [SINGLETON saveDataWithCompletionBlock:^(BOOL success)
     {
         if (success)
         {
             sender.selected = NO;
         }
     } WithServerData:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%i",dbTypeNum],sortCellDataAray,dataArray,[self imageWithView:self.view], nil]];
}
-(void)setSortTableView
{
    if (sortDataTableView == nil)
    {
        sortDataTableView = [[UITableView alloc] initWithFrame:CGRectMake(4, CGRectGetMaxY(allDataButton.frame)+allDataButton.frame.size.height+20, SCREEN_WIDTH-8, SCREEN_HEIGHT-CGRectGetMaxY(allDataButton.frame)-allDataButton.frame.size.height-4) style:UITableViewStyleGrouped];
        sortDataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        sortDataTableView.backgroundColor = [UIColor clearColor];
        sortDataTableView.delegate = self;
        sortDataTableView.dataSource = self;
        [self.view addSubview:sortDataTableView];
    }
}
#pragma mark -
#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (sortButton.selected)
    {
        return wouldShowCellCountWhenSort;
    }else
    {
        return [dataArray count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDString];
    if (cell == nil) {
        cell = [[AllDataCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIDString ];
    }
    if (sortButton.selected &&[indexPath row]<wouldShowCellCountWhenSort)
    {
        CGRect rightRedFrame = cell.rightRedImage.frame;
        if ([indexPath row]<wouldChangeYellowCellAtTop)
        {
            cell.backGroundImageView.image = [UIImage imageNamed: @"00_DataAnalysis-Yellow 1.png"];
            cell.underRedImage.image = [UIImage imageNamed:@"00_DataAnalysis-Yellow 3.png"] ;
            if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
            {
                cell.rightRedImage.image =[[UIImage imageNamed:@"00_DataAnalysis-Yellow 2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 16) resizingMode:UIImageResizingModeStretch];
            }else
            {
                cell.rightRedImage.image =[UIImage imageNamed:@"00_DataAnalysis-Yellow 2.png"];
            }
            
            rightRedFrame.size.width = 32+(40-[indexPath row]*5);
            [cell.rightRedImage setFrame:rightRedFrame];
            
        }else
        {
            cell.backGroundImageView.image = [UIImage imageNamed: @"00_DataAnalysis-Red 1.png"];
            cell.underRedImage.image = [UIImage imageNamed:@"00_DataAnalysis-Red 3.png"];
            rightRedFrame.size.width = 32;
            cell.rightRedImage.image = [UIImage imageNamed:@"00_DataAnalysis-Red 2.png"];
            [cell.rightRedImage setFrame:rightRedFrame];
        }
        
        cell.lineImageView.hidden = YES;
        cell.numLabel.hidden = YES;
        for (UIImageView *matchImage in cell.backGroundImageView.subviews)
        {
            if ([matchImage isKindOfClass:[UIImageView class]]&&matchImage.tag>0)
            {
                //東西都會被hidden
                matchImage.hidden = YES;
            }
        }
        cell.sortNoLabel.hidden = NO;
        cell.sortNoLabel.text = [NSString stringWithFormat:@"%i",(int)[indexPath row]+1];
        //設定球
        cell.singleBallView.image = [UIImage imageNamed:[NSString stringWithFormat:@"00_ball %@.png",[[[sortCellDataAray objectAtIndex:[indexPath row]] componentsSeparatedByString:@","] objectAtIndex:0]]];
        cell.singleBallView.hidden = NO;
        cell.underRedImage.hidden= NO;
        cell.rightRedImage.hidden = NO;
        cell.pecordLabel.hidden = NO;
        cell.pecordLabel.text = [NSString stringWithFormat:@"%@/%i",[[[sortCellDataAray objectAtIndex:[indexPath row]] componentsSeparatedByString:@","] objectAtIndex:1],(int)[dataArray count]];
        
    }else
    {
        cell.backGroundImageView.image = nil;
        cell.lineImageView.hidden = NO;
        cell.numLabel.hidden = NO;
        cell.sortNoLabel.hidden = YES;
        cell.numLabel.text = [NSString stringWithFormat:@"%i",(int)[indexPath row]+1];
        for (UIImageView *matchImage in cell.backGroundImageView.subviews)
        {
            if ([matchImage isKindOfClass:[UIImageView class]]&&matchImage.tag&&matchImage.tag<=wouldChangeYellowCellAtTop)
            {
                NSLog(@"tag :%i",(int)matchImage.tag);
                matchImage.hidden = NO;
                matchImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"00_ball %@.png",[[[dataArray objectAtIndex:[indexPath row]] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:matchImage.tag-1]]];
            }
        }
        cell.singleBallView.hidden = YES;
        cell.underRedImage.hidden= YES;
        cell.rightRedImage.hidden = YES;
        cell.pecordLabel.hidden = YES;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}
-(void)makeSortCellImageView
{
    [sortCellDataAray removeAllObjects];
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
    for (int i = 0; i<wouldShowCellCountWhenSort; i++)
    {
        [dataDictionary setObject:@"" forKey:[NSString stringWithFormat:@"%i",i+1]];
        [sortCellDataAray addObject:[NSNumber numberWithInt:0]];
    }
    
    NSMutableSet *allNumberSet = [[NSMutableSet alloc] init];
    NSMutableSet *intersectSet = [[NSMutableSet alloc] init];

    for (int i = 0; i<[dataArray count]; i++)
    {
        [intersectSet setSet:allNumberSet];
        [allNumberSet addObjectsFromArray:[dataArray objectAtIndex:i]];
        
        [intersectSet intersectSet:[NSSet setWithArray:[dataArray objectAtIndex:i]]];
        //        NSLog(@"相同的有 :%@",[intersectSet allObjects]);
        for (NSNumber *currentNum in [intersectSet allObjects])
        {
            int numOne = (([currentNum intValue]-startBallNum) > 0 ? [currentNum intValue]-startBallNum:0);
            [sortCellDataAray replaceObjectAtIndex:numOne withObject:[NSNumber numberWithInt:[[sortCellDataAray objectAtIndex:numOne] intValue]+1]];
        }
    }
    //    NSLog(@"all Set = :%@",[allNumberSet allObjects]);
    for (NSNumber *currentNum in [allNumberSet allObjects])
    {
        int numOne = (([currentNum intValue]-startBallNum) > 0 ? [currentNum intValue]-startBallNum:0);
        [sortCellDataAray replaceObjectAtIndex:numOne withObject:[NSNumber numberWithInt:[[sortCellDataAray objectAtIndex:numOne] intValue]+1]];
    }
    for (NSNumber *matchInt in sortCellDataAray)
    {
        [dataDictionary setObject:matchInt forKey:[NSString stringWithFormat:@"%i",(int)[sortCellDataAray indexOfObject:matchInt]]];
    }
    NSArray *tempArray = [sortCellDataAray sortedArrayUsingSelector:@selector(compare:)];
    NSMutableDictionary *orderedDictionary = [[NSMutableDictionary alloc]init];
    int noNum = 1;
    for (int i = (int)[tempArray count]; i>0; i--)
    {
        [orderedDictionary setObject:[NSString stringWithFormat:@"%i,%@",(int)[sortCellDataAray indexOfObject:[tempArray objectAtIndex:i-1]]+startBallNum,[tempArray objectAtIndex:i-1]] forKey:[NSString stringWithFormat:@"%i",noNum]];
        [sortCellDataAray replaceObjectAtIndex:[sortCellDataAray indexOfObject:[tempArray objectAtIndex:i-1]] withObject:@""];
        noNum++;
    }
    //    NSLog(@"orderedDictionary :%@",orderedDictionary);
    [sortCellDataAray removeAllObjects];
    for (int i = 0;i<[tempArray count];i++)
    {
        for (NSString *key in orderedDictionary)
        {
            if ([key isEqualToString:[NSString stringWithFormat:@"%i",i+1]])
            {
                [sortCellDataAray addObject:[orderedDictionary objectForKey:key]];
            }
        }
    }
    //    NSLog(@"sortCellDataAray :%@",[sortCellDataAray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 6)]]);
    [sortDataTableView reloadData];
}
-(void)changeTableViewData:(UIButton *)sender
{
    if (!sender.selected)
    {
        sortButton.selected = !sortButton.selected;
        allDataButton.selected = !allDataButton.selected;
        [sortDataTableView reloadData];
    }
}
#pragma mark -
#pragma mark 將目前畫面 拍下來
- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
-(void)makeBallSet
{
    switch ([playType intValue])
    {
        case DBTYPE_STAR_3:
            cellIDString = @"DBTYPE_STAR_3";
            dbTypeNum = DBTYPE_STAR_3;
            wouldChangeYellowCellAtTop = THREE_BALL_COUNT;
            wouldShowCellCountWhenSort = 10;
            startBallNum = 0;
            break;
        case DBTYPE_STAR_4:
            cellIDString = @"DBTYPE_STAR_4";
            dbTypeNum = DBTYPE_STAR_4;
            wouldChangeYellowCellAtTop = FOUR_BALL_COUNT;
            wouldShowCellCountWhenSort = 10;
            startBallNum = 0;
            break;
        case DBTYPE_BIG_LOTTO:
            cellIDString = @"DBTYPE_BIG_LOTTO";
            dbTypeNum = DBTYPE_BIG_LOTTO;
            wouldChangeYellowCellAtTop = SIX_BALL_COUNT;
            wouldShowCellCountWhenSort = 49;
            startBallNum = 1;
            break;
        case DBTYPE_WEI_LI:
            cellIDString = @"DBTYPE_WEI_LI";
            dbTypeNum = DBTYPE_WEI_LI;
            wouldChangeYellowCellAtTop = WEI_LI_BALL_COUNT;
            wouldShowCellCountWhenSort = 38;
            startBallNum = 1;
            break;
        case DBTYPE_FIVE_THREE_NINE:
            cellIDString = @"DBTYPE_FIVE_THREE_NINE";
            dbTypeNum = DBTYPE_FIVE_THREE_NINE;
            wouldChangeYellowCellAtTop = FIVE_BALL_COUNT;
            wouldShowCellCountWhenSort = 39;
            startBallNum = 1;
            break;
        case DBTYPE_BINGO:
            cellIDString = @"DBTYPE_BINGO";
            dbTypeNum = DBTYPE_BINGO;
            wouldChangeYellowCellAtTop = NINE_BALL_COUNT;
            wouldShowCellCountWhenSort = 36;
            startBallNum = 1;
            break;
        case DBTYPE_THREE_NINE:
            cellIDString = @"DBTYPE_THREE_NINE";
            dbTypeNum = DBTYPE_THREE_NINE;
            wouldChangeYellowCellAtTop = FOUR_BALL_COUNT;
            wouldShowCellCountWhenSort = 39;
            startBallNum = 1;
            break;
        case DBTYPE_THREE_EIGHT:
            cellIDString = @"DBTYPE_THREE_EIGHT";
            dbTypeNum = DBTYPE_THREE_EIGHT;
            wouldChangeYellowCellAtTop = FIVE_BALL_COUNT;
            wouldShowCellCountWhenSort = 38;
            startBallNum = 1;
            break;
        case DBTYPE_FOUR_NINE:
            cellIDString = @"DBTYPE_FOUR_NINE";
            dbTypeNum = DBTYPE_FOUR_NINE;
            wouldChangeYellowCellAtTop = FOUR_BALL_COUNT;
            wouldShowCellCountWhenSort = 49;
            startBallNum = 1;
            break;
        default:
            break;
    }
}
-(void)setBackButtonImage
{
    [backButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_DateBack-up.png",playType]] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_DateBack-down.png",playType]] forState:UIControlStateSelected];
    [backButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_DateBack-down.png",playType]] forState:UIControlStateHighlighted];
}
- (void)didChangeStatusBarFrame:(NSNotification*)notification
{
    NSValue*statusBarFrameValue = [notification.userInfo valueForKey:UIApplicationStatusBarFrameUserInfoKey];
    CGRect statusBarFrame =[statusBarFrameValue CGRectValue];
    CGRect mainViewRect = mainBackImageView.frame;
    CGRect frameViewRect = frameImageView.frame;
    CGRect sortDataTableViewFrame = sortDataTableView.frame;
    mainViewRect.size.height = SCREEN_HEIGHT-statusBarHeight;
    frameViewRect.size.height = SCREEN_HEIGHT-statusBarHeight;
    sortDataTableViewFrame.size.height = SCREEN_HEIGHT-CGRectGetMaxY(allDataButton.frame)-allDataButton.frame.size.height-statusBarHeight-4;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
     {
        [mainBackImageView setFrame:mainViewRect];
        [frameImageView setFrame:frameViewRect];
        [sortDataTableView setFrame:sortDataTableViewFrame];
    } completion:nil];
}
@end
