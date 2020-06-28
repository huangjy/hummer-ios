//
//  HMClassManager.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMClassManager.h"
#import "HMJSClassDef.h"
#import "HMUtility.h"

@interface HMClassManager ()

@property (nonatomic, strong) NSMutableDictionary *jsClasses;
@property (nonatomic, strong) NSLock *jsClassLock;

@end

@implementation HMClassManager

static HMClassManager *__sharedManager = nil;

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (__sharedManager == nil) {
            __sharedManager = [[self alloc] init];
        }
    });
    return __sharedManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized(self) {
        if (__sharedManager == nil) {
            __sharedManager = [super allocWithZone:zone];
        }
    }
    return __sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _jsClasses = [NSMutableDictionary dictionary];
        _jsClassLock = [NSLock new];
    }
    return self;
}

- (HMJSClassDef *)createJSClass:(NSString *)className {
    if (!className) {
        HMLogError(@"JS class name can not be null!");
        return nil;
    }
    
    HMJSClassDef *jsClass = [self jsClassWithName:className];
    if (jsClass) return jsClass;
    
    jsClass = [[HMJSClassDef alloc] initWithJSClass:className];
    if (jsClass && className) {
        [self setJSClass:jsClass withName:className];
    }
    [jsClass registerJSClassRef];
    
    return jsClass;
}

- (void)jsClassLockWithBlock:(dispatch_block_t)block {
    [self.jsClassLock lock];
    if (block) block();
    [self.jsClassLock unlock];
}

- (HMJSClassDef *)jsClassWithName:(NSString *)className {
    if (!className) return nil;
    
    __block HMJSClassDef *jsClass = nil;
    __weak typeof(self) weakSelf = self;
    [self jsClassLockWithBlock:^{
        jsClass = weakSelf.jsClasses[className];
    }];
    
    return jsClass;
}

- (void)setJSClass:(HMJSClassDef *)jsClass withName:(NSString *)className {
    if (!jsClass || !className) return;
    
    __weak typeof(self) weakSelf = self;
    [self jsClassLockWithBlock:^{
        weakSelf.jsClasses[className] = jsClass;
    }];
}

@end
