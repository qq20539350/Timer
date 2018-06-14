//
//  YTWeakTimer.h
//  eyutong
//
//  Created by YT_lwf on 2018/5/5.
//  Copyright © 2018年 Zhengzhou Yutong Bus Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTWeakTimer : NSObject

- (id)initWithTimeInterval:(NSTimeInterval)timeInterval
                    target:(id)target
                  selector:(SEL)selector
                  userInfo:(id)userInfo
                   repeats:(BOOL)repeats
             dispatchQueue:(dispatch_queue_t)dispatchQueue;


+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                        target:(id)target
                                      selector:(SEL)selector
                                      userInfo:(id)userInfo
                                       repeats:(BOOL)repeats
                                 dispatchQueue:(dispatch_queue_t)dispatchQueue;

- (void)schedule;

- (void)suspend;

- (void)resume;

- (void)invalidate;

@end
