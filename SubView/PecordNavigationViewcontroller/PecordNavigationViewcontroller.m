//
//  PecordNavigationViewcontroller.m
//  Lotto
//
//  Created by brownie on 2014/1/28.
//  Copyright (c) 2014年 brownieBBK. All rights reserved.
//

#import "PecordNavigationViewcontroller.h"
#import "Constant.h"
@interface PecordNavigationViewcontroller ()
{
    UIButton *clearDataButton;
    UIButton *mailToButton;
    UIButton *dataAnalyze;
    UIImageView *buttonButtom;
    // 2/1
    SortListViewController *sortListViewController;
    //2/4
    SortAndAllDataDetailViewcontroller *sortAndAllDataListViewController;
    float barHeight ;    
}
@end

@implementation PecordNavigationViewcontroller
@synthesize pecordTableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor orangeColor];
        barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        [self setUI];
        [self setUpThreeViewController];
    }
    return self;
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
    
    [self.view addSubview:backButton];
    [self.view addSubview:frameImageView];
    [self setPecordNaviTableView];
    [self.view bringSubviewToFront:backButton];

}

#pragma mark -
#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    tempView.backgroundColor = [UIColor clearColor];
    return tempView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rowData = @[@"Star3"
                         ,@"Star4"
                         ,@"BigLotto"
                         ,@"Wei_Li"
                         ,@"539"
                         ,@"Bingo"
                         ,@"39"
                         ,@"38"
                         ,@"49"];
    return  [rowData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier ];
    }
    UIImageView *currentView = [self makeCellImageViewWithRowNum:(int)[indexPath row]];

    currentView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i_PecordNavigation.png",(int)[indexPath row]+1]];

    [cell.contentView addSubview:currentView];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = YES;
    return cell;
}
-(void)setPecordNaviTableView
{
    if (pecordTableView == nil)
    {
        pecordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBarHeight + 46, SCREEN_WIDTH, SCREEN_HEIGHT-(46+statusBarHeight)) style:UITableViewStylePlain];
        pecordTableView.delegate = self;
        pecordTableView.dataSource = self;
        pecordTableView.bounces = NO;
        pecordTableView.backgroundColor = [UIColor clearColor];
        pecordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:pecordTableView];
    }
}
-(UIImageView *)makeCellImageViewWithRowNum:(int)rowNum
{
    UIImageView *currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, 66)];
    
    UIButton *rankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rankButton setFrame:CGRectMake(pWidth(73), pHeight(2), pWidth(72), pHeight(58))];
    [rankButton setImage:[UIImage imageNamed:@"00_PecordNavigation-rank up.png"] forState:UIControlStateNormal];
    [rankButton setImage:[UIImage imageNamed:@"00_PecordNavigation-rank down.png"] forState:UIControlStateSelected];
    [rankButton setImage:[UIImage imageNamed:@"00_PecordNavigation-rank down.png"] forState:UIControlStateHighlighted];
    
    UIButton *allDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [allDataButton setFrame:CGRectMake(pWidth(140), pHeight(2), pWidth(72), pHeight(58))];
    [allDataButton setImage:[UIImage imageNamed:@"00_PecordNavigation-total up.png"] forState:UIControlStateNormal];
    [allDataButton setImage:[UIImage imageNamed:@"00_PecordNavigation-total down.png"] forState:UIControlStateSelected];
    [allDataButton setImage:[UIImage imageNamed:@"00_PecordNavigation-total down.png"] forState:UIControlStateHighlighted];
    
    UIButton *pecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pecordButton setFrame:CGRectMake(pWidth(207), pHeight(2), pWidth(72), pHeight(58))];
    [pecordButton setImage:[UIImage imageNamed:@"00_PecordNavigation-probability up.png"] forState:UIControlStateNormal];
    [pecordButton setImage:[UIImage imageNamed:@"00_PecordNavigation-probability down.png"] forState:UIControlStateSelected];
    [pecordButton setImage:[UIImage imageNamed:@"00_PecordNavigation-probability down.png"] forState:UIControlStateHighlighted];
    
    [rankButton addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [allDataButton addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [pecordButton addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    rankButton.tag = ((rowNum+1)*10+1);
    allDataButton.tag = ((rowNum+1)*10+2);
    pecordButton.tag = ((rowNum+1)*10+3);
    
    currentImageView.userInteractionEnabled = YES;
    [currentImageView addSubview:rankButton];
    [currentImageView addSubview:allDataButton];
    [currentImageView addSubview:pecordButton];
//    NSLog(@"button tag 1: %li ,2: %li ,3: %li",rankButton.tag,allDataButton.tag,pecordButton.tag);
    return currentImageView;
}
-(void)cellButtonAction:(UIButton *)sender
{
    sender.selected = YES;
    int buttonNum = ((int)sender.tag-((int)sender.tag/10)*10);
    int dbType = (int)sender.tag/10;
    [self makeBallSetWithPlayType:dbType];
    [self makePresentDataWithDBType:dbType AndButtonNum:buttonNum WithButton:sender
     ];
//    NSLog(@"button DATA dbType: %i, buttonNum: %i",dbType,buttonNum);
}
-(void)makePresentDataWithDBType:(int)dbType AndButtonNum:(int)buttonNum WithButton:(UIButton *)sender
{
    //找出符合條件的資料
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@",[NSString stringWithFormat:@"%i",dbType]];
    //然後依照時間排序
    NSSortDescriptor *timeDescriptors =[[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO selector:@selector(compare:)];
    NSArray * descriptors = [NSArray arrayWithObjects:timeDescriptors, nil];
    NSArray *matchArray = [[SortTable MR_findAllWithPredicate:predicate] sortedArrayUsingDescriptors:descriptors];
    
//    NSArray *matchArray = [SortTable MR_findAll];
    //裝箱打包要傳給SortListView
    NSMutableArray *sortListArray = [[NSMutableArray alloc] init];
    for (SortTable *currentSortTable in matchArray)
    {
        NSDate *matchDate = currentSortTable.timeStamp;
        NSData *matchImageData = currentSortTable.image;
        NSDictionary *matchDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:currentSortTable.sortDict];
        NSDictionary *matchAllDataArray = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:currentSortTable.allDataDict];
        NSNumber *numOfPlayCount = [NSNumber numberWithInteger:[matchAllDataArray count]];
        if (buttonNum==1)
        {//排名
            //1.時間 2.圖片 3.附帶資料 4.是否顯示金黃色
            [sortListArray addObject:[NSMutableArray arrayWithObjects:matchDate,matchImageData,matchDictionary,numOfPlayCount,@"NO", nil]];
        }else if (buttonNum ==2)
        {//總體
            [sortListArray addObject:[NSMutableArray arrayWithObjects:matchDate,matchImageData,matchAllDataArray,numOfPlayCount,@"NO", nil]];
        }else
        {//機率
            [sortListArray addObject:[NSMutableArray arrayWithObjects:matchDate,numOfPlayCount,matchDictionary,@"NO", nil]];
        }
    }
    if (buttonNum!=3)
    {
        sortListViewController.playType = [NSString stringWithFormat:@"%i",dbType];
        sortListViewController.detailType = [NSString stringWithFormat:@"%i",buttonNum];
        sortListViewController.allDataArray = sortListArray;
        [self presentViewController:sortListViewController animated:YES completion:^
         {
             sender.selected = NO;
         }];
    }else
    {
        sortAndAllDataListViewController.playType = [NSString stringWithFormat:@"%i",dbType];
        sortAndAllDataListViewController.detailType = [NSString stringWithFormat:@"%i",buttonNum];
        sortAndAllDataListViewController.allDataArrayFromSuperView = sortListArray;
        [self presentViewController:sortAndAllDataListViewController animated:YES completion:^
         {
             sender.selected = NO;
         }];
    }

//    NSLog(@"sortListArray :%@",sortListArray);
}
-(void)setUpThreeViewController
{
    if (sortListViewController == nil)
    {
        sortListViewController = [[SortListViewController alloc] init];
        sortListViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        sortListViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    if (sortAndAllDataListViewController == nil)
    {
        sortAndAllDataListViewController = [[SortAndAllDataDetailViewcontroller alloc] init];
        sortAndAllDataListViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        sortAndAllDataListViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}
-(void)makeBallSetWithPlayType:(int)currentPlayType
{
    int wouldChangeBallNum = 0;
    switch (currentPlayType)
    {
        case DBTYPE_STAR_3:
            wouldChangeBallNum = THREE_BALL_COUNT;
            break;
        case DBTYPE_STAR_4:
            wouldChangeBallNum = FOUR_BALL_COUNT;
            break;
        case DBTYPE_BIG_LOTTO:
            wouldChangeBallNum = SIX_BALL_COUNT;
            break;
        case DBTYPE_WEI_LI:
            wouldChangeBallNum = SIX_BALL_COUNT;
            break;
        case DBTYPE_FIVE_THREE_NINE:
            wouldChangeBallNum = FIVE_BALL_COUNT;
            break;
        case DBTYPE_BINGO:
            wouldChangeBallNum = NINE_BALL_COUNT;
            break;
        case DBTYPE_THREE_NINE:
            wouldChangeBallNum = FOUR_BALL_COUNT;
            break;
        case DBTYPE_THREE_EIGHT:
            wouldChangeBallNum = FIVE_BALL_COUNT;
            break;
        case DBTYPE_FOUR_NINE:
            wouldChangeBallNum = FOUR_BALL_COUNT;
            break;
        default:
            break;
    }
    [DEFAULTS setObject:[NSNumber numberWithInt:wouldChangeBallNum] forKey:@"AnalysisCellBallCount"];
    [DEFAULTS synchronize];
}
- (void)didChangeStatusBarFrame:(NSNotification*)notification
{
    NSValue*statusBarFrameValue = [notification.userInfo valueForKey:UIApplicationStatusBarFrameUserInfoKey];
    CGRect statusBarFrame =[statusBarFrameValue CGRectValue];
    barHeight = statusBarFrame.size.height;
    CGRect mainViewRect = mainBackImageView.frame;
    CGRect frameViewRect = frameImageView.frame;
    CGRect pecordTableViewFrame = pecordTableView.frame;
    mainViewRect.size.height = SCREEN_HEIGHT-statusBarHeight;
    frameViewRect.size.height = SCREEN_HEIGHT-statusBarHeight-dressingView.frame.size.height;
    pecordTableViewFrame.size.height = SCREEN_HEIGHT-(26+statusBarHeight);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
     {
        [mainBackImageView setFrame:mainViewRect];
        [frameImageView setFrame:frameViewRect];
        [pecordTableView setFrame:pecordTableViewFrame];
    } completion:^(BOOL finished)
     {
        
    }];
}
@end
