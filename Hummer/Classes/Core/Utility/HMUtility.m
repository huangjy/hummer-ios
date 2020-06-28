//
//  HMUtility.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMUtility.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
#import "HMConverter.h"
#import "HMInterceptor.h"
#import "HMConfigure.h"

void _HMLogInternal(HMLogLevel level, NSString *format, ...) {
    NSString *levelString = nil;
    switch (level) {
        case HMLogLevelError: levelString = @"[ERROR]"; break;
        case HMLogLevelWarning: levelString = @"[WARNING]"; break;
        case HMLogLevelInfo: levelString = @"[INFO]"; break;
        case HMLogLevelTrace: levelString = @"[TRACE]"; break;
        default: levelString = @"[DEBUG]"; break;
    }
    
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    NSArray *interceptors = Interceptor(@protocol(HMReporterProtocol));
    if(interceptors.count > 0){
        for (id <HMReporterProtocol> interceptor in interceptors) {
            if ([interceptor respondsToSelector:@selector(logLevel:message:)])
                [interceptor logLevel:level message:message];
        }
    } else {
        NSLog(@"%@", message);
    }
}


void _HMAssert(NSString *func, NSString *file, int lineNum, NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    [[NSAssertionHandler currentHandler] handleFailureInFunction:func
                                                            file:file
                                                      lineNumber:lineNum
                                                     description:format, message];
}

NSString *_HMMD5String(NSString *input) {
    if (!input || ![input isKindOfClass:[NSString class]] || [input length] <= 0) return nil;
    
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH] = {0};
    CC_MD5(str, (uint32_t)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];
    }
    return ret;
}

NSString *_HMMD5Data(NSData *input) {
    if (!input || ![input isKindOfClass:[NSData class]] || [input length] <= 0) return nil;
    
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH] = {0};
    CC_MD5(input.bytes, (CC_LONG)input.length, md5Buffer);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", md5Buffer[i]];
    
    return output;
}

id _HMObjectFromJSONString(NSString *json) {
    if(!json) return nil;
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    if(data){
        NSError *error = nil;
        NSJSONReadingOptions options = NSJSONReadingMutableLeaves |
                                       NSJSONReadingMutableContainers |
                                       NSJSONReadingMutableContainers;
        id object = [NSJSONSerialization JSONObjectWithData:data
                                                    options:options
                                                      error:&error];
        if(error){
            HMLogError(@"json序列化失败, %@", [error description]);
        }
        return object;
    }
    
    return nil;
}

id _HMObjectFromJSONData(NSData *json) {
    if(!json) return nil;
    
    NSError *error = nil;
    NSJSONReadingOptions options = NSJSONReadingMutableLeaves |
                                   NSJSONReadingMutableContainers |
                                   NSJSONReadingMutableContainers;
    id object = [NSJSONSerialization JSONObjectWithData:json
                                                options:options
                                                  error:&error];
    if(error){
        HMLogError(@"json序列化失败, %@", [error description]);
    }
    return object;
}

NSString *_HMJSONStringWithObject(id object) {
    if([NSJSONSerialization isValidJSONObject:object]){
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
        if(error || !data){
            HMLogError(@"json反序列化失败, %@", [error description]);
        } else {
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    return nil;
}

#pragma mark - Image funcs

UIImage *HMImageFromLocalAssetName(NSString *imageName) {
    NSString *dir = [HMConfigure sharedInstance].rootDir;
    NSString *fileName = [dir stringByAppendingPathComponent:imageName];
    
    return [UIImage imageWithContentsOfFile:fileName];
}

NSError *HMError(NSInteger code, NSString *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    NSString *message = [[NSString alloc] initWithFormat:fmt arguments:args];
    va_end(args);
    
    return [NSError errorWithDomain:@"HummerError" code:code userInfo:@{@"msg":message}];
}
