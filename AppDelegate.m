//
//  AppDelegate.m
//  Lotto
//
//  Created by brownie on 2014/1/27.
//  Copyright (c) 2014年 brownieBBK. All rights reserved.
//

#import "AppDelegate.h"
#import "Constant.h"
//#import <Crashlytics/Crashlytics.h>
@implementation AppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [Crashlytics startWithAPIKey:@"b491a2f94258baea302a607710344f38bc86f9d0"];
    [DEFAULTS setBool:YES forKey:@"IsFirstLaunch"];
    [DEFAULTS synchronize];
    [self getTwoAndFive];
    [application setApplicationIconBadgeNumber:0];    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //讓畫面淡入
    UIImageView *splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,  SCREEN_HEIGHT)];
    splashView.image = [UIImage imageNamed:@"logo_words.png"];
//    splashView.alpha = 0.0;
    [splashView setContentMode:UIViewContentModeScaleAspectFill];
    MainViewController *mainView = [[MainViewController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainView;
    mainView.view.alpha = 0.0;
    [self.window addSubview:splashView];
    [self.window bringSubviewToFront:splashView];
    
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^
    {
        splashView.alpha = 1.0;
        [self.window makeKeyAndVisible];

    } completion:^(BOOL finished)
    {
            UIImageView *bigRoundImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-pWidth(180), SCREEN_HEIGHT/2-pWidth(200), pWidth(360), pWidth(360))];
            bigRoundImage.image = [UIImage imageNamed:@"logo_circle2.png"];
            UIImageView *smallRoundImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-pWidth(150), SCREEN_HEIGHT/2-pWidth(171), pWidth(300), pWidth(300))];
            smallRoundImage.image = [UIImage imageNamed:@"logo_circle1.png"];
        [splashView addSubview:bigRoundImage];
        [splashView addSubview:smallRoundImage];
//            [self.window addSubview:bigRoundImage];
//            [self.window addSubview:smallRoundImage];
        
            [UIView animateWithDuration:5.0
                             animations:^
             {
                 bigRoundImage.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90));
                 smallRoundImage.transform = CGAffineTransformMakeRotation(M_PI);
             } completion:^(BOOL finished)
             {
                 if (finished)
                 {
                     [UIView animateWithDuration:1.5 animations:^
                      {
                          splashView.alpha = 0.0;
                          bigRoundImage.alpha = 0.0;
                          smallRoundImage.alpha = 0.0;
                          mainView.view.alpha = 1.0;
                      }];
                 }
             }];

    }];

    [MagicalRecord setupCoreDataStackWithStoreNamed:@"MyDatabase.sqlite"];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [DEFAULTS setBool:YES forKey:@"BackFromBack"];
    [DEFAULTS synchronize];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSNotificationCenter *nsc = [NSNotificationCenter defaultCenter];
    [nsc postNotificationName:@"AddADMODBanner" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [MagicalRecord cleanUp];
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Lotto" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Lotto.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame
{

    

}
-(void)getTwoAndFive
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSLog(@"today 的 interval %i",(int)interval);
    
    NSDate *today = [date  dateByAddingTimeInterval: interval];
    
    NSCalendar *gregorian;
    NSDateComponents *weekdayComponents;
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
    gregorian= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Get the weekday component of the current date

    weekdayComponents= [gregorian components:NSWeekdayCalendarUnit fromDate:today];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    gregorian= [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    // Get the weekday component of the current date
    
    weekdayComponents= [gregorian components:NSCalendarUnitWeekday fromDate:today];
#endif

    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 4)];
    
    NSDate *beginningOfWeekIsTwo = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
    NSDateComponents *componentsIsTwo;
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
    componentsIsTwo = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: beginningOfWeekIsTwo];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    componentsIsTwo = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: beginningOfWeekIsTwo];
#endif
    beginningOfWeekIsTwo = [gregorian dateFromComponents:componentsIsTwo];
    NSInteger TwoOftheWeekSecond = [beginningOfWeekIsTwo timeIntervalSinceNow]-[today timeIntervalSinceNow];
    NSLog(@"本星期的星期二是 %@",[beginningOfWeekIsTwo description]);
    
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 7)];
    
    NSDate *beginningOfWeekIsFive = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
    NSDateComponents *componentsIsFive;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
    componentsIsFive = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: beginningOfWeekIsFive];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    componentsIsFive = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: beginningOfWeekIsFive];
#endif

    
    beginningOfWeekIsFive = [gregorian dateFromComponents:componentsIsFive];
    NSInteger FiveOftheWeekSecond = [beginningOfWeekIsFive timeIntervalSinceNow]-[today timeIntervalSinceNow];
    NSLog(@"本星期的星期五是 %@",[beginningOfWeekIsFive description]);
    
    [componentsToSubtract setDay: 4 - ([weekdayComponents weekday] - 7)];
    
    NSDate *nextTwoOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
    
    NSDateComponents *componentsIsNextTwo;
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
    componentsIsNextTwo = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: nextTwoOfWeek];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    componentsIsNextTwo = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: nextTwoOfWeek];
#endif

    
    nextTwoOfWeek = [gregorian dateFromComponents:componentsIsNextTwo];
    NSInteger TwoOftheNextWeekSecond = [nextTwoOfWeek timeIntervalSinceNow]-[today timeIntervalSinceNow];
    NSLog(@"下星期的星期二是 %@",[nextTwoOfWeek description]);
    
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (TwoOftheWeekSecond>0)
    {
        NSLog(@"現在是本週星期二下午四點之前 %i 秒",(int)TwoOftheWeekSecond);
        /** 從現在開始多少秒後發出提醒 */
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:TwoOftheWeekSecond];
    }else if (FiveOftheWeekSecond>0)
    {
        NSLog(@"現在是本週星期五下午四點之前 %i 秒",(int)FiveOftheWeekSecond);
        /** 從現在開始多少秒後發出提醒 */
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:FiveOftheWeekSecond];
    }else
    {
        NSLog(@"距離下星期的星期二還有 %i 天, %i 小時, %i 分, %i 秒",
              (int)TwoOftheNextWeekSecond/(3600*24),
              (int)TwoOftheNextWeekSecond%(3600*24)/3600,
              (int)((TwoOftheNextWeekSecond%(3600*24)/60)%60),
              (int)(TwoOftheNextWeekSecond%(3600*24)%3600)%60);
        /** 從現在開始多少秒後發出提醒 */
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:TwoOftheNextWeekSecond];
    }
    /** 使用預設時區 */
    notification.timeZone = [NSTimeZone systemTimeZone];
    /** 使用系統預設鬧鈴聲 */
    notification.soundName = UILocalNotificationDefaultSoundName;
    /** 桌面icon右上角顯示提醒數量 */
    notification.applicationIconBadgeNumber = 1;
    /** 提醒內容文字 */
    notification.alertBody = @"今天有大樂透開獎喔,試試手氣吧";
    /** 確定按鈕內容，如果沒有指定，則不會進入APP */
    notification.alertAction = @"確定";
    /** 設定提醒後進入APP所帶回的內容 */
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"今天有大樂透開獎喔,試試手氣吧"
                                                         forKey:@"OpenBigLettoDay"];
    notification.userInfo = userDict;
    
    [[UIApplication sharedApplication]scheduleLocalNotification:notification];
}
@end
