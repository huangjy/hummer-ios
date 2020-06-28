//
//  HMInterceptor.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMInterceptor.h"
#import <dlfcn.h>
#import <mach-o/getsect.h>

@interface HMInterceptor()
@property (nonatomic, strong) NSMutableDictionary *listMap;
@property (nonatomic, strong) NSMutableArray *protoArray;
@end

@implementation HMInterceptor

#pragma mark - Initialize

static HMInterceptor *__sharedInstance = nil;
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

#pragma mark - Getter & Setter

- (NSMutableArray *)protoArray
{
    if(!_protoArray){
        _protoArray = [NSMutableArray array];
        [_protoArray addObject:@protocol(HMWebImageProtocol)];
        [_protoArray addObject:@protocol(HMReporterProtocol)];
        [_protoArray addObject:@protocol(HMNetworkProtocol)];
    }
    return _protoArray;
}


- (NSMutableDictionary *)listMap
{
    if(!_listMap){
        _listMap = [NSMutableDictionary dictionary];
    }
    return _listMap;
}

#pragma mark - Private Method

- (void)registerInterceptorClass:(Class)clazz
{
    for(Protocol *proto in self.protoArray){
        if([clazz conformsToProtocol:proto]){
            NSString *name = NSStringFromProtocol(proto);
            NSMutableArray *array = self.listMap[name];
            if(!array){
                array = [NSMutableArray array];
                self.listMap[name] = array;
            }
            [array addObject:[clazz new]];
        }
    }
}

#pragma mark - Public Method

- (void)loadExportInterceptor {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Dl_info info;
        dladdr(&__sharedInstance, &info);
        
#ifndef __LP64__
        const struct mach_header *mhp = (struct mach_header*)info.dli_fbase;
        unsigned long size = 0;
        uint32_t *memory = (uint32_t*)getsectiondata(mhp, "__DATA", "hm_interceptor", & size);
#else /* defined(__LP64__) */
        const struct mach_header_64 *mhp = (struct mach_header_64*)info.dli_fbase;
        unsigned long size = 0;
        uint64_t *memory = (uint64_t*)getsectiondata(mhp, "__DATA", "hm_interceptor", & size);
#endif /* defined(__LP64__) */
        
        for(int idx = 0; idx < size/sizeof(void*); ++idx){
            char *string = (char*)memory[idx];
            NSString *clazz = [NSString stringWithUTF8String:string];
            [self registerInterceptorClass:NSClassFromString(clazz)];
        }
    });
}

- (NSArray *)interceptorsWithProtocol:(Protocol *)proto
{
    NSString *name = NSStringFromProtocol(proto);
    NSMutableArray *array = self.listMap[name];
    return [array copy];
}

@end
