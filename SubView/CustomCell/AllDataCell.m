//
//  AllDataCell.m
//  Lotto
//
//  Created by brownie on 2014/1/31.
//  Copyright (c) 2014年 brownieBBK. All rights reserved.
//

#import "AllDataCell.h"
#import "Constant.h"

@implementation AllDataCell
{
    int ballCount;
}
@synthesize backGroundImageView;
@synthesize numLabel,lineImageView;
@synthesize sortNoLabel;
@synthesize singleBallView;
@synthesize underRedImage;
@synthesize rightRedImage;
@synthesize pecordLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setFrame:CGRectMake(4, 0, SCREEN_WIDTH - 8, 64)];
        ballCount = 0;
        [self howManyBallShouldInitWithID:reuseIdentifier];
        [self setUpUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(void)setUpUI
{
    if (backGroundImageView == nil)
    {
        backGroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
        backGroundImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:backGroundImageView];
    }
    if (lineImageView == nil)
    {
        lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, self.frame.size.width, 4)];
        lineImageView.image = [UIImage imageNamed:@"00_DataAnalysis-total's baseline.png"];
        [backGroundImageView addSubview:lineImageView];
    }
    if (numLabel == nil)
    {
        numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 40, 30)];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.textColor = [UIColor yellowColor];
        numLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:20.0];
        numLabel.backgroundColor = [UIColor clearColor];
        [backGroundImageView addSubview:numLabel];
    }
    

    //名次
    if (sortNoLabel == nil)
    {
        sortNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(pWidth(33), 23, 27, 20)];
        sortNoLabel.textAlignment = NSTextAlignmentCenter;
        sortNoLabel.textColor = [UIColor whiteColor];
        sortNoLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
        sortNoLabel.backgroundColor = [UIColor clearColor];
        [backGroundImageView addSubview:sortNoLabel];
    }
    //在大球底下的紅標
    if (underRedImage == nil)
    {
        underRedImage = [[UIImageView alloc] initWithFrame:CGRectMake(pWidth(102),17, 98, 34)];
        underRedImage.backgroundColor = [UIColor clearColor];
        [backGroundImageView addSubview:underRedImage];
    }
    //右邊的紅標
    if (rightRedImage == nil)
    {
        rightRedImage = [[UIImageView alloc] initWithFrame:CGRectMake(pWidth(190),17, 32, 34)];
        rightRedImage.backgroundColor = [UIColor clearColor];
        [backGroundImageView addSubview:rightRedImage];
    }
    //紅標上面的機率Label
    pecordLabel = [[UILabel alloc] initWithFrame:CGRectMake(pWidth(135), 17, 75, 30)];
    pecordLabel.textAlignment = NSTextAlignmentCenter;
    pecordLabel.textColor = [UIColor blackColor];
    pecordLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    pecordLabel.backgroundColor = [UIColor clearColor];
    //test
    pecordLabel.text = @"9/999";
    [backGroundImageView addSubview:pecordLabel];

    //大球
    if (singleBallView == nil)
    {
        singleBallView = [[UIImageView alloc] initWithFrame:CGRectMake(pWidth(65), 0, 65, 65)];
        singleBallView.backgroundColor = [UIColor clearColor];
        [backGroundImageView addSubview:singleBallView];
    }
    [self makeBallCountSet];
}
-(void)makeBallCountSet
{
    int ballHeight = 0;
    int ballY = 0;
    int ballSpace = 0;
    if (ballCount<9)
    {
        ballHeight = ((SCREEN_WIDTH-40)/ballCount)>65?65:((SCREEN_WIDTH-40)/ballCount);
        ballY = ballHeight>65?0:65-ballHeight;
        ballSpace = ((SCREEN_WIDTH-40)-(ballCount*ballHeight))/(ballCount-1);

    }else
    {
        ballHeight = ((SCREEN_WIDTH)/ballCount)>65?65:((SCREEN_WIDTH)/ballCount);
        ballHeight>65?(ballHeight = 65):ballHeight;
        ballY = ballHeight>65?0:65-ballHeight;
        ballSpace = ((SCREEN_WIDTH-60)-(ballCount*ballHeight))/(ballCount-1);

    }
    for (int i = 0; i<ballCount; i++)
    {
        UIImageView *ballImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40 +(ballHeight-3)*i+(ballSpace-(6-ballCount))*i, ballY, ballHeight, ballHeight)];
        ballImageView.tag = i+1;
        [backGroundImageView addSubview:ballImageView];
    }
}
-(void)howManyBallShouldInitWithID:(NSString *)idString
{
    if ([idString isEqualToString:@"DBTYPE_STAR_3"])
    {
        ballCount = THREE_BALL_COUNT;
    }else if ([idString isEqualToString:@"DBTYPE_STAR_4"])
    {
        ballCount = FOUR_BALL_COUNT;
    }else if ([idString isEqualToString:@"DBTYPE_BIG_LOTTO"])
    {
        ballCount = SIX_BALL_COUNT;
    }else if ([idString isEqualToString:@"DBTYPE_WEI_LI"])
    {
        ballCount = SIX_BALL_COUNT;
    }else if ([idString isEqualToString:@"DBTYPE_FIVE_THREE_NINE"])
    {
        ballCount = FIVE_BALL_COUNT;
    }else if ([idString isEqualToString:@"DBTYPE_BINGO"])
    {
        ballCount = NINE_BALL_COUNT;
    }else if ([idString isEqualToString:@"DBTYPE_THREE_NINE"])
    {
        ballCount = FOUR_BALL_COUNT;
    }else if ([idString isEqualToString:@"DBTYPE_THREE_EIGHT"])
    {
        ballCount = FIVE_BALL_COUNT;
    }else if ([idString isEqualToString:@"DBTYPE_FOUR_NINE"])
    {
        ballCount = FOUR_BALL_COUNT;
    }
}
@end
