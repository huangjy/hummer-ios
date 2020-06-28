//
//  HMGlobalObject.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>

@protocol HMGlobalExport <JSExport>

JSExportAs(render, - (void)render:(JSValue *)page);

JSExportAs(callFunc, - (JSValue *)callFunc:(JSValue *)cls
                                    method:(JSValue *)method
                                 arguments:(JSValue *)arguments);

- (NSDictionary *)env;
@end

@interface HMGlobalObject : NSObject<HMGlobalExport>

@property (nonatomic, strong, readonly) NSString *globalScript;


+ (instancetype)globalObject;

/**
 * 添加全局环境变量
 * @param params 全局环境变量
 */
- (void)addEnvParams:(NSDictionary *)params;

/**
 * 添加全局注入脚本
 * @param script 脚本字符串
 */
- (void)addGlobalScript:(NSString *)script;

/**
 * 绑定容器和 JS 执行上下文
 * @param rootView 视图容器
 * @param context JS 执行上下文
 */
- (void)weakReference:(UIView *)rootView context:(JSContext *)context;

@end
