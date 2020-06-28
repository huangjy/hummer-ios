//
//  NSObject+Hummer.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMJSObject.h"
#import "HMExportManager.h"

@interface NSObject (Hummer) <HMJSObject>

@property (nonatomic, weak) JSContext *jsContext;
@property (nonatomic, weak, readonly) JSValue *jsValue;

@end
