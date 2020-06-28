//
//  HMPerformance.m
//  Hummer
//
//  Copyright © 2019 huangjy. All rights reserved.
//

#import "HMPerformance.h"
#import <QuartzCore/QuartzCore.h>

@interface HMPerformance()
@property (nonatomic, strong) NSMutableDictionary *perfDict;
@property (nonatomic, strong) NSRecursiveLock *perfLock;
@end

@implementation HMPerformance

static HMPerformance *__sharedInstance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(__sharedInstance == nil){
            __sharedInstance = [self new];
        }
    });
    return __sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized (self) {
        if(__sharedInstance == nil){
            __sharedInstance = [super allocWithZone:zone];
        }
    }
    return __sharedInstance;
}

- (NSMutableDictionary *)perfDict
{
    @synchronized (self) {
        if(_perfDict == nil)
            _perfDict = [NSMutableDictionary dictionary];
    }
    return _perfDict;
}

- (NSRecursiveLock *)perfLock
{
    @synchronized (self) {
        if(!_perfLock){
            _perfLock = [NSRecursiveLock new];
        }
    }
    return _perfLock;
}

- (void)addPerformance:(HMPerformanceTag)tag withDuration:(CFTimeInterval)duration
{
    [self.perfLock tryLock];
    [self.perfDict setObject:@(duration) forKey:@(tag)];
    [self.perfLock unlock];
}

- (void)measurePerfomance:(HMPerformanceTag)tag withBlock:(dispatch_block_t)block
{
    CFTimeInterval beginTime = CACurrentMediaTime() * 1000;
    if(block) block();
    CFTimeInterval endTime = CACurrentMediaTime() * 1000;
    [self addPerformance:tag withDuration:endTime - beginTime];
}

- (void)dumpPerformance
{
    
}
@end
