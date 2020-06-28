//
//  HMInputEvent.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMBaseEvent.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HMInputEventState){
    HMInputEventNormal      = 0,
    HMInputEventBegan       = 1,
    HMInputEventChanged     = 2,
    HMInputEventEnded       = 3,
};

FOUNDATION_EXTERN NSString * const kHMInputState;
FOUNDATION_EXTERN NSString * const kHMInputText;

@interface HMInputEvent : HMBaseEvent

@end

NS_ASSUME_NONNULL_END
