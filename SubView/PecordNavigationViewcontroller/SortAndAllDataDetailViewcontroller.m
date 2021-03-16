//
//  SortAndAllDataDetailViewcontroller.m
//  Lotto
//
//  Created by brownie on 2014/2/2.
//  Copyright (c) 2014年 brownieBBK. All rights reserved.
//

#import "SortAndAllDataDetailViewcontroller.h"
#import "Constant.h"
@interface SortAndAllDataDetailViewcontroller ()
{
    UIButton *deleteDataButton;
    // Cell
    UITableView *detailListTableView;
    NSMutableArray *detailDataArray;
    UILabel *dateLabel;
    UILabel *topCountLabel;
    UILabel *topSearchDateLabel;
    //2/4
    UIImageView *searchDateImageView;
    UIButton *searchDayButton;
    BOOL restoreNow;
    int allSpinCount ;
    NSMutableArray *finalArray;
    //scrollView
    UIScrollView *upYearScrollView;
    UIScrollView *upMonthScrollView;
    UIScrollView *upDayScrollView;
    UILabel *upYearLabel;
    UIScrollView *downYearScrollView;
    UIScrollView *downMonthScrollView;
    UIScrollView *downDayScrollView;
    UILabel *downYearLabel;
//    UILabel *monthLabel;
//    UILabel *dayLabel;
    //2/5
    NSMutableArray *detectDateArrayByAllData;
    NSMutableArray *forCalculateDataArray;
    int wouldChangeYellowCellAtTop;
    int wouldShowCellCountWhenSort;
    int startBallNum;
    //205
    BOOL cellShouldLayOutAgain;
    //206
    NSString *cellIDString;
    float barHeight ;
}
@end

@implementation SortAndAllDataDetailViewcontroller
@synthesize playType;
@synthesize detailType;
@synthesize allDataArrayFromSuperView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor orangeColor];
        detailDataArray = [[NSMutableArray alloc] init];
        detectDateArrayByAllData = [[NSMutableArray alloc] init];
        forCalculateDataArray = [[NSMutableArray alloc] init];
        finalArray = [[NSMutableArray alloc] init];
        barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        cellIDString = @"";
        [self setUI];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    cellShouldLayOutAgain = NO;
    [self makeBallSet];
    [self detectCellBallCount];
    forCalculateDataArray = [allDataArrayFromSuperView mutableCopy];
    allSpinCount = 0;
    restoreNow = NO;
    [finalArray removeAllObjects];
    [self setForDetailTypeThree];
    [self setBackButtonImage];
    [detailListTableView reloadData];
    if ([detailType isEqualToString:@"3"])
    {
    [self setSearchDateImageViewForNew];    
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if ([detailType isEqualToString:@"3"])
    {
        restoreNow = YES;
        [self searchButtonAction];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
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
    NSValue*statusBarFrameValue = [notification.userInfo valueForKey:UIApplicationStatusBarFrameUserInfoKey];
    barHeight = [statusBarFrameValue CGRectValue].size.height;
//背景
        CGRect mainViewRect = mainBackImageView.frame;
//外筐
        CGRect frameViewRect = frameImageView.frame;
// tableview
        CGRect tableviewFrame = detailListTableView.frame;
    
        mainViewRect.size.height = SCREEN_HEIGHT-statusBarHeight;
        frameViewRect.size.height = SCREEN_HEIGHT-statusBarHeight;
        tableviewFrame.size.height = SCREEN_HEIGHT-statusBarHeight-95;
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
         {
             [mainBackImageView setFrame:mainViewRect];
             
             [frameImageView setFrame:frameViewRect];
             [detailListTableView setFrame:tableviewFrame];
         } completion:nil];
}
-(void)setUI
{
    [super setUI];
    [self.view addSubview:mainBackImageView];
    
    [self setDetailListTableView];
    [self.view addSubview:frameImageView];
    //設定搜尋日期ImageView
    searchDateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - pWidth(267)/2, statusBarHeight + pWidth(17), pWidth(267), pWidth(68))];
    searchDateImageView.userInteractionEnabled = YES;
    searchDateImageView.image = [UIImage imageNamed:@"00_PecordNavigation-data search.png"];
    //隱形按鈕
    searchDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchDayButton setFrame:CGRectMake(0, 0, searchDateImageView.frame.size.width, searchDateImageView.frame.size.height)];
    [searchDayButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    searchDayButton.backgroundColor = [UIColor clearColor];
    [searchDateImageView addSubview:searchDayButton];

    topSearchDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(pWidth(35), pWidth(33), pWidth(215), pWidth(30))];
    topSearchDateLabel.textAlignment = NSTextAlignmentLeft;
    topSearchDateLabel.textColor = [UIColor blackColor];
    topSearchDateLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:20.0];
    topSearchDateLabel.backgroundColor = [UIColor clearColor];
    [searchDateImageView addSubview:topSearchDateLabel];
    [self.view addSubview:searchDateImageView];
    [self.view addSubview:backButton];
    //刪除資料按鈕
    deleteDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteDataButton setImage:[UIImage imageNamed:@"00_PecordNavigation-delete up.png"] forState:UIControlStateNormal];
    [deleteDataButton setImage:[UIImage imageNamed:@"00_PecordNavigation-delete down.png"] forState:UIControlStateSelected];
    [deleteDataButton setImage:[UIImage imageNamed:@"00_PecordNavigation-delete down.png"] forState:UIControlStateHighlighted];
    [deleteDataButton setFrame:CGRectMake(SCREEN_WIDTH-5-pWidth(90), statusBarHeight+pHeight(5),pWidth(95), pWidth(120))];
    [deleteDataButton addTarget:self action:@selector(deleteDataButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteDataButton];
}

