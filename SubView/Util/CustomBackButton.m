//
//  CustomBackButton.m
//  Lotto180320
//
//  Created by AndyChen on 2020/7/30.
//  Copyright © 2020 AndyChen. All rights reserved.
//

#import "CustomBackButton.h"

@implementation CustomBackButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}
- (void)setup
{
    [self setImage:[UIImage imageNamed:@"00_button-back main down.png"] forState:UIControlStateNormal ];
    [self setImage:[UIImage imageNamed:@"00_button-back main up.png"] forState:UIControlStateSelected];
    [self setImage:[UIImage imageNamed:@"00_button-back main up.png"] forState:UIControlStateHighlighted];
    [self setTag:1];
}
@end
