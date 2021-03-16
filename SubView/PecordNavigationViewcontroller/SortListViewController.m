//
//  SortListViewController.m
//  Lotto
//
//  Created by brownie on 2014/2/2.
//  Copyright (c) 2014年 brownieBBK. All rights reserved.
//

#import "SortListViewController.h"
#import "Constant.h"
@interface SortListViewController ()<UIScrollViewDelegate>
{
    UIButton *deleteDataButton;
    // Cell
    UITableView *sortListTableView;
    NSMutableArray *matchDataArray;
    SortAndAllDataDetailViewcontroller *detailViewController;
    UIImageView *searchDateImageView;
    UIScrollView *yearScrollView;
    UILabel *yearLabel;
    UIScrollView *monthScrollView;
    UIScrollView *dayScrollView;
    //203
    UIButton *searchDayButton;
    NSMutableArray *detectDateArray;
    BOOL restoreNow;
    //204
    BOOL deleteSwitchOpen;
    float barHeight ;    
}
@end

@implementation SortListViewController
@synthesize playType;
@synthesize detailType;
@synthesize allDataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.view.backgroundColor = [UIColor orangeColor];
        matchDataArray = [[NSMutableArray alloc] init];
        detectDateArray = [[NSMutableArray alloc] init];
        barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;        
    }
    return self;
}
-(void)reloadCoreDataforSortLiatView
{
    NSString *currentTimeStamp = [DEFAULTS objectForKey:@"ShouldDeleteTime"];
    for (NSArray *matchArray in allDataArray)
    {
        NSString *matchString = [NSString stringWithFormat:@"%@",[matchArray objectAtIndex:0]];
        NSLog(@"matchString:%@",matchString);
        if ([matchString isEqualToString:currentTimeStamp])
        {
            [DEFAULTS setObject:@"" forKey:@"ShouldDeleteTime"];
            [DEFAULTS synchronize];
            [allDataArray removeObject:matchArray];
            break;
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([[DEFAULTS objectForKey:@"NeedReloadCoreData"] isEqualToString:@"YES"])
    {
        [DEFAULTS setObject:@"NO" forKey:@"NeedReloadCoreData"];
        [DEFAULTS synchronize];
        [self reloadCoreDataforSortLiatView];
    }
    [matchDataArray removeAllObjects];    
    restoreNow = NO;
    deleteSwitchOpen = NO;
    searchDayButton.enabled = YES;
    matchDataArray = [allDataArray mutableCopy];
    [sortListTableView reloadData];
    [self setScrollViewInSearchImageView];
    NSLog(@"matchDataArray count :%i",(int)[matchDataArray count]);
    [self detectSearchImageCanShowOrNot];
    [self setDetailView];
    [self setBackButtonImage];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
	// Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //收上去用的
    restoreNow = YES;
    [self searchButtonActionByList];

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
    [self setSortListTableView];
    [self.view addSubview:frameImageView];
    [self.view addSubview:backButton];
    [self.view bringSubviewToFront:sortListTableView];
    [self.view bringSubviewToFront:frameImageView];
    [self.view bringSubviewToFront:backButton];
    //日期標簽
    if (searchDateImageView == nil)
    {
        searchDateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - pWidth(267)/2, statusBarHeight + pWidth(17), pWidth(267), pWidth(68))];

//        searchDateImageView.image = [UIImage imageNamed:@"00_PecordNavigation-data search.png"];
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
        {
            searchDateImageView.image = [[UIImage imageNamed:@"00_PecordNavigation-data search.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(45, 0, 22, 0) resizingMode:UIImageResizingModeStretch];
        }else
        {
            searchDateImageView.image = [UIImage imageNamed:@"00_PecordNavigation-data search.png"];
        }

//        [[UIImage imageNamed:@"00_PecordNavigation-data search.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 16) resizingMode:UIImageResizingModeStretch];
        [self.view addSubview:searchDateImageView];
        //隱形按鈕
        searchDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchDayButton setFrame:CGRectMake(0, 0, searchDateImageView.frame.size.width, searchDateImageView.frame.size.height)];
        [searchDayButton addTarget:self action:@selector(searchButtonActionByList) forControlEvents:UIControlEventTouchUpInside];
        searchDayButton.backgroundColor = [UIColor clearColor];
        [searchDateImageView addSubview:searchDayButton];
    }
    
    if (deleteDataButton == nil)
    {
        //刪除資料按鈕
        deleteDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteDataButton setImage:[UIImage imageNamed:@"00_PecordNavigation-delete up.png"] forState:UIControlStateNormal];
        [deleteDataButton setImage:[UIImage imageNamed:@"00_PecordNavigation-delete down.png"] forState:UIControlStateSelected];
        [deleteDataButton setImage:[UIImage imageNamed:@"00_PecordNavigation-delete down.png"] forState:UIControlStateHighlighted];
        [deleteDataButton setFrame:CGRectMake(SCREEN_WIDTH-5-pWidth(90), statusBarHeight+pHeight(5),pWidth(95), pWidth(120))];
        [deleteDataButton addTarget:self action:@selector(deleteDataButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:deleteDataButton];
    }
}

-(void)deleteDataButton:(UIButton *)sender
{
//    sender.selected = YES;
//    
//    [self dismissViewControllerAnimated:YES completion:^
//     {
//         sender.selected = NO;
//     }];
    deleteSwitchOpen = !deleteSwitchOpen;
    searchDayButton.enabled = !searchDayButton.enabled;
    [sortListTableView reloadData];
    
}
-(void)setBackButtonImage
{
    [backButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_DateBack-up.png",playType]] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_DateBack-down.png",playType]] forState:UIControlStateSelected];
    [backButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_DateBack-down.png",playType]] forState:UIControlStateHighlighted];
}
-(void)setSortListTableView
{
    if (sortListTableView == nil)
    {
        sortListTableView = [[UITableView alloc] initWithFrame:CGRectMake(3, (95+20)-6, SCREEN_WIDTH-6, SCREEN_HEIGHT-(95+barHeight)) style:UITableViewStyleGrouped];
        sortListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        sortListTableView.backgroundColor = [UIColor clearColor];
        sortListTableView.delegate = self;
        sortListTableView.dataSource = self;
        [self.view addSubview:sortListTableView];
    }
}
#pragma mark - 
#pragma mark TableViewDelegate
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [matchDataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PecordListCell";
    PecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PecordListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier ];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor clearColor];
    if ([[[matchDataArray objectAtIndex:[indexPath row]] objectAtIndex:4] isEqualToString:@"NO"])
    {
        cell.backGroundImageView.image = [UIImage imageNamed: @"00_DataAnalysis-Red 1.png"];
    }else
    {
        cell.backGroundImageView.image = [UIImage imageNamed: @"00_DataAnalysis-Yellow 1.png"];        
    }
    if (deleteSwitchOpen)
    {
        cell.deleteCellButton.hidden = NO;
    }else
    {
        cell.deleteCellButton.hidden = YES;
    }
    cell.userInteractionEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.numLabel.text = [NSString stringWithFormat:@"%i",(int)[indexPath row]+1];
    cell.currentDataImage.image = [UIImage imageWithData:[[matchDataArray objectAtIndex:[indexPath row]] objectAtIndex:1]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    cell.dateLabel.text = [dateFormatter stringFromDate:[[matchDataArray objectAtIndex:[indexPath row]] objectAtIndex:0]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PecordListCell *currentCell = (PecordListCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"index :%@",indexPath);
    if (!deleteSwitchOpen)
    {
        //以下的Array 分別是 1,時間 2,搖的次數 3,主要dictionary
        detailViewController.allDataArrayFromSuperView = [[NSArray arrayWithObjects:[[matchDataArray objectAtIndex:[indexPath row]] objectAtIndex:0],[[matchDataArray objectAtIndex:[indexPath row]] objectAtIndex:3],[[matchDataArray objectAtIndex:[indexPath row]] objectAtIndex:2], nil] mutableCopy];
        [self presentViewController:detailViewController animated:YES completion:^
         {
             if (currentCell.selected)
             {
                 currentCell.selected = !currentCell.selected;
             }
         }];
    }else
    {
        currentCell.deleteCellButton.selected = YES;
        [self deleteCellByCellActionWithIndex:indexPath];
    }
}
-(void)setDetailView
{
    if (detailViewController == nil)
    {
        detailViewController = [[SortAndAllDataDetailViewcontroller alloc] init];
        detailViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        detailViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    detailViewController.playType = playType;
    detailViewController.detailType = detailType;
}
-(NSArray *)makeYearCount
{
    NSMutableSet *yearSet = [[NSMutableSet alloc] init];
    for (NSArray *listItem in matchDataArray)
    {
        NSString *dateString = [NSString stringWithFormat:@"%@",[listItem objectAtIndex:0]];
        NSString *yearString = [dateString substringToIndex:4];
        [yearSet addObject:yearString];
    }
    
    return [[yearSet allObjects] sortedArrayUsingSelector:@selector(compare:)];
//test
//    return @[@"2014",@"2015",@"2016"];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"停下來");
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:self.view];
        CGRect canTouchRect = CGRectMake(0, 168, SCREEN_WIDTH, SCREEN_HEIGHT-168);
        NSLog(@"location :%@",NSStringFromCGPoint(location));
        if (CGRectContainsPoint(canTouchRect, location))
        {
            if (searchDateImageView.alpha!=0)
            {
                [self searchButtonActionByList];
                [self calculateDate];
                [self detactDayWithTableViewList];
            }
            break;
        }
    }

}
-(void)detactDayWithTableViewList
{
    BOOL haveToReplace = YES;
    NSUInteger indexOfLastRow = 0;
    //改變要用到的顯示資料
    for (NSArray *listItem in matchDataArray)
    {
        NSString *dateString = [NSString stringWithFormat:@"%@",[listItem objectAtIndex:0]];
        NSString *yearString = [dateString substringToIndex:4];
        NSString *dayString = [dateString substringWithRange:NSMakeRange(8, 2)];
        NSString *monthString = [dateString substringWithRange:NSMakeRange(5, 2)];

        if ([[detectDateArray objectAtIndex:0] isEqualToString:yearString] &&[[detectDateArray objectAtIndex:1] isEqualToString:monthString]&&[[detectDateArray objectAtIndex:2] isEqualToString:dayString])
        {
            [[matchDataArray objectAtIndex:[matchDataArray indexOfObject:listItem]] replaceObjectAtIndex:4 withObject:@"YES"];
            if (haveToReplace)
            {
                haveToReplace = NO;
                indexOfLastRow = [matchDataArray indexOfObject:listItem];
            }
        }
        else
        {
            [[matchDataArray objectAtIndex:[matchDataArray indexOfObject:listItem]] replaceObjectAtIndex:4 withObject:@"NO"];
        }
    }
    //畫面重整
    [sortListTableView reloadData];
    //移動到那一條
    if (!haveToReplace)
    {
        [sortListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexOfLastRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
-(void)calculateDate
{
    [detectDateArray removeAllObjects];
    
    CGFloat yearHeight = yearScrollView.frame.size.height;
    NSInteger currentYear = ((yearScrollView.contentOffset.y - yearHeight / 2) / yearHeight) + 1;
    
    CGFloat monthHeight = monthScrollView.frame.size.height;
    NSInteger currentMonth = ((monthScrollView.contentOffset.y - monthHeight / 2) / monthHeight) + 1;
    
    CGFloat dayHeight = dayScrollView.frame.size.height;
    NSInteger currentDay = ((dayScrollView.contentOffset.y - dayHeight / 2) / dayHeight) + 1;
    if ([[self makeYearCount] count]==1)
    {
        NSLog(@"現在是 :%@ 年",[[self makeYearCount] objectAtIndex:0]);
    }else
    {
        NSLog(@"現在是 :%@ 年",[[self makeYearCount] objectAtIndex:currentYear]);
    }
    NSLog(@"現在是 :%i 月",(int)currentMonth+1);
    NSLog(@"現在是 :%i 日",(int)currentDay+1);
    NSString *yearS = @"";
    NSString *monthS = @"";
    NSString *dayS = @"";
    if ([[self makeYearCount] count]==1)
    {
        yearS =[[self makeYearCount] objectAtIndex:0];
    }else
    {
        yearS =[[self makeYearCount] objectAtIndex:currentYear];
    }
    if ((currentMonth+1)<10)
    {
        monthS = [NSString stringWithFormat:@"0%i",(int)currentMonth+1];
    }else
    {
        monthS = [NSString stringWithFormat:@"%i",(int)currentMonth+1];
    }
    if ((currentDay+1)<10)
    {
        dayS = [NSString stringWithFormat:@"0%i",(int)currentDay+1];
    }else
    {
        dayS = [NSString stringWithFormat:@"%i",(int)currentDay+1];
    }
    [detectDateArray addObject:yearS];
    [detectDateArray addObject:monthS];
    [detectDateArray addObject:dayS];
}
-(void)deleteCellByCellActionWithIndex:(NSIndexPath *)matchIndexPath
{
    PecordListCell *currentCell = (PecordListCell *)[sortListTableView cellForRowAtIndexPath:matchIndexPath];
    //先刪除資料庫
    SortTable *matchSortTable = [[SortTable MR_findByAttribute:@"timeStamp" withValue:[[matchDataArray objectAtIndex:[matchIndexPath row]] objectAtIndex:0]] lastObject];
    if (matchSortTable!=nil)
    {
        [matchSortTable MR_deleteEntity];
        NSLog(@"sort Table :%@",matchSortTable);
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error)
        {
            if (success)
            {    //再刪除catch data
                currentCell.deleteCellButton.selected = NO;
                [matchDataArray removeObjectAtIndex:[matchIndexPath row]];
                [sortListTableView beginUpdates];
                [sortListTableView deleteRowsAtIndexPaths:@[matchIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [sortListTableView endUpdates];
                [self performSelector:@selector(deleteDataButton:) withObject:nil afterDelay:0.2];
                [self detectSearchImageCanShowOrNot];
            }
        }];
    }
}
-(void)detectSearchImageCanShowOrNot
{
    if ([matchDataArray count]==0)
    {
        searchDayButton.hidden = YES;
        searchDateImageView.alpha = 0.0;
    }else
    {
        searchDayButton.hidden = NO;
        searchDateImageView.alpha = 1.0;
        [self setSearchDateImageViewForNew];
    }
}
-(void)setScrollViewInSearchImageView
{
    NSArray *yearArray = [self makeYearCount];
    NSUInteger howManyYear = [yearArray count];
    if (yearScrollView == nil)
    {
        yearScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(38, 38, 45, 20)];
        [yearScrollView setShowsHorizontalScrollIndicator:NO];
        [yearScrollView setShowsVerticalScrollIndicator:NO];
        [yearScrollView setPagingEnabled:YES];
        yearScrollView.backgroundColor = [UIColor clearColor];
        yearScrollView.delegate = self;
        yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 45, 20*howManyYear)];
        yearLabel.backgroundColor = [UIColor clearColor];
        yearLabel.textAlignment = NSTextAlignmentCenter;
        yearLabel.textColor = [UIColor blackColor];
        yearLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:14];
        yearLabel.lineBreakMode = NSLineBreakByWordWrapping;
        yearLabel.numberOfLines = howManyYear;
        [yearScrollView addSubview:yearLabel];
        [searchDateImageView addSubview:yearScrollView];
    }
    [yearLabel setFrame:CGRectMake(0, 2, 45, 18*howManyYear)];
    NSString *yearString = [yearArray componentsJoinedByString:@","];
    yearLabel.text = yearString;
    [yearScrollView setContentSize:CGSizeMake(20, 18*howManyYear)];
    [yearScrollView setContentOffset:CGPointMake(0, 0)];
    
    if (monthScrollView == nil)
    {
        int howManyMonth = 12;
        monthScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(140, 38, 20, 20)];
        [monthScrollView setShowsHorizontalScrollIndicator:NO];
        [monthScrollView setShowsVerticalScrollIndicator:NO];
        [monthScrollView setPagingEnabled:YES];
        monthScrollView.backgroundColor = [UIColor clearColor];
        monthScrollView.delegate = self;
        for (int m = 1; m <= howManyMonth; m++) {
            [monthScrollView addSubview:[self returnScrollViewLabel:m]];
        }
        [searchDateImageView addSubview:monthScrollView];
        [monthScrollView setContentSize:CGSizeMake(20, 20*howManyMonth)];
    }

    [monthScrollView setContentOffset:CGPointMake(0, 0)];
    if (dayScrollView == nil)
    {
        int howManyDay = 31;
        dayScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(206, 38, 20, 20)];
        [dayScrollView setShowsHorizontalScrollIndicator:NO];
        [dayScrollView setShowsVerticalScrollIndicator:NO];
        [dayScrollView setPagingEnabled:YES];
        dayScrollView.backgroundColor = [UIColor clearColor];
        dayScrollView.delegate = self;
        for (int d = 1; d <= howManyDay; d++) {
            [dayScrollView addSubview:[self returnScrollViewLabel:d]];
        }
        [searchDateImageView addSubview:dayScrollView];
        [dayScrollView setContentSize:CGSizeMake(20, 20*howManyDay)];
    }

    [dayScrollView setContentOffset:CGPointMake(0, 0)];
    searchDateImageView.userInteractionEnabled = YES;
    CGPoint yearCenter = CGPointMake(pWidth(60.5), 47);
    CGPoint monCenter = CGPointMake(pWidth(150), 47);
    CGPoint dayCenter = CGPointMake(pWidth(216), 47);
    [yearScrollView setCenter:yearCenter];
    [monthScrollView setCenter:monCenter];
    [dayScrollView setCenter:dayCenter];
    NSLog(@"y :%@,m :%@,d :%@",NSStringFromCGPoint(yearScrollView.center),NSStringFromCGPoint(monthScrollView.center),NSStringFromCGPoint(dayScrollView.center));
}
-(UILabel *)returnScrollViewLabel:(int )sender
{
    UILabel *currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20 * (sender-1), 25, 20)];
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
-(void)searchButtonActionByList
{
    //先關掉左右兩邊的Button
    float tableViewAlpha = 0.0;
    CGRect searchImageViewRect = searchDateImageView.frame;
    CGPoint yearCenter = yearScrollView.center;
    CGPoint monCenter = monthScrollView.center;
    CGPoint dayCenter = dayScrollView.center;
    
    if ((searchImageViewRect.origin.y != statusBarHeight + pWidth(17))||restoreNow)
    {//收上去
        backButton.enabled = YES;
        deleteDataButton.enabled = YES;
        searchImageViewRect = CGRectMake(SCREEN_WIDTH/2 - pWidth(267)/2, statusBarHeight + pWidth(17), pWidth(267), pWidth(68));
        [sortListTableView setUserInteractionEnabled:YES];
        searchDayButton.hidden = NO;
        tableViewAlpha = 1.0;

        yearCenter.x =pWidth(60.5);
        monCenter.x =pWidth(150);
        dayCenter.x =pWidth(216);
        yearCenter.y =47;
        monCenter.y =47;
        dayCenter.y =47;
    }else
    {//放下來
        backButton.enabled = NO;
        deleteDataButton.enabled = NO;
        searchImageViewRect.size.height +=30;
        searchImageViewRect.origin.y +=30;
        [sortListTableView setUserInteractionEnabled:NO];
        searchDayButton.hidden = YES;
        tableViewAlpha = 0.7;

        yearCenter.x +=2;
        monCenter.x +=1;
        dayCenter.x +=2;
        yearCenter.y +=15;
        monCenter.y +=15;
        dayCenter.y +=15;
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         sortListTableView.alpha = tableViewAlpha;
                         [searchDateImageView setFrame:searchImageViewRect];
                         
                         [yearScrollView setCenter:yearCenter];
                         [monthScrollView setCenter:monCenter];
                         [dayScrollView setCenter:dayCenter];
                         if (!backButton.enabled)
                         {
                             yearScrollView.transform = CGAffineTransformMakeScale(FRAME_SCALE_MAX, FRAME_SCALE_MAX);
                             monthScrollView.transform = CGAffineTransformMakeScale(FRAME_SCALE_MAX, FRAME_SCALE_MAX);
                             dayScrollView.transform = CGAffineTransformMakeScale(FRAME_SCALE_MAX, FRAME_SCALE_MAX);
                             yearScrollView.userInteractionEnabled = YES;
                             monthScrollView.userInteractionEnabled = YES;
                             dayScrollView.userInteractionEnabled = YES;
                         }else
                         {
                             yearScrollView.transform = CGAffineTransformMakeScale(FRAME_SCALE_DEFAULT, FRAME_SCALE_DEFAULT);
                             monthScrollView.transform = CGAffineTransformMakeScale(FRAME_SCALE_DEFAULT, FRAME_SCALE_DEFAULT);
                             dayScrollView.transform = CGAffineTransformMakeScale(FRAME_SCALE_DEFAULT, FRAME_SCALE_DEFAULT);
                             yearScrollView.userInteractionEnabled = NO;
                             monthScrollView.userInteractionEnabled = NO;
                             dayScrollView.userInteractionEnabled = NO;
                         }

                     } completion:^(BOOL finished)
     {
     }];
}
-(void)setSearchDateImageViewForNew
{
    NSArray *allYearArray = [self makeYearCount];
    if ([matchDataArray count]>0)
    {
        NSArray *firstDateArray = [matchDataArray objectAtIndex:0];
        NSString *firstDateString = [NSString stringWithFormat:@"%@",[firstDateArray objectAtIndex:0]];
        NSString *firstYearString = [firstDateString substringToIndex:4];
        NSString *firstMonthString = [firstDateString substringWithRange:NSMakeRange(5, 2)];
        NSString *firstDayString = [firstDateString substringWithRange:NSMakeRange(8, 2)];
        //讓最上面的日期搜尋調整到最新資料日期
        [yearScrollView setContentOffset:CGPointMake(yearScrollView.contentOffset.x,yearScrollView.frame.size.height*[allYearArray indexOfObject:firstYearString])];
        [monthScrollView setContentOffset:CGPointMake(monthScrollView.contentOffset.x, monthScrollView.frame.size.height*([firstMonthString intValue]-1))];
        [dayScrollView setContentOffset:CGPointMake(dayScrollView.contentOffset.x, dayScrollView.frame.size.height*([firstDayString intValue]-1))];
        
        //找到所有符合日期的都變色
        for (NSArray *listItem in matchDataArray)
        {
            NSString *dateString = [NSString stringWithFormat:@"%@",[listItem objectAtIndex:0]];
            NSString *yearString = [dateString substringToIndex:4];
            NSString *dayString = [dateString substringWithRange:NSMakeRange(8, 2)];
            NSString *monthString = [dateString substringWithRange:NSMakeRange(5, 2)];
            
            if ([firstYearString isEqualToString:yearString] &&
                [firstMonthString isEqualToString:monthString]&&
                [firstDayString isEqualToString:dayString])
            {
            [[matchDataArray objectAtIndex:[matchDataArray indexOfObject:listItem]] replaceObjectAtIndex:4 withObject:@"YES"];
            }
        }        
        [sortListTableView reloadData];
    }
}
- (void)didChangeStatusBarFrame:(NSNotification*)notification
{
    NSValue*statusBarFrameValue = [notification.userInfo valueForKey:UIApplicationStatusBarFrameUserInfoKey];
    CGRect statusBarFrame =[statusBarFrameValue CGRectValue];
    barHeight = statusBarFrame.size.height;
    CGRect mainViewRect = mainBackImageView.frame;
    CGRect frameViewRect = frameImageView.frame;
    CGRect tableViewFrame = sortListTableView.frame;
    
    mainViewRect.size.height = SCREEN_HEIGHT-statusBarHeight;
    frameViewRect.size.height = SCREEN_HEIGHT-statusBarHeight;
    tableViewFrame.size.height = SCREEN_HEIGHT-statusBarHeight-95;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
     {
         [mainBackImageView setFrame:mainViewRect];
         
         [frameImageView setFrame:frameViewRect];
         [sortListTableView setFrame:tableViewFrame];
     } completion:nil];
}
@end
