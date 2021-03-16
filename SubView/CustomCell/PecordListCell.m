//
//  PecordListCell.m
//  Lotto
//
//  Created by brownie on 2014/2/2.
//  Copyright (c) 2014年 brownieBBK. All rights reserved.
//

#import "PecordListCell.h"
#import "Constant.h"
@implementation PecordListCell
@synthesize backGroundImageView;
@synthesize numLabel;
@synthesize dateLabel;
@synthesize deleteCellButton;
@synthesize currentDataImage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        [self setUpUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setUpUI
{
    if (backGroundImageView == nil)
    {
        backGroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
        backGroundImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:backGroundImageView];
    }
    if (numLabel == nil)
    {
        numLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 18, 40, 30)];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.textColor = [UIColor yellowColor];
        numLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:15.0];
        numLabel.backgroundColor = [UIColor clearColor];
        [backGroundImageView addSubview:numLabel];
    }
    if (deleteCellButton == nil)
    {
        deleteCellButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteCellButton setFrame:CGRectMake(5, 11, 40, 42)];
        [deleteCellButton setImage:[UIImage imageNamed:@"00_PecordNavigation-X up.png"] forState:UIControlStateNormal];
        [deleteCellButton setImage:[UIImage imageNamed:@"00_PecordNavigation-X down.png"] forState:UIControlStateHighlighted];
        [deleteCellButton setImage:[UIImage imageNamed:@"00_PecordNavigation-X down.png"] forState:UIControlStateSelected];
        deleteCellButton.hidden = YES;
        [backGroundImageView addSubview:deleteCellButton];
    }
    if (currentDataImage == nil)
    {
        currentDataImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxY(deleteCellButton.frame), 2, 50, 60)];
        currentDataImage.backgroundColor = [UIColor clearColor];
        [backGroundImageView addSubview:currentDataImage];
    }
    if (dateLabel == nil)
    {
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentDataImage.frame.size.width+deleteCellButton.frame.size.width+25, 0, 150, 65)];
        dateLabel.numberOfLines = 2;
        dateLabel.textAlignment = NSTextAlignmentLeft;
        dateLabel.textColor = [UIColor blackColor];
        dateLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:25.0];
        dateLabel.backgroundColor = [UIColor clearColor];
        [backGroundImageView addSubview:dateLabel];

    }
}
@end
