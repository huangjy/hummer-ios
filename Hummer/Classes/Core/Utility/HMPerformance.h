//
//  HMPerformance.h
//  Hummer
//
//  Copyright © 2019 huangjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMReporterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMPerformance : NSObject

+ (instancetype)sharedInstance;

- (void)measurePerfomance:(HMPerformanceTag)tag withBlock:(dispatch_block_t)block;

#define Measure(tag, block) [[HMPerformance sharedInstance] measurePerfomance:tag withBlock:block]

- (void)dumpPerformance;
@end

NS_ASSUME_NONNULL_END
