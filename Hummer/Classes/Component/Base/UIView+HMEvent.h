//
//  UIView+HMEvent.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface UIGestureRecognizer(Hummer)

@property (nonatomic, copy) NSString *hm_eventName;

@end

@interface UIView(HMEvent)

@property (nonatomic, strong, readonly) NSMutableDictionary *hm_eventTable;

- (void)hm_notifyEvent:(NSString *)eventName
             withValue:(JSValue *)value
          withArgument:(id)argument;

- (void)hm_addEvent:(JSValue *)eventName
       withListener:(JSValue *)listener;

- (void)hm_removeEvent:(JSValue *)eventName
          withListener:(JSValue *)listener;

@end