-(void)deleteDataButton:(UIButton *)sender
{
    NSLog(@"timeStamp:%@",[allDataArrayFromSuperView objectAtIndex:0]);
    sender.selected = YES;
    [self deleteDataWithCompletionBlock:^(BOOL success)
    {
        if (success)
        {
            [self dismissViewControllerAnimated:YES completion:^
             {
                 sender.selected = NO;
             }];
        }
    }];
}
-(void)deleteDataWithCompletionBlock:(void (^)(BOOL success))completionBlock
{
    SortTable *matchSortTable = [[SortTable MR_findByAttribute:@"timeStamp" withValue:[allDataArrayFromSuperView objectAtIndex:0]] lastObject];
    [DEFAULTS setObject:@"YES" forKey:@"NeedReloadCoreData"];
    [DEFAULTS setObject:[NSString stringWithFormat:@"%@",[allDataArrayFromSuperView objectAtIndex:0]] forKey:@"ShouldDeleteTime"];
    [DEFAULTS synchronize];
    if (matchSortTable!=nil)
    {
        [matchSortTable MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error)
         {
             if (success)
             {
                 completionBlock(YES);
             }
         }];
    }

}
-(void)setDetailListTableView
{
    if (detailListTableView == nil)
    {
        detailListTableView = [[UITableView alloc] initWithFrame:CGRectMake(3, 20+95-6, SCREEN_WIDTH-6, SCREEN_HEIGHT-(20+95)) style:UITableViewStyleGrouped];
        detailListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        detailListTableView.backgroundColor = [UIColor clearColor];
        detailListTableView.delegate = self;
        detailListTableView.dataSource = self;
        [self.view addSubview:detailListTableView];
    }
}
-(void)setBackButtonImage
{
    [backButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_DateBack-up.png",playType]] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_DateBack-down.png",playType]] forState:UIControlStateSelected];
    [backButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_DateBack-down.png",playType]] forState:UIControlStateHighlighted];
}
#pragma mark -
#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([detailType isEqualToString:@"2"])
    {
        return [[forCalculateDataArray objectAtIndex:2] count];
    }else
    {
        return wouldShowCellCountWhenSort;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDString];
    if (cell == nil) {
        cell = [[AllDataCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIDString];
    }
    if (cellShouldLayOutAgain)
    {
        cellShouldLayOutAgain = NO;
        [cell layoutIfNeeded];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (([detailType isEqualToString:@"1"]||[detailType isEqualToString:@"3"]) &&[indexPath row]<wouldShowCellCountWhenSort)
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
        cell.singleBallView.hidden = NO;
        cell.underRedImage.hidden= NO;
        cell.rightRedImage.hidden = NO;
        cell.pecordLabel.hidden = NO;
        
        cell.sortNoLabel.text = [NSString stringWithFormat:@"%i",(int)[indexPath row]+1];
        //設定球
        if ([detailType isEqualToString:@"1"])
        {
            cell.singleBallView.image = [UIImage imageNamed:[NSString stringWithFormat:@"00_ball %@.png",[[[[forCalculateDataArray objectAtIndex:2]  objectAtIndex:[indexPath row]] componentsSeparatedByString:@","] objectAtIndex:0]]];
            
            cell.pecordLabel.text = [NSString stringWithFormat:@"%@/%@",[[[[forCalculateDataArray objectAtIndex:2]  objectAtIndex:[indexPath row]] componentsSeparatedByString:@","] objectAtIndex:1],[forCalculateDataArray objectAtIndex:1]];
        }else
        {
            cell.singleBallView.image = [UIImage imageNamed:[NSString stringWithFormat:@"00_ball %@.png",[[[finalArray objectAtIndex:[indexPath row]] componentsSeparatedByString:@","] objectAtIndex:0]]];
            cell.pecordLabel.text = [NSString stringWithFormat:@"%@/%i",[[[finalArray  objectAtIndex:[indexPath row]] componentsSeparatedByString:@","] objectAtIndex:1],allSpinCount];
        }

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
                matchImage.hidden = NO;
                matchImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"00_ball %@.png",[[[[forCalculateDataArray objectAtIndex:2] objectAtIndex:[indexPath row]] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:matchImage.tag-1]]];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (![detailType isEqualToString:@"3"])
    {
        return 82;
    }else
    {
        return 1;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (![detailType isEqualToString:@"3"])
    {
        UIView *currentHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 80)];
        currentHeaderView.backgroundColor = [UIColor clearColor];
        dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -6, tableView.frame.size.width, 35)];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor = [UIColor whiteColor];
        dateLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:27.0];
        dateLabel.backgroundColor = [UIColor clearColor];
        
        //目前搖了幾次的ImageView
        UIImageView *currentCountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width/2-113, 28, 226, 52)];
        currentCountImageView.image = [UIImage imageNamed:@"00_DataAnalysis-Number of times.png"];
        
        //號碼Label
        topCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentCountImageView.frame.size.width/2+18, currentCountImageView.frame.size.height/2-14, 40, 30)];
        topCountLabel.textAlignment = NSTextAlignmentCenter;
        topCountLabel.textColor = [UIColor redColor];
        topCountLabel.backgroundColor = [UIColor clearColor];
        topCountLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:20.0];
        
        [currentCountImageView addSubview:topCountLabel];
        [currentHeaderView addSubview:currentCountImageView];
        [currentHeaderView addSubview:dateLabel];
        [self setDateLabelAndTopCountText];
        return currentHeaderView;
    }else
    {
        return nil;
    }
   
}
-(void)setDateLabelAndTopCountText
{
    topCountLabel.text = [NSString stringWithFormat:@"%@",[forCalculateDataArray objectAtIndex:1]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd  HH:mm:ss"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSString *currentDateString = [dateFormatter stringFromDate:[forCalculateDataArray objectAtIndex:0]];
    dateLabel.text = currentDateString;
    
    topSearchDateLabel.text = [NSString stringWithFormat:(isIPhoneWithNotch == YES) ? @"%@           %@          %@":@"%@          %@        %@",[currentDateString substringToIndex:4],[currentDateString substringWithRange:NSMakeRange(5, 2)],[currentDateString substringWithRange:NSMakeRange(8, 2)]];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"在這裡複寫,因為上一個畫面有複寫,這裡不寫個空白的,會出事情");
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:self.view];
        
        // Do something with this location
        // If you want to check if it was on a specific area of the screen for example
        CGRect canTouchRect = CGRectMake(0, 184, SCREEN_WIDTH, SCREEN_HEIGHT-184);
        NSLog(@"location :%@",NSStringFromCGPoint(location));
        if (CGRectContainsPoint(canTouchRect, location))
        {
            if (searchDateImageView.alpha!=0)
            {
                [self searchButtonAction];
                [self calculateDateInAllDataView];
                [self detactDayWithTableViewListInAllDataView];
            }
            break;
        }
    }
}
-(void)detactDayWithTableViewListInAllDataView
{
//    BOOL haveToReplace = YES;
//    NSUInteger indexOfLastRow = 0;
    //改變要用到的顯示資料
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSDate *dateU = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@-%@-%@ 00:00:00",[detectDateArrayByAllData objectAtIndex:0],[detectDateArrayByAllData objectAtIndex:1],[detectDateArrayByAllData objectAtIndex:2]]];
    NSDate *dateD = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@-%@-%@ 00:00:00",[detectDateArrayByAllData objectAtIndex:3],[detectDateArrayByAllData objectAtIndex:4],[detectDateArrayByAllData objectAtIndex:5]]];
    static NSDate *currentDate;
    [forCalculateDataArray removeAllObjects];
    for (NSArray *listItem in allDataArrayFromSuperView)
    {
        NSString *dateString = [NSString stringWithFormat:@"%@",[listItem objectAtIndex:0]];
        NSString *yearString = [dateString substringToIndex:4];
        NSString *monthString = [dateString substringWithRange:NSMakeRange(5, 2)];
        NSString *dayString = [dateString substringWithRange:NSMakeRange(8, 2)];

        currentDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@-%@-%@ 00:00:00",yearString,monthString,dayString]];
        if (([currentDate compare:dateU]==NSOrderedDescending||[currentDate compare:dateU]==NSOrderedSame) && ([currentDate compare:dateD]==NSOrderedAscending||[currentDate compare:dateD]==NSOrderedSame))
        {
            NSLog(@"有");
            [forCalculateDataArray addObject:listItem];
        }
    }
    [self calculateAllSpinCount];
    [detailListTableView reloadData];
}
-(void)calculateDateInAllDataView
{
    [detectDateArrayByAllData removeAllObjects];
    NSArray *allYearArray = [self makeYearCount];
    
    CGFloat upYearHeight = upYearScrollView.frame.size.height;
    int currentUpYear = ((upYearScrollView.contentOffset.y - upYearHeight / 2) / upYearHeight) + 1;
    
    CGFloat upMonthHeight = upMonthScrollView.frame.size.height;
    int currentUpMonth = ((upMonthScrollView.contentOffset.y - upMonthHeight / 2) / upMonthHeight) + 1;
    
    CGFloat upDayHeight = upDayScrollView.frame.size.height;
    int currentUpDay = ((upDayScrollView.contentOffset.y - upDayHeight / 2) / upDayHeight) + 1;
    
    CGFloat downYearHeight = downYearScrollView.frame.size.height;
    int currentDownYear = ((downYearScrollView.contentOffset.y - downYearHeight / 2) / downYearHeight) + 1;
    
    CGFloat downMonthHeight = downMonthScrollView.frame.size.height;
    int currentDownMonth = ((downMonthScrollView.contentOffset.y - downMonthHeight / 2) / downMonthHeight) + 1;
    
    CGFloat downDayHeight = downDayScrollView.frame.size.height;
    int currentDownDay = ((downDayScrollView.contentOffset.y - downDayHeight / 2) / downDayHeight) + 1;
    if ([allYearArray count]<1)
    {
        NSLog(@"上面現在是 :%@ 年",[allYearArray lastObject]);
        NSLog(@"下面現在是 :%@ 年",[allYearArray lastObject]);
    }else
    {
        NSLog(@"上面現在是 :%@ 年",[allYearArray objectAtIndex:currentUpYear]);
        NSLog(@"下面現在是 :%@ 年",[allYearArray objectAtIndex:currentDownYear]);
    }
    NSLog(@"上面現在是 :%i 月 %i 日",currentUpMonth+1,currentUpDay+1);

    NSLog(@"下面現在是 :%i 月 %i 日",currentDownMonth+1,currentDownDay+1);

    
    NSString *yearU = @"";
    NSString *monthU = @"";
    NSString *dayU = @"";
    NSString *yearD = @"";
    NSString *monthD = @"";
    NSString *dayD = @"";
    if ([allYearArray count]<1)
    {
        yearU =[allYearArray lastObject];
        yearD =[allYearArray lastObject];
    }else
    {
        yearU =[[self makeYearCount] objectAtIndex:currentUpYear];
        yearD =[[self makeYearCount] objectAtIndex:currentDownYear];
    }
    if ((currentUpMonth+1)<10)
    {
        monthU = [NSString stringWithFormat:@"0%i",currentUpMonth+1];
        monthD = [NSString stringWithFormat:@"0%i",currentDownMonth+1];
    }else
    {
        monthU = [NSString stringWithFormat:@"%i",currentUpMonth+1];
        monthD = [NSString stringWithFormat:@"%i",currentDownMonth+1];
    }
    if ((currentUpDay+1)<10)
    {
        dayU = [NSString stringWithFormat:@"0%i",currentUpDay+1];
        dayD = [NSString stringWithFormat:@"0%i",currentDownDay+1];
    }else
    {
        dayU = [NSString stringWithFormat:@"%i",currentUpDay+1];
        dayD = [NSString stringWithFormat:@"%i",currentDownDay+1];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSDate *dateU = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@-%@-%@ 00:00:00",yearU,monthU,dayU]];
    NSDate *dateD = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@-%@-%@ 00:00:00",yearD,monthD,dayD]];
    [detectDateArrayByAllData addObject:yearU];
    [detectDateArrayByAllData addObject:monthU];
    [detectDateArrayByAllData addObject:dayU];
    if ([dateU compare:dateD] == NSOrderedDescending)
    {//異常,輸入上面日期
        NSLog(@"上面日期較大");
        [detectDateArrayByAllData addObject:yearU];
        [detectDateArrayByAllData addObject:monthU];
        [detectDateArrayByAllData addObject:dayU];
    //將下面日期設定成跟上面一樣
        [downYearScrollView setContentOffset:CGPointMake(downYearScrollView.contentOffset.x,downYearScrollView.frame.size.height*[allYearArray indexOfObject:yearU])];
        [downMonthScrollView setContentOffset:CGPointMake(downMonthScrollView.contentOffset.x, downMonthScrollView.frame.size.height*(currentUpMonth))];
        [downDayScrollView setContentOffset:CGPointMake(downDayScrollView.contentOffset.x, downDayScrollView.frame.size.height*(currentUpDay))];
        
    }else
    {//正常
        [detectDateArrayByAllData addObject:yearD];
        [detectDateArrayByAllData addObject:monthD];
        [detectDateArrayByAllData addObject:dayD];
    }
    NSLog(@"detectDateArrayByAllData :%@",detectDateArrayByAllData);
}

-(void)setForDetailTypeThree
{
    if ([detailType isEqualToString:@"3"])
    {
        //搜尋日期按鈕出現
        searchDayButton.hidden = NO;
        [searchDateImageView setFrame:CGRectMake(SCREEN_WIDTH/2 - pWidth(262)/2, statusBarHeight + pWidth(17), pWidth(262), pWidth(75))];
                
        //更改下面的tableView frame
        [detailListTableView setFrame:CGRectMake(pWidth(3), CGRectGetMaxY(searchDateImageView.frame), SCREEN_WIDTH-pWidth(6), SCREEN_HEIGHT-CGRectGetMaxY(searchDateImageView.frame))];
        //右上角刪除資料按鈕隱藏
        deleteDataButton.hidden = YES;
        //更改搜尋日期 View frame
        
        //更改搜尋日期的背景圖
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
        {
            searchDateImageView.image = [[UIImage imageNamed:@"00_PecordNavigation-total_Date.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(36, 0, 36, 0) resizingMode:UIImageResizingModeStretch];
        }else
        {
            searchDateImageView.image = [UIImage imageNamed:@"00_PecordNavigation-total_Date.png"];
        }

    
        //更改隱藏按鈕 frame
        [searchDayButton setFrame:CGRectMake(0, 0, 262, 75)];
        [self setScrollViewInSearchImageView];
        [self calculateAllSpinCount];
        [self makeScrollerViewShowOrNot];
    }else
    {
        //搜尋日期按鈕隱藏
        searchDayButton.hidden = YES;
        [searchDateImageView setFrame:CGRectMake(SCREEN_WIDTH/2 - pWidth(267)/2, statusBarHeight + pWidth(17), pWidth(267), pWidth(68))];
        //更改下面的tableView frame
        [detailListTableView setFrame:CGRectMake(pWidth(3), CGRectGetMaxY(searchDateImageView.frame), SCREEN_WIDTH-pWidth(6), SCREEN_HEIGHT-CGRectGetMaxY(searchDateImageView.frame))];
        //右上角刪除資料按鈕出現
        deleteDataButton.hidden = NO;
        //更改搜尋日期 View frame
        //更改搜尋日期的背景圖
        searchDateImageView.image = [UIImage imageNamed:@"00_PecordNavigation-data search.png"];
        [self makeScrollerViewShowOrNot];
    }
}
-(void)makeScrollerViewShowOrNot
{
    if ([detailType isEqualToString:@"3"])
    {
        topSearchDateLabel.hidden = YES;
        upYearScrollView.hidden = NO;
        upMonthScrollView.hidden = NO;
        upDayScrollView.hidden = NO;
    }else
    {
        topSearchDateLabel.hidden = NO;
        upYearScrollView.hidden = YES;
        upMonthScrollView.hidden = YES;
        upDayScrollView.hidden = YES;
    }
}
-(void)calculateAllSpinCount
{
    int finalCount = 0;
    [finalArray removeAllObjects];
    NSMutableDictionary *newDataDictionary = [[NSMutableDictionary alloc] init];
    for (int i = 1; i<=wouldShowCellCountWhenSort; i++)
    {
        [newDataDictionary setObject:[NSNumber numberWithInt:0] forKey:[NSString stringWithFormat:@"%i",i]];
        [finalArray addObject:[NSString stringWithFormat:@"%i,0",i]];
    }
    if ([forCalculateDataArray count]>0)
    {
        for (NSArray *matchDataArray in forCalculateDataArray)
        {
            //計算所有搖過的次數
            NSNumber *currentCount = [matchDataArray objectAtIndex:1];
            finalCount  += [currentCount intValue];
            //計算每一顆球搖的次數
            for (NSString *matchString in [matchDataArray objectAtIndex:2])
            {
                //球號
                NSString *ballNum = [[matchString componentsSeparatedByString:@","] objectAtIndex:0];
                //次數
                NSString *ballCount = [[matchString componentsSeparatedByString:@","] objectAtIndex:1];
                int matchBallCountNum = [[newDataDictionary objectForKey:ballNum] intValue];
                NSNumber *finalBallCount = [NSNumber numberWithInt:(matchBallCountNum+[ballCount intValue])];
                [newDataDictionary setObject:finalBallCount forKey:ballNum];
            }
        }
        NSMutableArray *nextArray = [[NSMutableArray alloc] init];
        
        for (NSString *currentBall in [newDataDictionary allKeys])
        {
            NSNumber *currentNum = [newDataDictionary objectForKey:currentBall];
            [nextArray addObject:currentNum];
        }
        for (NSNumber *tempNum in [nextArray sortedArrayUsingSelector:@selector(compare:)])
        {
            for (NSString *keyString in [newDataDictionary allKeys])
            {
                if ([tempNum isEqual:[newDataDictionary objectForKey:keyString]])
                {
                    [finalArray addObject:[NSString stringWithFormat:@"%@,%@",keyString,tempNum]];
                    [newDataDictionary removeObjectForKey:keyString];
                }
            }
        }
        //反過來用
        finalArray = [[[finalArray reverseObjectEnumerator] allObjects] mutableCopy];
    }

    allSpinCount = finalCount;
    NSLog(@"how many Count :%i",finalCount);
//    NSLog(@"finalArray :%@",finalArray);
}
-(NSArray *)makeYearCount
{
    NSMutableSet *yearSet = [[NSMutableSet alloc] init];
    if ([forCalculateDataArray count]>0)
    {
        for (NSArray *listItem in forCalculateDataArray)
        {
            NSString *dateString = [NSString stringWithFormat:@"%@",[listItem objectAtIndex:0]];
            NSString *yearString = [dateString substringToIndex:4];
            [yearSet addObject:yearString];
        }
        
        return [[yearSet allObjects] sortedArrayUsingSelector:@selector(compare:)];
    }else
    {
        return @[@"2014"];
    }

    //test
//    return @[@"2014",@"2015",@"2016"];
}
-(void)setScrollViewInSearchImageView
{
    NSArray *yearArray = [self makeYearCount];
    NSUInteger howManyYear = [yearArray count];
    //UP
    if (upYearScrollView == nil)
    {
        upYearScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(pWidth(46), pWidth(11), pWidth(40), pWidth(20))];
        [upYearScrollView setShowsHorizontalScrollIndicator:NO];
        [upYearScrollView setShowsVerticalScrollIndicator:NO];
        [upYearScrollView setPagingEnabled:YES];
        upYearScrollView.backgroundColor = [UIColor clearColor];
        upYearScrollView.delegate = self;
        upYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pWidth(45), pWidth(20*howManyYear))];
        upYearLabel.backgroundColor = [UIColor clearColor];
        upYearLabel.textAlignment = NSTextAlignmentCenter;
        upYearLabel.textColor = [UIColor redColor];
        upYearLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:14.0];
        upYearLabel.lineBreakMode = NSLineBreakByWordWrapping;
        upYearLabel.numberOfLines = howManyYear;
        [upYearScrollView addSubview:upYearLabel];
        [searchDateImageView addSubview:upYearScrollView];
    }
    if (upMonthScrollView == nil)
    {
        int howManyMonth = 12;
        upMonthScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(pWidth(135), pWidth(11), pWidth(20), pWidth(20))];
        [upMonthScrollView setShowsHorizontalScrollIndicator:NO];
        [upMonthScrollView setShowsVerticalScrollIndicator:NO];
        [upMonthScrollView setPagingEnabled:YES];
        upMonthScrollView.backgroundColor = [UIColor clearColor];
        upMonthScrollView.delegate = self;
        for (int m = 1; m <= howManyMonth; m++) {
            [upMonthScrollView addSubview:[self returnScrollViewLabel:m]];
        }
        [upMonthScrollView setContentSize:CGSizeMake(pWidth(20), pWidth(20*howManyMonth))];
        [searchDateImageView addSubview:upMonthScrollView];
    }
    if (upDayScrollView == nil)
    {
        int howManyDay = 31;
        upDayScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(pWidth(192), pWidth(11), pWidth(20), pWidth(20))];
        [upDayScrollView setShowsHorizontalScrollIndicator:NO];
        [upDayScrollView setShowsVerticalScrollIndicator:NO];
        [upDayScrollView setPagingEnabled:YES];
        upDayScrollView.backgroundColor = [UIColor clearColor];
        upDayScrollView.delegate = self;
        for (int d = 1; d <= howManyDay; d++) {
            [upDayScrollView addSubview:[self returnScrollViewLabel:d]];
        }
        [upDayScrollView setContentSize:CGSizeMake(pWidth(20), pWidth(20*howManyDay))];
        [searchDateImageView addSubview:upDayScrollView];
        searchDateImageView.userInteractionEnabled = YES;
    }
    //Down
    if (downYearScrollView == nil)
    {
        downYearScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(pWidth(24), pWidth(45), pWidth(40), pWidth(20))];
        [downYearScrollView setShowsHorizontalScrollIndicator:NO];
        [downYearScrollView setShowsVerticalScrollIndicator:NO];
        [downYearScrollView setPagingEnabled:YES];
        downYearScrollView.backgroundColor = [UIColor clearColor];
        downYearScrollView.delegate = self;
        downYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pWidth(45), pWidth(20*howManyYear))];
        downYearLabel.backgroundColor = [UIColor clearColor];
        downYearLabel.textAlignment = NSTextAlignmentCenter;
        downYearLabel.textColor = [UIColor redColor];
        downYearLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:14.0];
        downYearLabel.lineBreakMode = NSLineBreakByWordWrapping;
        downYearLabel.numberOfLines = howManyYear;
        [downYearScrollView addSubview:downYearLabel];
        [searchDateImageView addSubview:downYearScrollView];
    }
    if (downMonthScrollView == nil)
    {
        int howManyMonth = 12;
        downMonthScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(pWidth(113), pWidth(45), pWidth(20), pWidth(20))];
        [downMonthScrollView setShowsHorizontalScrollIndicator:NO];
        [downMonthScrollView setShowsVerticalScrollIndicator:NO];
        [downMonthScrollView setPagingEnabled:YES];
        downMonthScrollView.backgroundColor = [UIColor clearColor];
        downMonthScrollView.delegate = self;
        for (int m = 1; m <= howManyMonth; m++) {
            [downMonthScrollView addSubview:[self returnScrollViewLabel:m]];
        }
        [downMonthScrollView setContentSize:CGSizeMake(pWidth(20), pWidth(20*howManyMonth))];
        [searchDateImageView addSubview:downMonthScrollView];
    }
    if (downDayScrollView == nil)
    {
        int howManyDay = 31;
        downDayScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(pWidth(171), pWidth(45), pWidth(20), pWidth(20))];
        [downDayScrollView setShowsHorizontalScrollIndicator:NO];
        [downDayScrollView setShowsVerticalScrollIndicator:NO];
        [downDayScrollView setPagingEnabled:YES];
        downDayScrollView.backgroundColor = [UIColor clearColor];
        downDayScrollView.delegate = self;
        for (int d = 1; d <= howManyDay; d++) {
            [downDayScrollView addSubview:[self returnScrollViewLabel:d]];
        }
        [downDayScrollView setContentSize:CGSizeMake(pWidth(20), pWidth(20*howManyDay))];
        [searchDateImageView addSubview:downDayScrollView];
        searchDateImageView.userInteractionEnabled = YES;
    }
    //會變動的部分 UP
    [upYearLabel setFrame:CGRectMake(0, 0, pWidth(45), pWidth(18*howManyYear))];
    upYearLabel.text = [yearArray componentsJoinedByString:@","];
    [upYearScrollView setContentSize:CGSizeMake(pWidth(20), pWidth(18*howManyYear))];
    [upYearScrollView setContentOffset:CGPointMake(0, 0)];
    [upMonthScrollView setContentOffset:CGPointMake(0, 0)];
    [upDayScrollView setContentOffset:CGPointMake(0, 0)];
    //會變動的部分 down
    [downYearLabel setFrame:CGRectMake(0, 0, pWidth(45), pWidth(18*howManyYear))];
    downYearLabel.text = [yearArray componentsJoinedByString:@","];
    [downYearScrollView setContentSize:CGSizeMake(pWidth(20), pWidth(18*howManyYear))];
    [downYearScrollView setContentOffset:CGPointMake(0, 0)];
    [downMonthScrollView setContentOffset:CGPointMake(0, 0)];
    [downDayScrollView setContentOffset:CGPointMake(0, 0)];
    
    NSLog(@" u y :%@,m :%@,d :%@",NSStringFromCGPoint(upYearScrollView.center),NSStringFromCGPoint(upMonthScrollView.center),NSStringFromCGPoint(upDayScrollView.center));
    NSLog(@" d y :%@,m :%@,d :%@",NSStringFromCGPoint(downYearScrollView.center),NSStringFromCGPoint(downMonthScrollView.center),NSStringFromCGPoint(downDayScrollView.center));
}
-(UILabel *)returnScrollViewLabel:(int )sender
{
    UILabel *currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, pWidth(20 * (sender-1)), pWidth(25), pWidth(20))];
    currentLabel.backgroundColor = [UIColor clearColor];
    currentLabel.textAlignment = NSTextAlignmentCenter;
    currentLabel.textColor = [UIColor redColor];
    currentLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:14];
    NSString *monthString = [NSString stringWithFormat:@"%@%d", (sender <10) ? @"0" : @"", sender];
    currentLabel.text = monthString;
    currentLabel.lineBreakMode = NSLineBreakByClipping;
    currentLabel.numberOfLines = 1;
    //        monthLabel.adjustsFontSizeToFitWidth = YES;
    CGSize maximumLabelSize = CGSizeMake(currentLabel.frame.size.width, CGFLOAT_MAX);
    CGSize expectSize = [currentLabel sizeThatFits:maximumLabelSize];
    currentLabel.frame = CGRectMake(currentLabel.frame.origin.x, currentLabel.frame.origin.y, expectSize.width, expectSize.height);
    return currentLabel;
}
-(void)searchButtonAction
{
    //先關掉左右兩邊的Button
    float tableViewAlpha = 0.0;
    CGRect searchImageViewRect = searchDateImageView.frame;

    CGPoint upYearCenter = upYearScrollView.center;
    CGPoint upMonCenter = upMonthScrollView.center;
    CGPoint upDayCenter = upDayScrollView.center;
    CGPoint downYearCenter = downYearScrollView.center;
    CGPoint downMonCenter = downMonthScrollView.center;
    CGPoint downDayCenter = downDayScrollView.center;
    
    if (backButton.enabled == NO ||restoreNow)
    {//收上去
        backButton.enabled = YES;
        if ([detailType isEqualToString:@"3"])
        {
            searchImageViewRect = CGRectMake(SCREEN_WIDTH/2 - pWidth(262)/2, statusBarHeight + pWidth(17), pWidth(262), pWidth(75));
        }else
        {
            searchImageViewRect = CGRectMake(SCREEN_WIDTH/2 - pWidth(267)/2, statusBarHeight + pWidth(17), pWidth(267), pWidth(68));
        }
        [detailListTableView setUserInteractionEnabled:YES];
        searchDayButton.hidden = NO;
        tableViewAlpha = 1.0;
        
        upDayCenter.y = pWidth(20);
        upMonCenter.y = pWidth(20);
        upYearCenter.y = pWidth(20);
        downDayCenter.y = pWidth(54);
        downMonCenter.y = pWidth(54);
        downYearCenter.y = pWidth(54);
        
    }else
    {//放下來
        backButton.enabled = NO;
        searchImageViewRect.size.height +=30;
        searchImageViewRect.origin.y +=30;
        [detailListTableView setUserInteractionEnabled:NO];
        searchDayButton.hidden = YES;
        tableViewAlpha = 0.7;
        
        upDayCenter.y += 1;
        upMonCenter.y += 1;
        upYearCenter.y += 1;
        downDayCenter.y += 30;
        downMonCenter.y += 30;
        downYearCenter.y += 30;
        
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [searchDateImageView setFrame:searchImageViewRect];
                         detailListTableView.alpha = tableViewAlpha;
                         [upYearScrollView setCenter:upYearCenter];
                         [upMonthScrollView setCenter:upMonCenter];
                         [upDayScrollView setCenter:upDayCenter];
                         [downYearScrollView setCenter:downYearCenter];
                         [downMonthScrollView setCenter:downMonCenter];
                         [downDayScrollView setCenter:downDayCenter];
                         if (!backButton.enabled)
                         {
                             upYearScrollView.transform = CGAffineTransformMakeScale(FRAME_SCALE_MID, FRAME_SCALE_MID);
                             upMonthScrollView.transform = CGAffineTransformMakeScale(FRAME_SCALE_MID, FRAME_SCALE_MID);
                             upDayScrollView.transform = CGAffineTransformMakeScale(FRAME_SCALE_MID, FRAME_SCALE_MID);
                             upYearScrollView.userInteractionEnabled = YES;
                             upMonthScrollView.userInteractionEnabled = YES;
                             upDayScrollView.userInteractionEnabled = YES;
                             
                             downYearScrollView.transform = CGAffineTransformMakeScale(FRAME_SCALE_MID, FRAME_SCALE_MID);
                             downMonthScrollView.transform = CGAffineTransformMakeScale(FRAME_SCALE_MID, FRAME_SCALE_MID);
                             downDayScrollView.transform = CGAffineTransformMakeScale(FRAME_SCALE_MID, FRAME_SCALE_MID);
                             downYearScrollView.userInteractionEnabled = YES;
                             downMonthScrollView.userInteractionEnabled = YES;
                             downDayScrollView.userInteractionEnabled = YES;
                         }else
                         {
                             upYearScrollView.transform = CGAffineTransformMakeScale(FRAME_SCALE_DEFAULT, FRAME_SCALE_DEFAULT);
                             upMonthScrollView.transform = CGAffineTransformMakeScale(FRAME_SCALE_DEFAULT, FRAME_SCALE_DEFAULT);
                             upDayScrollView.transform = CGAffineTransformMakeScale(FRAME_SCALE_DEFAULT, FRAME_SCALE_DEFAULT);
                             upYearScrollView.userInteractionEnabled = NO;
                             upMonthScrollView.userInteractionEnabled = NO;
                             upDayScrollView.userInteractionEnabled = NO;
                             
                             downYearScrollView.transform = CGAffineTransformMakeScale(FRAME_SCALE_DEFAULT, FRAME_SCALE_DEFAULT);
                             downMonthScrollView.transform = CGAffineTransformMakeScale(FRAME_SCALE_DEFAULT, FRAME_SCALE_DEFAULT);
                             downDayScrollView.transform = CGAffineTransformMakeScale(FRAME_SCALE_DEFAULT, FRAME_SCALE_DEFAULT);
                             downYearScrollView.userInteractionEnabled = NO;
                             downMonthScrollView.userInteractionEnabled = NO;
                             downDayScrollView.userInteractionEnabled = NO;
                         }
                     } completion:^(BOOL finished)
     {
     }];
}
-(void)setSearchDateImageViewForNew
{
    NSArray *allYearArray = [self makeYearCount];
    if ([allDataArrayFromSuperView count]>0)
    {
        //上面
        NSArray *firstDateArray = [allDataArrayFromSuperView lastObject];
        NSString *firstDateString = [NSString stringWithFormat:@"%@",[firstDateArray objectAtIndex:0]];
        NSString *firstYearString = [firstDateString substringToIndex:4];
        NSString *firstMonthString = [firstDateString substringWithRange:NSMakeRange(5, 2)];
        NSString *firstDayString = [firstDateString substringWithRange:NSMakeRange(8, 2)];
        //下面
        NSArray *lastDateArray = [allDataArrayFromSuperView objectAtIndex:0];
        NSString *lastDateString = [NSString stringWithFormat:@"%@",[lastDateArray objectAtIndex:0]];
        NSString *lastYearString = [lastDateString substringToIndex:4];
        NSString *lastMonthString = [lastDateString substringWithRange:NSMakeRange(5, 2)];
        NSString *lastDayString = [lastDateString substringWithRange:NSMakeRange(8, 2)];
        
        [upYearScrollView setContentOffset:CGPointMake(upYearScrollView.contentOffset.x,upYearScrollView.frame.size.height*[allYearArray indexOfObject:firstYearString])];
        [upMonthScrollView setContentOffset:CGPointMake(upMonthScrollView.contentOffset.x, upMonthScrollView.frame.size.height*([firstMonthString intValue]-1))];
        [upDayScrollView setContentOffset:CGPointMake(upDayScrollView.contentOffset.x, upDayScrollView.frame.size.height*([firstDayString intValue]-1))];
        
        [downYearScrollView setContentOffset:CGPointMake(downYearScrollView.contentOffset.x,downYearScrollView.frame.size.height*[allYearArray indexOfObject:lastYearString])];
        [downMonthScrollView setContentOffset:CGPointMake(downMonthScrollView.contentOffset.x, downMonthScrollView.frame.size.height*([lastMonthString intValue]-1))];
        [downDayScrollView setContentOffset:CGPointMake(downDayScrollView.contentOffset.x, downDayScrollView.frame.size.height*([lastDayString intValue]-1))];
    }
}
-(void)makeBallSet
{
    switch ([playType intValue])
    {
        case DBTYPE_STAR_3:
            wouldChangeYellowCellAtTop = THREE_BALL_COUNT;
            wouldShowCellCountWhenSort = 10;
            startBallNum = 0;
            cellIDString = @"DBTYPE_STAR_3";
            break;
        case DBTYPE_STAR_4:
            wouldChangeYellowCellAtTop = FOUR_BALL_COUNT;
            wouldShowCellCountWhenSort = 10;
            startBallNum = 0;
            cellIDString = @"DBTYPE_STAR_4";
            break;
        case DBTYPE_BIG_LOTTO:
            wouldChangeYellowCellAtTop = SIX_BALL_COUNT;
            wouldShowCellCountWhenSort = 49;
            startBallNum = 1;
            cellIDString = @"DBTYPE_BIG_LOTTO";
            break;
        case DBTYPE_WEI_LI:
            wouldChangeYellowCellAtTop = WEI_LI_BALL_COUNT;
            wouldShowCellCountWhenSort = 38;
            startBallNum = 1;
            cellIDString = @"DBTYPE_WEI_LI";
            break;
        case DBTYPE_FIVE_THREE_NINE:
            wouldChangeYellowCellAtTop = FIVE_BALL_COUNT;
            wouldShowCellCountWhenSort = 39;
            startBallNum = 1;
            cellIDString = @"DBTYPE_FIVE_THREE_NINE";
            break;
        case DBTYPE_BINGO:
            wouldChangeYellowCellAtTop = NINE_BALL_COUNT;
            wouldShowCellCountWhenSort = 36;
            startBallNum = 1;
            cellIDString = @"DBTYPE_BINGO";
            break;
        case DBTYPE_THREE_NINE:
            wouldChangeYellowCellAtTop = FOUR_BALL_COUNT;
            wouldShowCellCountWhenSort = 39;
            startBallNum = 1;
            cellIDString = @"DBTYPE_THREE_NINE";
            break;
        case DBTYPE_THREE_EIGHT:
            wouldChangeYellowCellAtTop = FIVE_BALL_COUNT;
            wouldShowCellCountWhenSort = 38;
            startBallNum = 1;
            cellIDString = @"DBTYPE_THREE_EIGHT";
            break;
        case DBTYPE_FOUR_NINE:
            wouldChangeYellowCellAtTop = FOUR_BALL_COUNT;
            wouldShowCellCountWhenSort = 49;
            startBallNum = 1;
            cellIDString = @"DBTYPE_FOUR_NINE";
            break;
        default:
            break;
    }
}
-(void)detectCellBallCount
{
    if ([[DEFAULTS objectForKey:@"AnalysisCellBallCount"] intValue] ==wouldChangeYellowCellAtTop)
    {
        cellShouldLayOutAgain = YES;
    }
}
@end
