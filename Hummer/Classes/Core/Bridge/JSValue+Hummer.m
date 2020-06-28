//
//  JSValue+Hummer.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMExportManager.h"
#import "HMUtility.h"
#import "HMExportClass.h"
#import "HMClassManager.h"
#import "HMJSObject.h"
#import "HMJSClassDef.h"
#import <objc/message.h>

@implementation JSValue(Hummer)

- (id)toObjCObject {
    JSContextRef contextRef = self.context.JSGlobalContextRef;
    if ([self isObject]) {
        JSObjectRef objectRef = JSValueToObject(contextRef, self.JSValueRef, NULL);
        JSStringRef propertyRef = JSStringCreateWithUTF8CString("private");
        JSValueRef privateRef = JSObjectGetProperty(contextRef, objectRef, propertyRef, NULL);
        JSValue *value = [JSValue valueWithJSValueRef:privateRef inContext:self.context];
        BOOL isUndefined = [value isUndefined];
        if (!isUndefined) {
            JSObjectRef valueToObjc = JSValueToObject(contextRef, privateRef, NULL);
            if (valueToObjc) {
                return (__bridge id)JSObjectGetPrivate(valueToObjc);
            }
        }
    }
    return [self toObject];
}

+ (instancetype)valueWithClass:(Class)objcClass inContext:(JSContext *)context {
    if (!objcClass || !context) return nil;
    
    NSString *classStr = NSStringFromClass(objcClass);
    HMExportClass *exportClass = [[HMExportManager sharedInstance] exportClassForObjC:classStr];
    if (!exportClass || !exportClass.jsClass) {
        HMAssert(NO, @"class:[%@] has not been exported!", NSStringFromClass(objcClass));
        return nil;
    }
    return [context evaluateScript:[NSString stringWithFormat:@"new %@()", exportClass.jsClass]];
}

@end
