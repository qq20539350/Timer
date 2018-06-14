//
//  AsynTimer.h
//  link
//
//  Created by YT_lwf on 2018/3/26.
//  Copyright © 2018年 Zhengzhou Yutong Bus Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,TimerStatus) {
    TimerNoUse,
    TimerStart,
    TimerSuspended
};

@interface AsynTimer : NSObject

@property(nonatomic, copy) NSString *threadName;
@property(nonatomic, assign) TimerStatus status;
@property(nonatomic, strong) NSThread *thread;

- (instancetype)initWithTimerTarget:(id)obj select:(SEL)selector TimeInterval:(NSTimeInterval) interval;

- (void)start;

- (void)stop;

@end
