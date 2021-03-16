//
//  PecordListCell.h
//  Lotto
//
//  Created by brownie on 2014/2/2.
//  Copyright (c) 2014年 brownieBBK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PecordListCell : UITableViewCell
@property (nonatomic ,strong)UIImageView *backGroundImageView;
@property (nonatomic ,strong)UILabel *numLabel;
@property (nonatomic ,strong)UILabel *dateLabel;
@property (nonatomic ,strong)UIButton *deleteCellButton;
@property (nonatomic ,strong)UIImageView *currentDataImage;
@end
