//
//  HMConfigure.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMConfigure.h"

@implementation HMConfigure

static HMConfigure *__sharedInstance = nil;

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

- (instancetype)init
{
    self = [super init];
    if(self){
        _deviceWidth = 750.0f;
        _calRatio = [UIScreen mainScreen].bounds.size.width / 750.0f;
        _deviceHeight = [UIScreen mainScreen].bounds.size.height * _calRatio;
        _rootDir = [NSBundle mainBundle].bundlePath;
        _orientation = [UIDevice currentDevice].orientation;
    }
    return self;
}
@end
