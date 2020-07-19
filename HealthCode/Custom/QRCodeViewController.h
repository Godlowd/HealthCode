//
//  QRCodeViewController.h
//  HealthCode
//
//  Created by New on 2020/7/14.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "SuccessView.h"
NS_ASSUME_NONNULL_BEGIN
  
@interface QRCodeViewController : UIViewController
@property(nonatomic, strong) UIImageView *qrcodeview;
@property(nonatomic, strong) UIView *timerView;
@property(nonatomic, strong) UserInfo *userInfo;
@property(nonatomic, strong) UILabel *updateTime;
//RSA public key
@property(nonatomic, copy) NSString *public_key;
//generate specific color's QRCode
@property(nonatomic, strong) UIButton *greenBtn;
@property(nonatomic, strong) UIButton *redBtn;
@property(nonatomic, strong) UIButton *yellowBtn;
//create QRCode successfully
@property(nonatomic, strong) SuccessView *success;
//frosted glass view
@property(nonatomic, strong) UIVisualEffectView *visualView;
//Timer
@property(nonatomic, strong) NSTimer *QRCodeTimer;
@property(nonatomic, strong) NSTimer *LabelTimer;
@end

NS_ASSUME_NONNULL_END
