//
//  UIView+HMAttribute.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(HMAttribute)

@property (nonatomic, strong, readonly) NSDictionary *viewProps;

- (SEL)converterWithCSSAttr:(NSString *)cssAttr;

- (NSString *)viewPropWithCSSAttr:(NSString *)cssAttr;

@end
