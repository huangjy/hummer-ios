//
//  UIView+Hummer.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "UIView+Hummer.h"
#import <objc/runtime.h>
#import "HMAttrManager.h"
#import "HMExportManager.h"
#import "NSObject+Hummer.h"
#import <YogaKit/UIView+Yoga.h>
#import "HMDomNode.h"
#import "HMYogaConfig.h"

@implementation UIView(Hummer)

HM_EXPORT_PROPERTY(style, __style, __setStyle:)
HM_EXPORT_PROPERTY(id, __viewId, __setViewId:)
HM_EXPORT_PROPERTY(enabled, __enabled, __setEnabled:)

- (instancetype)initWithValues:(NSArray *)values {
    self = [self init];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setDefaultLayout];
    }
    return self;
}

- (void)setDefaultLayout
{
    [self configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.alignItems = YGAlignCenter;
        layout.justifyContent = YGJustifyCenter;
        layout.alignContent = YGAlignCenter;
    }];
}

- (id<HMDomNode>)domNode {
    id<HMDomNode> domNode = objc_getAssociatedObject(self, _cmd);
    if (!domNode) {
        domNode = [HMDomNode nodeForView:self];
        objc_setAssociatedObject(self, _cmd, domNode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return domNode;
}

- (UIView *)getSubviewById:(NSString *)viewId
{
    if(!viewId) return nil;
    
    for (UIView *view in self.subviews) {
        if ([view.viewId isEqualToString:viewId]) {
            return view;
        }
        return [view getSubviewById:viewId];
    }
    return nil;
}

#pragma mark - Export Property

- (NSNumber *)__enabled{
    return @(self.userInteractionEnabled);
}

- (void)__setEnabled:(JSValue *)enabledValue {
    BOOL enabled = [enabledValue toBool];
    self.userInteractionEnabled = enabled;
}

- (NSNumber *)__hidden {
    return @(self.hidden);
}

- (void)__setHidden:(JSValue *)hiddenValue {
    BOOL hidden = [hiddenValue toBool];
    self.hidden = hidden;
}

- (NSDictionary *)__style {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:self.domNode.style];
    [dic addEntriesFromDictionary:self.domNode.attribute];
    return [dic copy];
}

- (void)__setStyle:(JSValue *)style {
    NSDictionary *styleDic = style.toDictionary;
    NSMutableDictionary *layoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [styleDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key,
                                                  id  _Nonnull obj,
                                                  BOOL * _Nonnull stop) {
        if ([[HMYogaConfig defaulfConfig] isYogaProperty:key]) {
            layoutInfo[key] = obj;
        } else {
            attributes[key] = obj;
        }
    }];
    [self.domNode configureLayout:[layoutInfo copy]];
    [self.domNode configureAttribute:[attributes copy]];
}

- (NSString *)__viewId {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)__setViewId:(NSString *)viewId {
    objc_setAssociatedObject(self, @selector(__viewId), viewId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
