//
//  UIView+HMAttribute.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "UIView+HMAttribute.h"
#import "HMAttrManager.h"
#import "HMConverter.h"
#import "HMUtility.h"
#import <objc/runtime.h>

@implementation UIView(HMAttribute)

HM_EXPORT_ATTRIBUTE(backgroundColor, __backgroundColor, HMStringToColor:)
HM_EXPORT_ATTRIBUTE(opacity, alpha, HMNumberToCGFloat:)
HM_EXPORT_ATTRIBUTE(visibility, hidden, HMStringToViewHidden:)
HM_EXPORT_ATTRIBUTE(borderWidth, __borderWidth, HMStringToFloat:)
HM_EXPORT_ATTRIBUTE(borderColor, __borderColor, HMStringToColor:)
HM_EXPORT_ATTRIBUTE(borderRadius, __borderRadius, HMStringToFloat:)
HM_EXPORT_ATTRIBUTE(shadow, __shadow, HMStringToShadowAttributes:)
HM_EXPORT_ATTRIBUTE(overflow, clipsToBounds, HMStringToClipSubviews:)

- (NSDictionary *)viewProps {
    
    NSDictionary *viewProps = objc_getAssociatedObject(self, _cmd);
    if(!viewProps){
        viewProps = [[HMAttrManager sharedManager] viewAttrsForClass:[self class]];
        objc_setAssociatedObject(self, _cmd, viewProps, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return viewProps;
}

- (SEL)converterWithCSSAttr:(NSString *)cssAttr
{
    if (!cssAttr) return nil;
    
    HMViewAttribute *object = self.viewProps[cssAttr];
    return object.converter;
}

- (NSString *)viewPropWithCSSAttr:(NSString *)cssAttr {
    if (!cssAttr) return nil;
    
    HMViewAttribute *object = self.viewProps[cssAttr];
    return object.viewProp;
}



#pragma mark - Export Attribute

- (void)set__borderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)set__borderRadius:(CGFloat)borderRadius {
    self.layer.cornerRadius = borderRadius;
}

- (void)set__borderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)set__shadow:(NSArray *)shadowAttributes {
    CGFloat widthOffset = [shadowAttributes[0] floatValue];
    CGFloat heightOffset = [shadowAttributes[1] floatValue];
    CGFloat shadowRadius = [shadowAttributes[2] floatValue];
    UIColor *color = shadowAttributes[3];
    
    self.layer.shadowRadius = shadowRadius;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = CGSizeMake(widthOffset, heightOffset);
    self.layer.shadowOpacity = 1.0;
}

- (void)set__backgroundColor:(UIColor *)backgroundColor {
    [self setBackgroundColor:backgroundColor];
}

- (void)set__backgroundImage:(NSString *)imageString {
    if (!imageString) { return; }
    
    UIImage *image = [UIImage imageNamed:imageString];
    NSAssert(image, @"empty image");
    if (image) {
        UIColor *color = [[UIColor alloc] initWithPatternImage:image];
        self.backgroundColor = color;
    }
}

@end
