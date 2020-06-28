//
//  HMJSContext.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//


#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>

@interface HMJSContext : JSContext
/**
 * 强持JSValue，防止js对象被GC了
 * @param jsScript 脚本字符串
 * @param fileName 脚本文件名
 * @return 返回结果
 */
- (JSValue *)evaluateScript:(NSString *)jsScript fileName:(NSString *)fileName;

/**
 * 强持JSValue，防止js对象被GC了
 * @param value JSValue
 */
- (void)retainedValue:(JSValue *)value;

@end
