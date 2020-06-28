//
//  HMJSClassDef.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@interface HMJSClassDef : NSObject

@property (nonatomic, strong, readonly) NSString *className;

- (instancetype)initWithJSClass:(NSString *)className;

- (JSClassRef)classRef;
- (void)registerJSClassRef;

@end
