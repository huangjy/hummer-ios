//
//  HMExportManager.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    const char *jsClass;
    const char *objcClass;
} HMExportStruct;

#define HM_EXPORT_CLASS(jsClass, objcClass) \
__attribute__((used, section("__DATA , hm_export_class"))) \
static const HMExportStruct __hm_export_class_##jsClass##__ = {#jsClass, #objcClass};

#define HM_EXPORT_METHOD(jsMethod, sel) \
+ (NSArray *)__hm_export_method_##jsMethod##__ {\
    return @[@#jsMethod, NSStringFromSelector(@selector(sel))];\
}

#define HM_EXPORT_PROPERTY(jsProp, getter, setter) \
+ (NSArray *)__hm_export_property_##jsProp##__ {\
    return @[@#jsProp, NSStringFromSelector(@selector(getter)), NSStringFromSelector(@selector(setter))];\
}

typedef id (^HMFuncCallback)(NSArray *args);

@class HMExportClass;
@interface HMExportManager : NSObject
/**
 * 创建单例
 * @return 单例对象
 */
+ (instancetype)sharedInstance;
/**
 * 加载导出类
 */
- (void)loadExportClasses;
/**
 * 获取导出类描述
 * @param jsClass : JS 类名
 * @return 导出 JS 类描述
 */
- (HMExportClass *)exportClassForJS:(NSString *)jsClass;
/**
 * 获取导出 JS 类列表
 * @return 导出 JS 类列表
 */
- (NSArray *)allExportJSClasses;
/**
 * 获取导出类描述
 * @param objcClass : ObjC 类名
 * @return 导出类描述
 */
- (HMExportClass *)exportClassForObjC:(NSString *)objcClass;
/**
 * 获取导出 ObjC 类列表
 * @return 导出 ObjC 类列表
 */
- (NSArray *)allExportObjCClasses;
/**
 * ObjC 类对应的 JS 类
 * @param objcClass : ObjC 类名
 * @return JS 类名
 */
- (NSString *)jsClassForObjCClass:(Class)objcClass;

@end
