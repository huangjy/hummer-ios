//
//  HMGlobalObject.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMGlobalObject.h"
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "HMExportManager.h"
#import "HMExportClass.h"
#import "HMExportMethod.h"
#import "JSValue+Hummer.h"
#import "HMInvocation.h"
#import "HMUtility.h"
#import "UIView+Yoga.h"
#import "HMJSObject.h"
#import "NSObject+Hummer.h"
#import "HMBuiltinScript.h"


@interface HMGlobalObject ()

@property (nonatomic, strong) NSMapTable *contextGraph;
@property (nonatomic, strong) NSDictionary *envParams;

@end

@implementation HMGlobalObject

@synthesize globalScript = _globalScript;

static HMGlobalObject *__globalObject = nil;
+ (instancetype)globalObject {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (__globalObject == nil) {
            __globalObject = [[self alloc] init];
        }
    });
    return __globalObject;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized(self) {
        if (__globalObject == nil) {
            __globalObject = [super allocWithZone:zone];
        }
    }
    return __globalObject;
}

#pragma mark - Getter & Setter

- (NSDictionary *)envParams {
    if (!_envParams) {
        _envParams = [self localEnv];
    }
    return _envParams;
}

- (NSString *)globalScript
{
    if(!_globalScript){
        _globalScript = [self baseScript];
    }
    return _globalScript;
}

- (NSMapTable *)contextGraph
{
    if(!_contextGraph){
        _contextGraph = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsWeakMemory capacity:4];
    }
    return _contextGraph;
}

#pragma mark - Private Method

- (NSDictionary *)localEnv {
    NSString *platform = @"iOS";
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion] ?: @"";
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] ?: @"";
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] ?: @"";
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat deviceWidth = MIN(screenWidth, screenHeight);
    NSString *widthString = [NSString stringWithFormat:@"%.0fdp", deviceWidth];
    CGFloat deviceHeight = MAX(screenWidth, screenHeight);
    NSString *heightString = [NSString stringWithFormat:@"%.0fdp", deviceHeight];
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    NSString *availableHeightString = [NSString stringWithFormat:@"%.0fdp", deviceHeight-statusBarHeight];
    CGFloat scale = [[UIScreen mainScreen] scale];
    return @{@"platform": platform,
             @"osVersion": sysVersion,
             @"appName": appName,
             @"appVersion": appVersion,
             @"deviceWidth": widthString,
             @"deviceHeight": heightString,
             @"availableWidth": widthString,
             @"availableHeight": availableHeightString,
             @"scale": @(scale)};
}

- (NSMutableDictionary *)allClassesMethods:(NSArray *)jsClasses {
    NSMutableDictionary *classMethods = [NSMutableDictionary dictionary];
    for (NSString *jsClass in jsClasses) {
        NSMutableArray *staticMethods = classMethods[jsClass];
        if (!staticMethods) {
            staticMethods = [NSMutableArray array];
            classMethods[jsClass] = staticMethods;
        }
        HMExportClass *export = [[HMExportManager sharedInstance] exportClassForJS:jsClass];
        NSArray *methods = [export allExportMethodList];
        for (NSString *methodName in methods) {
            HMExportMethod *method = [export methodForFuncName:methodName];
            if (method.methodType == HMClassMethod) {
                [staticMethods addObject:method.funcName];
            }
        }
    }
    return classMethods;
}

- (NSString *)baseScript {
    NSMutableString *jsScript = [NSMutableString string];
    [jsScript appendFormat:@"%@\n", HMBuiltinBaseJSScript];
    
    HMExportManager *manager = [HMExportManager sharedInstance];
    NSArray *jsClasses = [manager allExportJSClasses];
    
    NSMutableDictionary *classMethods = [NSMutableDictionary dictionary];
    for (NSString *jsClass in jsClasses) {
        NSMutableArray *staticMethods = classMethods[jsClass];
        if (!staticMethods) {
            staticMethods = [NSMutableArray array];
            classMethods[jsClass] = staticMethods;
        }
        HMExportClass *export = [[HMExportManager sharedInstance] exportClassForJS:jsClass];
        NSArray *methods = [export allExportMethodList];
        for (NSString *methodName in methods) {
            HMExportMethod *method = [export methodForFuncName:methodName];
            if (method.methodType == HMClassMethod) {
                [staticMethods addObject:method.funcName];
            }
        }
    }
    [jsScript appendFormat:@"HMJSUtility.initGlobalEnv(%@);\n", HMJSONEncode(classMethods)];
    
    return jsScript;
}

#pragma mark - Public Method

- (void)addEnvParams:(NSDictionary *)params {
    if (!params) return;
    
    NSMutableDictionary *env = [self.env mutableCopy];
    [env addEntriesFromDictionary:params];
    self.envParams = env;
}

- (void)addGlobalScript:(NSString *)script
{
    NSMutableString *string = [self.globalScript mutableCopy];
    [string appendString:script];
    _globalScript = string;
}

- (void)weakReference:(UIView *)rootView context:(JSContext *)context
{
    if(!rootView || !context) return;
    
    [self.contextGraph setObject:rootView forKey:context];
}

- (NSDictionary *)env
{
    return self.envParams;
}

#pragma mark - HMGlobalExport

- (void)render:(JSValue *)page {
    UIView *view = [page toObjCObject];
    UIView *rootView = [self.contextGraph objectForKey:page.context];
    if(!view || ![view isKindOfClass:[UIView class]]){
        HMAssert(NO, @"page must be a view kind class!");
        return;
    }
    [rootView addSubview:view];
    
    [rootView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.alignContent = YGAlignCenter;
        layout.alignItems = YGAlignCenter;
        layout.justifyContent = YGJustifyCenter;
    }];
    [rootView.yoga applyLayoutPreservingOrigin:NO];
}

- (JSValue *)callFunc:(JSValue *)cls method:(JSValue *)method arguments:(JSValue *)arguments {
    NSString *jsClass = [cls toObjCObject]; NSString *funcName = [method toObjCObject];
    
    HMExportClass *exportClass = [[HMExportManager sharedInstance] exportClassForJS:jsClass];
    Class target = NSClassFromString(exportClass.className);
    HMExportMethod *exportMethod = [exportClass methodForFuncName:funcName];
    if (!target || !exportMethod.selector) {
        HMLogError(@"Objective-c class [%@] can't response sel [%@]", target,exportMethod.selector);
        return nil;
    }
    JSContext *context= cls.context;
    NSUInteger argsCount = [arguments toArray].count;
    NSMutableArray *mArgs = NSMutableArray.new;
    for (NSUInteger index = 0; index < argsCount; index++) {
        [mArgs addObject:[arguments valueAtIndex:index]];
    }
    HMInvocation *executor = [[HMInvocation alloc] initWithTarget:target];
    [executor setSelecor:exportMethod.selector];
    [executor setArguments:mArgs.copy];
    id retValue = [executor invokeAndReturn];
    if ([retValue isKindOfClass:[JSValue class]]) { return (JSValue *)retValue; }
    return [JSValue valueWithObject:retValue inContext:context];
}
@end
