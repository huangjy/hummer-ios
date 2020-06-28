//
//  HMScrollEvent.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMScrollEvent.h"
#import "HMExportManager.h"
#import "JSValue+Hummer.h"
#import "NSObject+Hummer.h"

NSString * const kHMScrollState     = @"state";
NSString * const kHMScrollDeltaX    = @"deltaX";
NSString * const kHMScrollDeltaY    = @"deltaY";

@interface HMScrollEvent()
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) CGFloat deltaX;
@property (nonatomic, assign) CGFloat deltaY;
@end

@implementation HMScrollEvent

HM_EXPORT_CLASS(ScrollEvent, HMScrollEvent)

HM_EXPORT_PROPERTY(dx, __deltaX, __setDeltaX:)
HM_EXPORT_PROPERTY(dy, __deltaY, __setDeltaY:)
HM_EXPORT_PROPERTY(state, __state, __setState:)

- (void)updateEvent:(UIView *)view withContext:(id)context {
    NSDictionary *dict = (NSDictionary *)context;
    self.state = [dict[kHMScrollState] integerValue];
    self.deltaX = [dict[kHMScrollDeltaX] floatValue];
    self.deltaY = [dict[kHMScrollDeltaY] floatValue];
}

#pragma mark - Export Method

- (JSValue *)__state {
    return [JSValue valueWithObject:@(self.state) inContext:self.jsContext];
}

- (void)__setState:(__unused JSValue *)state {
    NSAssert(NO, @"cannot set read only property");
}

- (JSValue *)__deltaX {
    return [JSValue valueWithDouble:self.deltaX inContext:self.jsContext];
}

- (void)__setDeltaX:(__unused JSValue *)deltaX {
    NSAssert(NO, @"cannot set read only property");
}

- (JSValue *)__deltaY {
    return [JSValue valueWithDouble:self.deltaY inContext:self.jsContext];
}

- (void)__setDeltaY:(__unused JSValue *)deltaY {
    NSAssert(NO, @"cannot set read only property");
}

@end
