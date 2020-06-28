//
//  HMView.m
//  Hummer
//
//  Copyright © 2019 huangjy. All rights reserved.
//

#import "HMView.h"
#import "HMExportManager.h"
#import "HMAttrManager.h"
#import "HMConverter.h"
#import "JSValue+Hummer.h"
#import "NSObject+Hummer.h"
#import "HMUtility.h"
#import "UIView+Hummer.h"

@implementation HMView

HM_EXPORT_CLASS(View, HMView)

HM_EXPORT_METHOD(appendChild, __addSubview:)
HM_EXPORT_METHOD(removeChild, __removeSubview:)
HM_EXPORT_METHOD(removeAll, __removeAllSubviews)
HM_EXPORT_METHOD(insertBefore, __insertBefore:withNode:)
HM_EXPORT_METHOD(replaceChild, __replaceSubview:withNode:)
HM_EXPORT_METHOD(getElementById, __getSubviewById:)
HM_EXPORT_METHOD(layout, __layoutSubviews)


#pragma mark - Export Method

- (void)__addSubview:(JSValue *)subview {
    UIView *view = subview.toObjCObject;
    if(view){
        [self addSubview:view];
    }
}

- (void)__removeSubview:(JSValue *)child {
    UIView *view = child.toObjCObject;
    [view removeFromSuperview];
}

- (void)__removeAllSubviews {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj,
                                                NSUInteger idx,
                                                BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

- (void)__layoutSubviews {
    [self.yoga applyLayoutPreservingOrigin:NO];
}

- (void)__replaceSubview:(JSValue *)newChild withNode:(JSValue *)oldChild {
    UIView *newView = newChild.toObjCObject;
    UIView *oldView = oldChild.toObjCObject;
    NSInteger index = [self.subviews indexOfObject:oldView];
    if (index == NSNotFound) { return; }
    
    [oldView removeFromSuperview];
    [self insertSubview:newView atIndex:index];
}

- (void)__insertBefore:(JSValue *)newChild withNode:(JSValue *)oldChild {
    UIView *newView = newChild.toObjCObject;
    UIView *oldView = oldChild.toObjCObject;
    if ([oldView isDescendantOfView:self]) {
        [self insertSubview:newView belowSubview:oldView];
    }
}

- (JSValue *)__getSubviewById:(JSValue *)viewId {
    return [self getSubviewById:viewId.toString].jsValue;
}
@end
