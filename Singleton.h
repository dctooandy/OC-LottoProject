//
//  Singleton.h
//  Lotto
//
//  Created by brownie on 2014/1/27.
//  Copyright (c) 2014年 brownieBBK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject
+ (id)sharedInstance;
@property (nonatomic, retain) NSUserDefaults* defaults;
-(void)fadeInWithView:(UIView *)currentView;
-(void)fadeOutWithView:(UIView *)currentView;
-(void)saveDataWithCompletionBlock:(void (^)(BOOL success))completionBlock
                    WithServerData:(NSArray *)recordArray;
@end
