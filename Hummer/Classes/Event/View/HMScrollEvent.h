//
//  HMScrollEvent.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMBaseEvent.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HMScrollEventState) {
    HMScrollEventNormal     = 0,
    HMScrollEventBegan      = 1,
    HMScrollEventScroll     = 2,
    HMScrollEventEnded      = 3,
};

FOUNDATION_EXTERN NSString * const kHMScrollState;
FOUNDATION_EXTERN NSString * const kHMScrollDeltaX;
FOUNDATION_EXTERN NSString * const kHMScrollDeltaY;

@interface HMScrollEvent : HMBaseEvent

@end

NS_ASSUME_NONNULL_END
