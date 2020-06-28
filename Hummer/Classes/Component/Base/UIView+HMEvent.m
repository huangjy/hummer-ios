//
//  UIView+HMEvent.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "UIView+HMEvent.h"
#import "JSValue+Hummer.h"
#import <objc/runtime.h>
#import "HMExportManager.h"
#import "NSObject+Hummer.h"
#import "HMUtility.h"
#import "HMTapEvent.h"
#import "HMSwipeEvent.h"
#import "HMPinchEvent.h"
#import "HMPanEvent.h"
#import "HMLongPressEvent.h"

@implementation UIGestureRecognizer(Hummer)

- (NSString *)hm_eventName {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHm_eventName:(NSString *)hm_eventName {
    objc_setAssociatedObject(self,
                             @selector(hm_eventName),
                             hm_eventName,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UIView(HMEvent)

HM_EXPORT_METHOD(addEventListener, hm_addEvent:withListener:)
HM_EXPORT_METHOD(removeEventListener, hm_removeEvent:withListener:)

- (NSMutableDictionary *)hm_eventTable {
    NSMutableDictionary *eventTable = objc_getAssociatedObject(self, _cmd);
    if(!eventTable){
        eventTable = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, eventTable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return eventTable;
}

- (NSMutableDictionary *)hm_eventGestureTable {
    NSMutableDictionary *eventGestureTable = objc_getAssociatedObject(self, _cmd);
    if(!eventGestureTable){
        eventGestureTable = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, eventGestureTable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return eventGestureTable;
}

- (BOOL)hm_isGestureEventName:(NSString *)eventName {
    return ([eventName isEqualToString:HMTapEventName] ||
            [eventName isEqualToString:HMLongPressEventName] ||
            [eventName isEqualToString:HMSwipeEventName] ||
            [eventName isEqualToString:HMPinchEventName] ||
            [eventName isEqualToString:HMPanEventName]);
}

- (__unsafe_unretained Class)hm_eventClassWithGesture:(UIGestureRecognizer *)gesture {
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        return [HMTapEvent class];
    } else if ([gesture isKindOfClass:[UISwipeGestureRecognizer class]]) {
        return [HMSwipeEvent class];
    } else if ([gesture isKindOfClass:[UIPinchGestureRecognizer class]]) {
        return [HMPinchEvent class];
    } else if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
        return [HMPanEvent class];
    } else if ([gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return [HMLongPressEvent class];
    }
    
    return [HMBaseEvent class];
}

- (__unsafe_unretained Class)hm_gestureClassForEvent:(NSString *)eventName {
    if ([eventName isEqualToString:HMTapEventName]) {
        return [UITapGestureRecognizer class];
    } else if ([eventName isEqualToString:HMLongPressEventName]) {
        return [UILongPressGestureRecognizer class];
    } else if ([eventName isEqualToString:HMSwipeEventName]) {
        return [UISwipeGestureRecognizer class];
    } else if ([eventName isEqualToString:HMPinchEventName]) {
        return [UIPinchGestureRecognizer class];
    } else if ([eventName isEqualToString:HMPanEventName]) {
        return [UIPanGestureRecognizer class];
    }
    
    HMAssert(NO, @"event:[%@] is not a gesture", eventName);
    return nil;
}

- (void)hm_onEventGesture:(UIGestureRecognizer *)gesture {
    Class objcClass = [self hm_eventClassWithGesture:gesture];
    JSValue *eventVal = [JSValue valueWithClass:objcClass inContext:self.jsContext];
    
    HMBaseEvent *eventObj = [eventVal toObjCObject];
    [eventObj updateEvent:self withContext:gesture];
    
    if (gesture.hm_eventName) {
        NSMutableArray *callbacks = [self hm_gestureCallbacksForEvent:gesture.hm_eventName];
        
        for (int i = 0; i < callbacks.count; i++) {
            JSManagedValue *listener = callbacks[i];
            [listener.value callWithArguments:@[eventVal]];
        }
    }
}

- (NSMutableArray *)hm_gestureCallbacksForEvent:(NSString *)eventName {
    if (!eventName) return nil;
    NSMutableArray *gestureCallbacks = [self.hm_eventTable objectForKey:eventName];
    if (!gestureCallbacks) {
        gestureCallbacks = [[NSMutableArray alloc] init];
        [self.hm_eventTable setObject:gestureCallbacks forKey:eventName];
    }
    return gestureCallbacks;
}

- (NSMutableArray *)hm_gestureRecognizersForEvent:(NSString *)eventName {
    if (!eventName) return nil;
    NSMutableArray *gestureRecognizers = [self.hm_eventGestureTable objectForKey:eventName];
    if (!gestureRecognizers) {
        gestureRecognizers = [[NSMutableArray alloc] init];
        [self.hm_eventGestureTable setObject:gestureRecognizers forKey:eventName];
    }
    return gestureRecognizers;
}

- (NSMutableArray *)hm_listenerArrayForEvent:(NSString *)eventName {
    if (!eventName) return nil;
    NSMutableArray *array = [self.hm_eventTable objectForKey:eventName];
    if (!array) {
        array = [NSMutableArray array];
        [self.hm_eventTable setObject:array forKey:eventName];
    }
    return array;
}

- (void)hm_notifyEvent:(NSString *)eventName
             withValue:(JSValue *)value
          withArgument:(id)argument {
    if (!eventName) return;
    
    HMBaseEvent *eventObj = [value toObjCObject];
    [eventObj updateEvent:self withContext:argument];
    
    BOOL isNotGestureEvent = ![self hm_isGestureEventName:eventName];
    NSAssert(isNotGestureEvent, @"gesture event should not notify via this methods");
    if (!isNotGestureEvent) {
        return;
    }
    
    NSMutableArray *array = [self hm_listenerArrayForEvent:eventName];
    for (JSValue *listener in array) {
        [listener callWithArguments:(argument ? @[argument] : @[])];
    }
}

#pragma mark - Export Method

- (void)hm_addEvent:(JSValue *)eventName withListener:(JSValue *)listener {
    if (!eventName || !listener) return;
    
    NSString *nameStr = [eventName toString];
    if ([self hm_isGestureEventName:nameStr]) {
        Class clazz = [self hm_gestureClassForEvent:nameStr];
        if (!clazz) return;
        
        if ([clazz isEqual:[UISwipeGestureRecognizer class]]) {
            NSArray *directions = @[@(UISwipeGestureRecognizerDirectionRight),
                                    @(UISwipeGestureRecognizerDirectionLeft),
                                    @(UISwipeGestureRecognizerDirectionUp),
                                    @(UISwipeGestureRecognizerDirectionDown),];
            for (NSInteger i = 0; i < directions.count; i++) {
                UISwipeGestureRecognizerDirection direction = [directions[i] integerValue];
                UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(hm_onEventGesture:)];
                swipe.direction = direction;
                swipe.hm_eventName = nameStr;
                [self addGestureRecognizer:swipe];
                
                NSMutableArray *recognizers = [self hm_gestureRecognizersForEvent:nameStr];
                [recognizers addObject:swipe];
            }
        } else {
            UIGestureRecognizer *gesture = [[clazz alloc] initWithTarget:self
                                                                  action:@selector(hm_onEventGesture:)];
            gesture.hm_eventName  = nameStr;
            [self addGestureRecognizer:gesture];
            
            NSMutableArray *recognizers = [self hm_gestureRecognizersForEvent:nameStr];
            [recognizers addObject:gesture];
        }
        
        NSMutableArray *callbacks = [self hm_gestureCallbacksForEvent:nameStr];
        JSManagedValue *callback = [JSManagedValue managedValueWithValue:listener];
        [self.jsContext.virtualMachine addManagedReference:callback withOwner:callbacks];
        [callbacks addObject:callback];
    } else {
        NSMutableArray *array = [self hm_listenerArrayForEvent:nameStr];
        [array addObject:listener];
    }
}

- (void)hm_removeEvent:(JSValue *)eventName withListener:(JSValue *)listener {
    if (!eventName) return;
    
    NSString *nameStr = [eventName toString];
    if ([self hm_isGestureEventName:nameStr]) {
        NSMutableArray *callbacks = [self hm_gestureCallbacksForEvent:nameStr];
        NSUInteger index = NSNotFound;
        for (int i = 0; i < callbacks.count; i++) {
            JSManagedValue *callback = callbacks[i];
            if ([listener isEqual:callback.value]) {
                index = i;
                break;
            }
        }
        
        if (index != NSNotFound) {
            [callbacks removeObjectAtIndex:index];
        }
        
        if (callbacks.count == 0) {
            [self.hm_eventTable removeObjectForKey:nameStr];
            NSMutableArray *recognizers = [self hm_gestureRecognizersForEvent:nameStr];
            [recognizers enumerateObjectsUsingBlock:^(UIGestureRecognizer * _Nonnull obj,
                                                      NSUInteger idx,
                                                      BOOL * _Nonnull stop) {
                [self removeGestureRecognizer:obj];
            }];
            [self.hm_eventGestureTable removeObjectForKey:nameStr];
        }
    } else {
        if (listener) {
            NSMutableArray *array = [self hm_listenerArrayForEvent:nameStr];
            [array removeObject:listener];
        } else {
            [self.hm_eventTable removeObjectForKey:eventName];
        }
    }
}

@end
