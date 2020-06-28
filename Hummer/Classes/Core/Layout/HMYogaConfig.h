//
//  HMYogaConfig.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMYogaConfig : NSObject
/**
 * 单例方法
 * @return 单例对象
 */
+ (instancetype)defaulfConfig;
/**
 * 获取 css 属性对应的 yoga 属性名
 * @param cssAttr : css 属性名
 * @return yoga 属性名
 */
- (NSString *)ygPropertyWithCSSAttr:(NSString *)cssAttr;
/**
 * 获取 css 属性到的 yoga 属性的转换函数
 * @param cssAttr : css 属性名
 * @return 转换函数
 */
- (SEL)converterWithCSSAttr:(NSString *)cssAttr;
/**
 * 是否是  yoga 属性名
 * @return YES / NO
 */
- (BOOL)isYogaProperty:(NSString *)propName;

@end
