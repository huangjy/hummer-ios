//
//  HMJSObject.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@protocol HMJSObject <NSObject>
@required

/**
 * 初始化方法
 * @param values : 初始化参数
 * @return object对象
 */
- (instancetype)initWithValues:(NSArray *)values;

@optional

/**
 * 调用 JS Finalize 函数
 */
- (void)callJSFinalize;

/**
 * 复制方法（对象如果是 Native 创建，导出给前端使用的情况下，需要实现该方法）
 * @param object : 同类型对象
 */
- (void)copyFromObject:(id)object;

@end
