//
//  DotimeManage.h
//  BobySongs
//
//  Created by chuliangliang on 13-12-25.
//  Copyright (c) 2013年 banvon. All rights reserved.
//

#import <Foundation/Foundation.h>


@class DotimeManage;
@protocol DotimeManageDelegate <NSObject>

- (void)TimerActionValueChange:(int)time; //时间改变

@end

@interface DotimeManage : NSObject
{
    NSTimer *BBtimer;
}
@property (nonatomic)int timeValue;
@property (nonatomic,assign)id<DotimeManageDelegate> delegate;
+ (DotimeManage *)DefaultManage;

//开始计时
- (void)startTime;

//停止计时
- (void)stopTimer;
@end
