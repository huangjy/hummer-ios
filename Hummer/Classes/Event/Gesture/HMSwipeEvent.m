//
//  HMSwipeEvent.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMSwipeEvent.h"
#import "HMExportManager.h"
#import "NSObject+Hummer.h"
#import "HMUtility.h"

@interface HMSwipeEvent()

@property (nonatomic, assign) UISwipeGestureRecognizerDirection direction;
@property (nonatomic, strong) UISwipeGestureRecognizer *gesture;

@end

@implementation HMSwipeEvent

HM_EXPORT_CLASS(SwipeEvent, HMSwipeEvent)

HM_EXPORT_PROPERTY(direction, __direction, __setDirection:)
HM_EXPORT_PROPERTY(state, __state, __setState:)

- (NSString *)type {
    return HMSwipeEventName;
}

- (void)updateEvent:(UIView *)view withContext:(id)context {
    [super updateEvent:view withContext:context];
    UISwipeGestureRecognizer *gesture = (UISwipeGestureRecognizer *)context;
    self.gesture = (UISwipeGestureRecognizer *)context;
    self.direction = gesture.direction;
}

#pragma mark - Export Method

- (JSValue *)__direction {
    return [JSValue valueWithUInt32:(uint32_t)self.direction inContext:self.jsContext];
}

- (void)__setDirection:(__unused JSValue *)direction {
    NSAssert(NO, @"cannot set read only property");
}

- (JSValue *)__state {
    return [JSValue valueWithObject:@(self.gesture.state) inContext:self.jsContext];
}

- (void)__setState:(__unused JSValue *)state {
    NSAssert(NO, @"cannot set read only property");
}

@end
