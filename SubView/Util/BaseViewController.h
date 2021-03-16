//
//  BaseViewController.h
//  Lotto180320
//
//  Created by AndyChen on 2020/7/30.
//  Copyright © 2020 AndyChen. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
{
    NSMutableArray *numArray;
    NSMutableArray *countArray;
    UIImageView *mainBackImageView;
    UIImageView *dressingView;
    UIImageView *frameImageView;
    UIImageView *currentNumberImageView;
    UIButton *backButton;
    UIButton *clearDataButton;
    UIButton *mailToButton;
    UILabel *countLabel;
}
-(void)backToMainView:(UIButton *)sender;
-(void)resetNumArray:( int )sender;
-(void)setUI;
-(void)setNumberInNumImageView:(int)sender;
-(void)mailToUser:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
