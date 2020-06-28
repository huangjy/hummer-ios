//
//  Hummer.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMConfigure.h"
#import "HMJSContext.h"
#import "HMInterceptor.h"

NS_ASSUME_NONNULL_BEGIN

//! Project version number for Hummer.
FOUNDATION_EXPORT double HummerVersionNumber;
//! Project version string for Hummer.
FOUNDATION_EXPORT const unsigned char HummerVersionString[];

@interface Hummer : NSObject
/**
 * 初始化引擎
 * @param builder 配置设置函数
 */
+ (void)startEngine:(void (^ _Nullable)(HMConfigure *config))builder;
/**
 * 添加全局变量
 * @param envParams 全局变量
 */
+ (void)addEnvParams:(NSDictionary *)envParams;
/**
 * 添加全局脚本
 * @param script 全局脚本
 */
+ (void)addGlobalScript:(NSString *)script;

/**
 * 创建 JSContext
 * @param rootView 视图容器
 * @return JSContext
 */
+ (HMJSContext *)contextWithView:(UIView *)rootView;

@end

NS_ASSUME_NONNULL_END
