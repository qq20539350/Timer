//
//  AsynTimer.m
//  link
//
//  Created by YT_lwf on 2018/3/26.
//  Copyright © 2018年 Zhengzhou Yutong Bus Co.,Ltd. All rights reserved.
//

#import "AsynTimer.h"

@interface AsynTimer(){
    SEL  _selector;
}

@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) NSPort *port;
@property(nonatomic, assign) NSTimeInterval interval;
@property(nonatomic, strong) id target;

@end

@implementation AsynTimer

- (instancetype)initWithTimerTarget:(id)obj select:(SEL)selector TimeInterval:(NSTimeInterval) interval{
    self = [super init];
    if (selector) {
        self.status = TimerNoUse;
        _selector = selector;
        if (!_selector) {
            _selector = @selector(test);
        }
        _interval = interval;
        if (!_interval || _interval == 0) {
            _interval = 10;
        }
        if (obj) {
            _target = obj;
        }else{
            _target = self;
        }
    }
    return self;
}

- (void)dealloc{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        self.status = TimerNoUse;
    }
    if (self.port) {
        [[NSRunLoop currentRunLoop] removePort:self.port forMode:NSDefaultRunLoopMode];
    }
    if (self.thread) {
        self.thread = nil;
    }
}

#pragma mark --- Public

- (void)start {
    NSThread * thread = [NSThread currentThread];
    if (thread.name && [thread.name isEqualToString:self.threadName]) {
        if (self.status != TimerStart) {
            [self.timer fire];
            self.status = TimerStart;
        }
    }else{
        [self performSelector:@selector(start) onThread:self.thread withObject:nil waitUntilDone:NO];
    }
}

- (void)suspend{
    [self.timer setFireDate:[NSDate distantFuture]];
    self.status = TimerSuspended;
}

- (void)stop{
    if (self.timer) {
        self.status = TimerNoUse;
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.port) {
        [[NSRunLoop currentRunLoop] removePort:self.port forMode:NSDefaultRunLoopMode];
    }
    if (self.thread) {
        self.thread = nil;
    }
}

#pragma mark --- Private

- (void)runTimer{
    @autoreleasepool {
        [[NSRunLoop currentRunLoop] addPort:self.port forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }
}

- (void)test {
    
}

#pragma mark --- Get

- (NSThread *)thread{
    if (!_thread) {
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(runTimer) object:nil];
        _thread.name = @"timerThread";
        self.threadName = @"timerThread";
        [_thread start];
    }
    return _thread;
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self.target selector:_selector userInfo:nil repeats:YES];
        self.status = TimerNoUse;
    }
    return _timer;
}

- (NSPort *)port{
    if (!_port) {
        _port = [[NSPort alloc] init];
    }
    return _port;
}

#pragma mark --- Set

- (void)setThreadName:(NSString *)threadName{
    if (threadName &&  threadName.length > 0) {
        _threadName = threadName;
        self.thread.name = _threadName;
    }
}

@end
