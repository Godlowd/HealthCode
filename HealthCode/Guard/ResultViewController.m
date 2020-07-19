//
//  ResultViewController.m
//  HealthCode
//
//  Created by New on 2020/7/16.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import "ResultViewController.h"
#import <Masonry.h>
#import "SuccessView.h"
#define UPDATETIME 30
@interface ResultViewController ()

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;

    
    _whetherPermit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    if ([_info.color isEqualToString:@"green"]) {
        _confirmView = [[SuccessView alloc] initWithFrame:CGRectMake(0,0,70,70) withState:YES];
        [self.view addSubview:_confirmView];
        [_confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(self.view.bounds.size.width/2 - _confirmView.bounds.size.width/2);
            make.top.equalTo(self.view.mas_top).with.offset(200);
        }];
        _whetherPermit.text = @"允许通行";
    }
    else{
        _confirmView = [[SuccessView alloc] initWithFrame:CGRectMake(0,0,70,70) withState:NO];
        [self.view addSubview:_confirmView];
        [_confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
              make.left.equalTo(self.view.mas_left).with.offset(self.view.bounds.size.width/2 - _confirmView.bounds.size.width/2);
              make.top.equalTo(self.view.mas_top).with.offset(200);
          }];
        _whetherPermit.text = @"禁止通行";
    }

    [self.view addSubview:_whetherPermit];
    _whetherPermit.font = [UIFont systemFontOfSize:30];
    [_whetherPermit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.confirmView.mas_bottom).with.offset(80);
    }];
    
    [self setUpLabel];
    
//    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.labelView.center= self.view.center;
//    } completion:nil];
   
}
-(void)viewWillAppear:(BOOL)animated{

}
- (void)setUpLabel{
    
    _labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 80)];
    [self.view addSubview:_labelView];
    [_labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(150);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    _name.text = [@"姓名: " stringByAppendingString:_info.name];
    _name.font = [UIFont systemFontOfSize:18];
    [_labelView addSubview:_name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_labelView.mas_left).with.offset(40);
        make.top.equalTo(_labelView.mas_top).with.offset(200);
    }];
    
    _IdentityId = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    _IdentityId.text = [@"Id: "stringByAppendingString:_info.IdentityId];
    _IdentityId.font = [UIFont systemFontOfSize:18];
    [_labelView addSubview:_IdentityId];
    [_IdentityId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_labelView.mas_left).with.offset(40);
        make.top.equalTo(self.name.mas_bottom).with.offset(20);
    }];
    
    _updateTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSLog(@"the udpate time is %@",_info.updateTime);
    NSDate *validate = [NSDate dateWithTimeInterval:UPDATETIME sinceDate:_info.updateTime];
    //NSDate转NSString
    NSString *validDateString = [dateFormatter stringFromDate:validate];
    _updateTime.text = [@"有效期截止: " stringByAppendingString:validDateString];
    _updateTime.font = [UIFont systemFontOfSize:18];
    [_labelView addSubview:_updateTime];
    [_updateTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_labelView.mas_left).with.offset(40);
        make.top.equalTo(self.IdentityId.mas_bottom).with.offset(20);
    }];
}


@end
