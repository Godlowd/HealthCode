//
//  ResultViewController.h
//  HealthCode
//
//  Created by New on 2020/7/16.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "SuccessView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ResultViewController : UIViewController
@property(nonatomic, strong) UserInfo *info;
@property(nonatomic, strong) UILabel *name;
@property(nonatomic, strong) UILabel *IdentityId;
@property(nonatomic, strong) UILabel *color;
@property(nonatomic, strong) UILabel *updateTime;
@property(nonatomic, strong) UILabel *whetherPermit;
@property(nonatomic, strong) SuccessView *confirmView;
@property(nonatomic, strong) UIImageView *checkView;
@property(nonatomic, strong) UIView *labelView;

@end

NS_ASSUME_NONNULL_END
