//
//  HMReporterProtocol.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, HMLogLevel) {
    HMLogLevelDebug,
    HMLogLevelInfo,
    HMLogLevelWarning,
    HMLogLevelError,
    HMLogLevelTrace,
};

typedef NS_ENUM(NSInteger, HMPerformanceTag) {
    HummerEngineInit,
};

@protocol HMReporterProtocol <NSObject>
@optional

- (void)logLevel:(HMLogLevel)logLevel message:(NSString *)message;

- (void)catchException:(NSException *)exception;

- (void)calculatePerfomance:(NSDictionary *)performance;

@end

NS_ASSUME_NONNULL_END
