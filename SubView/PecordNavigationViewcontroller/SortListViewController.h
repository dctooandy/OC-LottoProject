//
//  SortListViewController.h
//  Lotto
//
//  Created by brownie on 2014/2/2.
//  Copyright (c) 2014年 brownieBBK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
@interface SortListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSString *playType;
@property (nonatomic,strong)NSString *detailType;
@property (nonatomic,strong)NSMutableArray *allDataArray;
@end
