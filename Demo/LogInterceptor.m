//
//  LogInterceptor.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "LogInterceptor.h"
#import <Hummer/Hummer.h>

@interface LogInterceptor () <HMReporterProtocol>

@end

@implementation LogInterceptor

HM_EXPORT_INTERCEPTOR(LogInterceptor)

#pragma mark - HMLoggerProtocol

- (void)logLevel:(HMLogLevel)logLevel message:(NSString *)message
{
    NSLog(@"------ >> logInfo : %@", message);
}

#pragma mark - HMReporterProtocol

- (void)handleJSPerformanceWithKey:(NSString *)key info:(NSDictionary *)info {
    NSLog(@"------ >> performance : %@", info.description);
}

@end
