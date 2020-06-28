//
//  HMUtility.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMReporterProtocol.h"

void _HMLogInternal(HMLogLevel level, NSString * _Nullable format, ...);

#define _HMLog(level, fmt, ...) \
do { \
_HMLogInternal(level, (fmt), ## __VA_ARGS__); \
} while(0)


#define HMLogDebug(format, ...)         _HMLog(HMLogLevelDebug, format, ##__VA_ARGS__)
#define HMLogWarning(format, ...)       _HMLog(HMLogLevelWarning, format ,##__VA_ARGS__)
#define HMLogError(format, ...)         _HMLog(HMLogLevelError, format, ##__VA_ARGS__)
#define HMLogInfo(format, ...)          _HMLog(HMLogLevelInfo, format, ##__VA_ARGS__)
#define HMLogTrace(format, ...)         _HMLog(HMLogLevelTrace, format, ##__VA_ARGS__)

void _HMAssert(NSString * _Nonnull func, NSString * _Nonnull file, int lineNum, NSString * _Nonnull format, ...);

#if DEBUG
#define HMAssert(condition, ...) \
do{ \
if(!(condition)){ \
_HMAssert(@(__func__), @(__FILE__), __LINE__, __VA_ARGS__); \
} \
}while(0)
#else
#define HMAssert(condition, ...)
#endif

NSString * _Nullable _HMMD5String(NSString * _Nonnull input);
NSString * _Nullable _HMMD5Data(NSData * _Nonnull input);
#define HMMD5Encode(input)  ([input isKindOfClass:[NSString class]] ? _HMMD5String((NSString *)input) : _HMMD5Data((NSData *)input))


id _Nullable _HMObjectFromJSONString(NSString * _Nonnull json);
id _Nullable _HMObjectFromJSONData(NSData * _Nonnull json);
#define HMJSONDecode(json) [json isKindOfClass:[NSString class]] ? _HMObjectFromJSONString((NSString *)json) : _HMObjectFromJSONData((NSData *)json)


NSString * _Nullable _HMJSONStringWithObject(id _Nonnull object);
#define HMJSONEncode(obj) _HMJSONStringWithObject(obj)

UIImage * _Nullable HMImageFromLocalAssetName(NSString * _Nonnull imageName);

NSError * _Nullable HMError(NSInteger code, NSString *_Nullable fmt, ...);
