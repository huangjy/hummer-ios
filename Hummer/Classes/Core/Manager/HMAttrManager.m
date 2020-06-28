//
//  HMAttrManager.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMAttrManager.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>

@implementation HMViewAttribute

- (instancetype)initWithProperty:(NSString *)viewProp
                         cssAttr:(NSString *)cssAttr
                       converter:(SEL)converter {
    self = [super init];
    if (self) {
        _viewProp = viewProp;
        _cssAttr = cssAttr;
        _converter = converter;
    }
    return self;
}

+ (instancetype)viewAttrWithName:(NSString *)viewProp
                         cssAttr:(NSString *)cssAttr
                       converter:(SEL)converter {
    return [[self alloc] initWithProperty:viewProp
                                  cssAttr:cssAttr
                                converter:converter];
}

@end

@interface HMAttrManager()

@property (nonatomic, strong) NSMutableDictionary *attrs;

@end

@implementation HMAttrManager

static HMAttrManager * __sharedInstance = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (__sharedInstance == nil) {
            __sharedInstance = [[self alloc] init];
        }
    });
    return __sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized(self) {
        if (__sharedInstance == nil) {
            __sharedInstance = [super allocWithZone:zone];
        }
    }
    return __sharedInstance;
}

- (NSMutableDictionary *)attrs {
    if (!_attrs) {
        _attrs = [NSMutableDictionary dictionary];
    }
    return _attrs;
}

- (NSDictionary *)viewAttrsForClass:(Class)clazz
{
    if(!clazz || ![clazz isSubclassOfClass:[UIView class]])
        return nil;
    
    NSString *clsName = NSStringFromClass(clazz);
    NSMutableDictionary *dict = self.attrs[clsName];
    if(!dict){
        dict = [NSMutableDictionary dictionary];
        self.attrs[clsName] = dict;
        [self loadAllAttrWithClass:clazz toDict:dict];
    }
    return dict;
}

- (void)loadAllAttrWithClass:(Class)cls toDict:(NSMutableDictionary *)dict {
    if(!dict) return;
    
    if (cls != [UIView class]) {
        Class superCls = class_getSuperclass(cls);
        [self loadAllAttrWithClass:superCls toDict:dict];
    }
    [self addViewAttrForClass:cls toDict:dict];
}

- (void)addViewAttrForClass:(Class)clazz toDict:(NSMutableDictionary *)dict{
    if (!clazz || ![clazz isSubclassOfClass:[UIView class]]) return;
    
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList(object_getClass(clazz), &outCount);
    for (NSInteger idx = 0; idx < outCount; idx++) {
        SEL selector = method_getName(methods[idx]);
        NSString *methodName = NSStringFromSelector(selector);
        if ([methodName hasPrefix:@"__hm_view_attribute_"] &&
            [clazz respondsToSelector:selector]) {
            HMViewAttribute *object = ((HMViewAttribute*(*)(id, SEL))objc_msgSend)(clazz, selector);
            if (object && object.cssAttr) dict[object.cssAttr] = object;
        }
    }
    if (methods) free(methods);
}
@end
