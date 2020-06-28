//
//  HMAttrManager.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMViewAttribute : NSObject

@property (nonatomic, strong) NSString *viewProp;
@property (nonatomic, strong) NSString *cssAttr;
@property (nonatomic, assign) SEL converter;

+ (instancetype)viewAttrWithName:(NSString *)viewProp
                         cssAttr:(NSString *)cssAttr
                       converter:(SEL)converter;
@end

#define HM_EXPORT_ATTRIBUTE(attr, vprop, conv) \
+ (HMViewAttribute *)__hm_view_attribute_##vprop##__ {\
    return [HMViewAttribute viewAttrWithName:@#vprop cssAttr:@#attr converter:@selector(conv)];\
}

@interface HMAttrManager : NSObject

+ (instancetype)sharedManager;

- (NSDictionary *)viewAttrsForClass:(Class)clazz;

@end
