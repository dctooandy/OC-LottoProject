//
//  PecordNavigationViewcontroller.h
//  Lotto
//
//  Created by brownie on 2014/1/28.
//  Copyright (c) 2014年 brownieBBK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
@interface PecordNavigationViewcontroller : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UITableView *pecordTableView;
@end
