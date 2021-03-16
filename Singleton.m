//
//  Singleton.m
//  Lotto
//
//  Created by brownie on 2014/1/27.
//  Copyright (c) 2014年 brownieBBK. All rights reserved.
//

#import "Singleton.h"
#import "Constant.h"

@implementation Singleton
@synthesize defaults;
static Singleton *sharedInstance = nil;
+(Singleton *)sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[super alloc] init];
        [sharedInstance initialization];
    }
    return sharedInstance;
}
-(void) initialization
{
     defaults = [NSUserDefaults standardUserDefaults];
}
-(void)fadeInWithView:(UIView *)currentView
{
    [UIView animateWithDuration:0.5 animations:^
    {
        currentView.alpha = 1.0;
    }];
}
-(void)fadeOutWithView:(UIView *)currentView
{
    [UIView animateWithDuration:0.5 animations:^
     {
         currentView.alpha = 0.0;
     }];
}
-(void)saveDataWithCompletionBlock:(void (^)(BOOL success))completionBlock
                    WithServerData:(NSArray *)recordArray
{
    NSString *currentType = [recordArray objectAtIndex:0];
    NSDictionary *sortDict = [recordArray objectAtIndex:1];
    NSDictionary *allDataDict = [recordArray objectAtIndex:2];
    UIImage *currentShop = [recordArray objectAtIndex:3];
    NSDate *currentDate = [self getLocaleSystemDateTime];
    
    SortTable *newSortTable = [SortTable MR_createEntity];

    newSortTable.type = currentType;
    newSortTable.timeStamp = currentDate;
    newSortTable.image = UIImagePNGRepresentation(currentShop);
    newSortTable.sortDict = [NSKeyedArchiver archivedDataWithRootObject:sortDict];
    newSortTable.allDataDict = [NSKeyedArchiver archivedDataWithRootObject:allDataDict];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error)
     {
         if (success)
         {
             completionBlock(YES);
         }
     }];
}
-(NSDate *)getLocaleSystemDateTime
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    return localeDate;
}
@end
