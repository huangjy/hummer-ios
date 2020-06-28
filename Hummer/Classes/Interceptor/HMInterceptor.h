//
//  HMInterceptor.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMNetworkProtocol.h"
#import "HMWebImageProtocol.h"
#import "HMReporterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

#define HM_EXPORT_INTERCEPTOR(name) \
__attribute__((used, section("__DATA , hm_interceptor"))) \
static char *__hm_export_interceptor_##name##__ = ""#name"";

@interface HMInterceptor : NSObject

+ (instancetype)sharedInstance;

- (void)loadExportInterceptor;

- (NSArray *)interceptorsWithProtocol:(Protocol *)proto;

#define Interceptor(proto) [[HMInterceptor sharedInstance] interceptorsWithProtocol:proto]

@end

NS_ASSUME_NONNULL_END
