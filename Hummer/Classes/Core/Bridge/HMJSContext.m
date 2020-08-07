//
//  HMJSContext.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//


#import "HMJSContext.h"
#import "HMExportManager.h"
#import "HMAttrManager.h"
#import "HMExportClass.h"
#import "HMUtility.h"
#import "HMClassManager.h"
#import "HMExportMethod.h"
#import "HMJSClassDef.h"
#import "HMBuiltinScript.h"
#import "HMJSObject.h"
#import "HMGlobalObject.h"
#import "JSValue+Hummer.h"
#import "NSObject+Hummer.h"
#import <objc/runtime.h>
#import "HMInterceptor.h"
#import "HMGlobalObject.h"

#if DEBUG
JS_EXPORT void JSSynchronousGarbageCollectForDebugging(JSContextRef ctx);
#endif

@interface HMJSContext()
@property (nonatomic, strong) NSMutableArray <JSManagedValue *> *ownedJSValues;
@end

@implementation HMJSContext

- (void)dealloc {
    /// JSGarbageCollect should not synchronously call collectAllGarbage(). Instead, it should notify the GCActivityCallback
    /// that it has abandoned an object graph, which will set the timer to run at some point in the future that JSC can decide
    /// according to its own policies.
    [self releaseAllValues];
    
#if DEBUG
    JSSynchronousGarbageCollectForDebugging(self.JSGlobalContextRef);
#endif
    
    JSGarbageCollect(self.JSGlobalContextRef);
    HMLogDebug(@"HMJSContext [%@] dealloc", [self description]);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _ownedJSValues = [[NSMutableArray alloc] init];
        [self setupJSContext];
    }
    return self;
}

- (void)setupJSContext {
    self[@"Hummer"] = [HMGlobalObject globalObject];
    [self setupJSLogger];
    [self setupJSClasses];
    NSString *script = [HMGlobalObject globalObject].globalScript;
    [self evaluateScript:script fileName:@"hummer.js"];
}

- (void)setupJSLogger {
    NSDictionary *info = @{@(HMLogLevelDebug)   : @"log",
                           @(HMLogLevelInfo)    : @"info",
                           @(HMLogLevelWarning) : @"warn",
                           @(HMLogLevelError)   : @"error",
                           @(HMLogLevelTrace)   : @"trace"};
    for (NSNumber *level in info.allKeys) {
        self[@"console"][info[level]] = ^(){
            NSArray *args = [JSContext currentArguments];
            NSMutableString *string = [NSMutableString string];
            for (JSValue *value in args) {
                [string appendString:[value toString]];
            }
            _HMLog([level integerValue], [args description]);
        };
    }
    
    __weak typeof(self) weakSelf = self;
    self.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [weakSelf reportException:exception];
    };
}

- (void)setupJSClasses {
    HMExportManager *manager = [HMExportManager sharedInstance];
    NSArray *jsClasses = [manager allExportJSClasses];
    
    for (NSString *jsClass in jsClasses) {
        __weak typeof(self) weakSelf = self;
        NSString *className = [NSString stringWithFormat:@"NATIVE_%@", jsClass];
        self[className] = ^() {
            return [weakSelf JSObjectForClass:jsClass forContext:[JSContext currentContext]];
        };
    }
}

- (NSException *)exceptionWithJSValue:(JSValue *)exception
{
    NSString *stackString = [[exception objectForKeyedSubscript:@"stack"] toString];
    NSNumber *line = [[exception objectForKeyedSubscript:@"line"] toNumber];
    NSNumber *column = [[exception objectForKeyedSubscript:@"column"] toNumber];
    NSString *description = [exception description];
    NSDictionary *userInfo = @{@"stack": stackString,
                               @"line": line,
                               @"column": column,
                               @"description": description
    };
    return [[NSException alloc] initWithName:@"YoukuScript" reason:@"JSException" userInfo:userInfo];
}

- (void)reportException:(JSValue *)exception {
    NSArray *interceptors = Interceptor(@protocol(HMReporterProtocol));
    if (interceptors.count > 0) {
        for (id <HMReporterProtocol> interceptor in interceptors) {
            if ([interceptor respondsToSelector:@selector(catchException:)]) {
                [interceptor catchException:[self exceptionWithJSValue:exception]];
            }
        }
    } else {
        HMLogError(@"%@", [[self exceptionWithJSValue:exception] description]);
    }
}

- (JSValue *)JSObjectForClass:(NSString *)className forContext:(JSContext *)context {
    if (!className || !context) return nil;

    JSContextRef contextRef = [[JSContext currentContext] JSGlobalContextRef];
    
    HMExportClass *exportClass = [[HMExportManager sharedInstance] exportClassForJS:className];
    HMJSClassDef *jsClass = [[HMClassManager defaultManager] createJSClass:className];
    
    Class clazz = NSClassFromString(exportClass.className);
    if (!clazz || ![clazz conformsToProtocol:@protocol(HMJSObject)]) {
        HMLogError(@"Export class [%@] can not be found", exportClass.className);
        return [JSValue valueWithJSValueRef:JSValueMakeUndefined(contextRef) inContext:context];
    }
    
    NSObject *OCObject = [[clazz alloc] initWithValues:[JSContext currentArguments]];
    OCObject.jsContext = context;
    
    JSObjectRef objectRef = JSObjectMake(contextRef, [jsClass classRef], (__bridge void *)(OCObject));
    return [JSValue valueWithJSValueRef:objectRef inContext:context];
}

- (JSValue *)evaluateScript:(NSString *)jsScript fileName:(NSString *)fileName {
    jsScript = [jsScript stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!jsScript) return nil;
    if (!fileName) {
        static NSInteger fileIndex = 0; fileIndex++;
        fileName = [NSMutableString stringWithFormat:@"Hummer%ld", (long)fileIndex];
    }
    NSURL *sourceURL = [[NSURL alloc] initWithString:fileName];
    return [self evaluateScript:jsScript withSourceURL:sourceURL];
}

- (void)retainedValue:(JSValue *)value {
    if (value) {
        JSManagedValue *managedValue = [JSManagedValue managedValueWithValue:value];
        [self.virtualMachine addManagedReference:managedValue withOwner:self];
        [self.ownedJSValues addObject:managedValue];
    }
}

- (void)releaseAllValues {
    @autoreleasepool {
        NSArray<JSManagedValue *> *allValues = self.ownedJSValues.copy;
        for (NSInteger index = 0; index < allValues.count; index++) {
            JSValue *value = [allValues[index] value];
            [[value toObjCObject] callJSFinalize];
            [self.virtualMachine removeManagedReference:allValues[index] withOwner:self];
        }
        [self.ownedJSValues removeAllObjects];
    }
}

@end
