//
//  HMDomNode.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMDomNode.h"
#import "UIView+HMAttribute.h"
#import "HMUtility.h"
#import "UIView+Hummer.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "HMConverter.h"
#import "HMYogaConfig.h"
#import "HMAttrManager.h"

@interface HMDomNode()

@property (nonatomic, strong) NSMutableDictionary *domDict;
@property (nonatomic, weak) UIView *linkView;
@property (nonatomic, strong) NSMutableDictionary *domStyle;
@property (nonatomic, strong) NSMutableDictionary *domAttr;

@end

@implementation HMDomNode

- (instancetype)initWithView:(UIView *)view {
    self = [self init];
    if (self) {
        _linkView = view;
    }
    return self;
}

- (NSMutableDictionary *)domDict {
    if (!_domDict) {
        _domDict = [NSMutableDictionary dictionary];
    }
    return _domDict;
}

+ (instancetype)nodeForView:(UIView *)view {
    return [[HMDomNode alloc] initWithView:view];
}

- (NSMutableDictionary *)domStyle {
    if (!_domStyle) {
        _domStyle = [NSMutableDictionary dictionary];
    }
    return _domStyle;
}

- (NSMutableDictionary *)domAttr {
    if (!_domAttr) {
        _domAttr = [NSMutableDictionary dictionary];
    }
    return _domAttr;
}

- (NSDictionary *)attribute {
    return self.domAttr.copy;
}

- (NSDictionary *)style {
    return self.domStyle.copy;
}

- (void)configureLayout:(NSDictionary *)domStyle {
    if (!domStyle) return;
    
    [self.domStyle addEntriesFromDictionary:domStyle];
    
    __weak typeof(self) weakSelf = self;
    [self.linkView configureLayoutWithBlock:^(YGLayout * layout) {
        layout.isEnabled = YES;
        [weakSelf bindLayout:layout withStyle:domStyle];
    }];
    [self.linkView.yoga applyLayoutPreservingOrigin:NO];
}

- (void)bindLayout:(YGLayout *)layout withStyle:(NSDictionary *)domStyle {
    if (!layout || !domStyle) return;
    
    __weak typeof(self) weakSelf = self;
    [domStyle enumerateKeysAndObjectsUsingBlock:^(NSString *key,
                                                  id obj,
                                                  BOOL *stop) {
        [weakSelf setLayout:layout cssAttr:key withStyle:obj];
    }];
}

- (void)setLayout:(YGLayout *)layout
          cssAttr:(NSString *)cssAttr
        withStyle:(id)style {
    if (!layout || !cssAttr || !style) return;
    
    HMYogaConfig *defaultConfig = [HMYogaConfig defaulfConfig];
    SEL converter = [defaultConfig converterWithCSSAttr:cssAttr];
    if (!converter || ![[HMConverter class] respondsToSelector:converter]) {
        HMLogError(@"HMConverter can not found selecor [%@]",
                   NSStringFromSelector(converter));
        return;
    }
    
    NSMethodSignature *signature = [[HMConverter class] methodSignatureForSelector:converter];
    if (signature.numberOfArguments != 3 || *(signature.methodReturnType) == 'v') {
        HMLogError(@"Converter [%@] method signature error!",
                   NSStringFromSelector(converter));
        return;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:[HMConverter class]];
    [invocation setSelector:converter];
    [invocation setArgument:(void *)&style atIndex:2];
    [invocation invoke];
    
    void *returnVal = (void *)malloc([signature methodReturnLength]);
    [invocation getReturnValue:returnVal];
    
    NSString *property = [defaultConfig ygPropertyWithCSSAttr:cssAttr];
    SEL selector = [self setterSelectorForPropertyName:property];
    signature = [layout methodSignatureForSelector:selector];
    invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:layout];
    [invocation setSelector:selector];
    [invocation setArgument:(void *)returnVal atIndex:2];
    [invocation invoke];
    
    if (returnVal) free(returnVal);
}

- (SEL)setterSelectorForPropertyName:(NSString *)propertyName {
    if (!propertyName || propertyName.length <= 0) return nil;
    
    NSString *setterSel = [NSString stringWithFormat:@"set%@%@:", [[propertyName substringToIndex:1] uppercaseString],
                           [propertyName substringFromIndex:1]];
    return NSSelectorFromString(setterSel);
}

- (void)configureAttribute:(NSDictionary *)domAttr {
    if (!domAttr) return;
    
    [self.domAttr addEntriesFromDictionary:domAttr];
    
    [self bindLinkView:self.linkView withAttr:domAttr];
}

- (void)bindLinkView:(UIView *)linkView withAttr:(NSDictionary *)domAttr {
    if (!linkView || !domAttr) return;
    
    __weak typeof(self) weakSelf = self;
    [domAttr enumerateKeysAndObjectsUsingBlock:^(NSString *key,
                                                 id obj,
                                                 BOOL * stop) {
        [weakSelf setLinkView:linkView cssAttr:key withAttr:obj];
    }];
}

- (void)setLinkView:(UIView *)linkView
            cssAttr:(NSString *)cssAttr
           withAttr:(id)attr {
    if (!linkView || !cssAttr || !attr) return;
    
    SEL converter = [linkView converterWithCSSAttr:cssAttr];
    if (!converter || ![[HMConverter class] respondsToSelector:converter]) {
        HMLogError(@"HMConverter can not found selecor [%@]",
                   NSStringFromSelector(converter));
        return;
    }
    
    NSMethodSignature *signature = [[HMConverter class] methodSignatureForSelector:converter];
    if (signature.numberOfArguments != 3 ||
        *(signature.methodReturnType) == 'v') {
        HMLogError(@"Converter [%@] method signature error!",
                   NSStringFromSelector(converter));
        return;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:[HMConverter class]];
    [invocation setSelector:converter];
    [invocation setArgument:(void *)&attr atIndex:2];
    [invocation invoke];
    
    void *returnVal = (void *)malloc([signature methodReturnLength]);
    [invocation getReturnValue:returnVal];
    
    NSString *property = [linkView viewPropWithCSSAttr:cssAttr];
    SEL selector = [self setterSelectorForPropertyName:property];
    signature = [self.linkView methodSignatureForSelector:selector];
    NSAssert(signature, @"empty method signature");
    if (!signature) {
        return;
    }
    
    invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self.linkView];
    [invocation setSelector:selector];
    [invocation setArgument:(void *)returnVal atIndex:2];
    [invocation invoke];
    
    if (returnVal) free(returnVal);
}

@end
