//
//  HMPanEvent.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMPanEvent.h"
#import "HMExportManager.h"
#import "NSObject+Hummer.h"
#import "JSValue+Hummer.h"
#import "HMUtility.h"

@interface HMPanEvent()

@property (nonatomic, assign) CGPoint translation;
@property (nonatomic, strong) UIPanGestureRecognizer *gesture;

@end

@implementation HMPanEvent

HM_EXPORT_CLASS(PanEvent, HMPanEvent)

HM_EXPORT_PROPERTY(translation, __translation, __setTranslation:)
HM_EXPORT_PROPERTY(state, __state, __setState:)

- (NSString *)type {
    return HMPanEventName;
}

- (void)updateEvent:(UIView *)view withContext:(id)context {
    [super updateEvent:view withContext:context];
    self.gesture = (UIPanGestureRecognizer *)context;
    self.translation = [self.gesture translationInView:view];
}

#pragma mark - Export Method

- (JSValue *)__translation {
    NSDictionary *dict = @{@"deltaX": [NSString stringWithFormat:@"%.0fdp", self.translation.x],
                           @"deltaY": [NSString stringWithFormat:@"%.0fdp", self.translation.y]};
    return [JSValue valueWithObject:dict inContext:self.jsContext];
}

- (void)__setTranslation:(__unused JSValue *)translation {
    NSAssert(NO, @"cannot set read only property");
}

- (JSValue *)__state {
    return [JSValue valueWithObject:@(self.gesture.state) inContext:self.jsContext];
}

- (void)__setState:(__unused JSValue *)state {
    NSAssert(NO, @"cannot set read only property");
}

@end
