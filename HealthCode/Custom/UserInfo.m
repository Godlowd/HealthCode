//
//  UserInfo.m
//  HealthCode
//
//  Created by New on 2020/7/15.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import "UserInfo.h"
#import <openssl/rsa.h>
#import <openssl/pem.h>
@implementation UserInfo
-(NSString *)generateOriginalInfo{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [dateFormatter stringFromDate:_updateTime];
    return [NSString stringWithFormat:@"%@/%@/%@/%@", _name,date,_IdentityId,_color];
}
-(NSString *)setcolor:(int)num{
    NSArray *array = @[@"green", @"red",@"blue"];
    NSLog(@"the num is %d",num);
    return array[num];
}
@end
