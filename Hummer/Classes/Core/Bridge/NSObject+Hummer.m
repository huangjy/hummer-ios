//
//  NSObject+Hummer.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "NSObject+Hummer.h"
#import <objc/runtime.h>
#import "HMGlobalObject.h"
#import "HMJSContext.h"

@implementation NSObject (Hummer)

@dynamic jsContext;

HM_EXPORT_METHOD(setContainer, setJsValue:)

- (instancetype)initWithValues:(__unused NSArray *)values {
    self = [self init];
    return self;
}

- (void)callJSFinalize {
    JSValue *finalize = [self.jsValue valueForKey:@"finalize"];
    [finalize callWithArguments:nil];
}

#pragma mark - Getter & Setter

- (JSContext *)jsContext {
    id (^block)(void) = objc_getAssociatedObject(self, _cmd);
    return (block ? block() : nil);
}

- (void)setJsContext:(JSContext *)jsContext
{
    __weak typeof(jsContext) weakValue = jsContext;
    id (^block)(void) = ^(){ return weakValue;};
    objc_setAssociatedObject(self, @selector(jsContext), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (JSValue *)jsValue {
    id (^block)(void) = objc_getAssociatedObject(self, _cmd);
    return (block ? block() : nil);
}

#pragma mark - Export Method

- (void)setJsValue:(JSValue *)value {
    [(HMJSContext *)self.jsContext retainedValue:value];
    
    __weak typeof(value) weakValue = value;
    id (^block)(void) = ^(){ return weakValue;};
    objc_setAssociatedObject(self, @selector(jsValue), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


@end
