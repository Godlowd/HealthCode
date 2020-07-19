//
//  UserInfo.h
//  HealthCode
//
//  Created by New on 2020/7/15.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import <Foundation/Foundation.h>
   
NS_ASSUME_NONNULL_BEGIN

@interface UserInfo : NSObject
@property(nonatomic, strong) NSString *name;
@property int securitycheck;
@property NSDate *updateTime;
@property(nonatomic, strong) NSString *IdentityId;
@property NSString *color;

-(NSString *)generateOriginalInfo;
-(NSString *)setcolor:(int)num;
@end

NS_ASSUME_NONNULL_END
