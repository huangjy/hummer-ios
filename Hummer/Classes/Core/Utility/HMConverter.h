//
//  HMConverter.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "UIView+Yoga.h"
#import <YogaKit/YGLayout.h>

@interface HMConverter : NSObject

#pragma mark - color
/*
 * only support color in RGB space,
 * so color like '[UIColor blackColor]' is not supported
 */
+ (NSString *)HMColorToString:(UIColor *)color;
+ (UIColor *)HMStringToColor:(NSString *)string;

#pragma mark - yoga

+ (YGDirection)HMStringToYGDirection:(NSString *)string;
+ (YGFlexDirection)HMStringToYGFlexDirection:(NSString *)string;
+ (YGJustify)HMStringToYGJustify:(NSString *)string;
+ (YGAlign)HMStringToYGAlign:(NSString *)string;
+ (YGPositionType)HMStringToYGPosition:(NSString *)string;
+ (YGWrap)HMStringToYGFlexWrap:(NSString *)string;
+ (YGOverflow)HMStringToYGOverflow:(NSString *)string;
+ (YGDisplay)HMStringToYGDisplay:(NSString *)string;
+ (YGValue)HMNumberToYGPoint:(NSNumber *)number;

#pragma mark - text

+ (NSTextAlignment)HMStringToTextAlignment:(NSString *)string;
+ (NSDictionary *)HMStringToTextDecoration:(NSString *)string;
+ (NSLineBreakMode)HMStringToBreakMode:(NSString *)string;

#pragma mark - font

+ (UIFontWeight)HMStringToFontWeight:(NSString *)string;

#pragma mark - keyboard

+ (UIReturnKeyType)HMStringToReturnKeyType:(NSString *)string;

#pragma mark - basic

+ (CGFloat)HMNumberToCGFloat:(NSNumber *)number;
+ (NSInteger)HMNumberToNSInteger:(NSNumber *)number;
+ (CGFloat)HMStringToFloat:(NSString *)string;
+ (NSString *)HMStringOrigin:(NSString *)string;

#pragma mark - shadow

+ (NSArray *)HMStringToShadowAttributes:(NSString *)string;

#pragma mark - view

+ (BOOL)HMStringToViewHidden:(NSString *)string;
+ (BOOL)HMStringToClipSubviews:(NSString *)string;
+ (UIViewContentMode)HMStringToContentMode:(NSString *)contentMode;

#pragma mark - collection view

+ (UICollectionViewScrollDirection)HMStringToDirection:(NSString *)string;

@end
