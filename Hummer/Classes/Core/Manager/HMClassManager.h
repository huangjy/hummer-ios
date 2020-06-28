//
//  HMClassManager.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMJSClassDef;

@interface HMClassManager : NSObject

+ (instancetype)defaultManager;

- (instancetype)init NS_UNAVAILABLE;

- (HMJSClassDef *)createJSClass:(NSString *)className;

@end
