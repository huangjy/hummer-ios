//
//  Hummer.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "Hummer.h"
#import "HMInterceptor.h"
#import "HMConfigure.h"
#import "HMPerformance.h"
#import "HMExportManager.h"
#import "HMGlobalObject.h"
#import "NSObject+Hummer.h"

double HummerVersionNumber = 100000000;
const unsigned char HummerVersionString[] = "1.0.0";

@implementation Hummer

+ (void)startEngine:(void (^)(HMConfigure *config))builder {
    Measure(HummerEngineInit, ^{
        // global config
        HMConfigure *config = [HMConfigure sharedInstance];
        if(builder) builder(config);
        // load all interceptor
        [[HMInterceptor sharedInstance] loadExportInterceptor];
        // load export classes
        [[HMExportManager sharedInstance] loadExportClasses];
    });
}

+ (void)addEnvParams:(NSDictionary *)params {
    if(!params) return;
    
    [[HMGlobalObject globalObject] addEnvParams:params];
}

+ (void)addGlobalScript:(NSString *)script {
    if(!script || script.length <= 0) return;
    
    [[HMGlobalObject globalObject] addGlobalScript:script];
}

+ (HMJSContext *)contextWithView:(UIView *)rootView
{
    HMJSContext *jsContext =  [[HMJSContext alloc] init];
    [[HMGlobalObject globalObject] weakReference:rootView context:jsContext];
    return jsContext;
}
@end
