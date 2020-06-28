//
//  JSValue+Hummer.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@interface JSValue(Hummer)

- (id)toObjCObject;

+ (instancetype)valueWithClass:(Class)objcClass inContext:(JSContext *)context;

@end
