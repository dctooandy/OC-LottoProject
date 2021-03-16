//
//  SortTable.h
//  Lotto
//
//  Created by brownie on 2014/2/2.
//  Copyright (c) 2014年 brownieBBK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SortTable : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSData * sortDict;
@property (nonatomic, retain) NSData * allDataDict;

@end
