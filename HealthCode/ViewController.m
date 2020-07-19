//
//  ViewController.m
//  HealthCode
//
//  Created by New on 2020/7/14.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>
#import "QRCodeViewController.h"
#import "GuardViewController.h"
#import <Masonry.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    _custom = [UIButton buttonWithType:UIButtonTypeCustom];
    _custom.frame = CGRectMake(0, 0, 50, 30);
    [_custom setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [_custom setTitle:@"用户端" forState:UIControlStateNormal];
    [self.view addSubview:_custom];
    [_custom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(100);
    }];
    [_custom addTarget:self action:@selector(loadCustomViewController) forControlEvents:UIControlEventTouchUpInside];
    
    _guard = [UIButton buttonWithType:UIButtonTypeCustom];
    [_guard setTitle:@"门禁端" forState:UIControlStateNormal];
    _guard.frame = CGRectMake(0, 0, 50, 30);
    [_guard setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.view addSubview:_guard];
    [_guard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_custom.mas_bottom).with.offset(50);
    }];
    [_guard addTarget:self action:@selector(loadGuardViewController) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

-(void)loadCustomViewController{
    QRCodeViewController *controller = QRCodeViewController.new;
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void)loadGuardViewController{
    GuardViewController *controller = GuardViewController.new;
    [self.navigationController pushViewController:controller animated:YES];
    
}
// 生成二维码



@end
