//
//  GuardViewController.h
//  HealthCode
//
//  Created by New on 2020/7/16.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface GuardViewController : UIViewController
@property(nonatomic, strong) NSString *private_key;
@property(nonatomic, strong) NSString *detail;
@property(nonatomic, strong) UserInfo *info;
@end

NS_ASSUME_NONNULL_END
