//
//  HMConverter.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMConverter.h"
#import "HMUtility.h"
#import "HMConfigure.h"

@implementation HMConverter

#pragma mark - color

+ (UIColor *)HMStringToColor:(NSString *)string {
    // 支持 1. #AA0000
    //     2. #AA000000
    //     3. linear-gradient(90deg #FF000060 #00FF0060)
    NSAssert(string, @"empty color string");
    if (!string) return nil;
    
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string hasPrefix:@"#"]) {
        NSString *hexStr = [[string stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
        NSScanner *scanner = [NSScanner scannerWithString:hexStr]; unsigned hexNum = 0;
        if (![scanner scanHexInt:&hexNum]) return nil;
        
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
        if (hexStr.length>6)
        return HEXCOLOR(hexNum);
        
        int red = (hexNum >> 16) & 0xFF; int green = (hexNum >> 8) & 0xFF; int blue = (hexNum) & 0xFF;
        return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1.0f];
    }
    
    return nil;
}

+ (NSString *)HMColorToString:(UIColor *)color {
    if (!color) {
        return nil;
    }
    
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat red = components[0];
    CGFloat green = components[1];
    CGFloat blue = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(red * 255),
            lroundf(green * 255),
            lroundf(blue * 255)];
}

#pragma mark - yoga

+ (YGValue)HMNumberToYGPoint:(NSNumber *)number {
    CGFloat value = [number floatValue];
    return YGPointValue((value * [HMConfigure sharedInstance].calRatio));
}

+ (YGDirection)HMStringToYGDirection:(NSString *)string {
    if([string isEqualToString:@"left"]){
        return YGDirectionLTR;
    } else if([string isEqualToString:@"right"]){
        return YGDirectionRTL;
    }
    return YGDirectionInherit;
}

+ (YGFlexDirection)HMStringToYGFlexDirection:(NSString *)string {
    if([string isEqualToString:@"row"]){
        return YGFlexDirectionRow;
    } else if([string isEqualToString:@"row-reverse"]){
        return YGFlexDirectionRowReverse;
    } else if([string isEqualToString:@"column-reverse"]){
        return YGFlexDirectionColumnReverse;
    }
    return YGFlexDirectionColumn;
}

+ (YGJustify)HMStringToYGJustify:(NSString *)string {
    if([string isEqualToString:@"flex-start"]){
        return YGJustifyFlexStart;
    } else if([string isEqualToString:@"flex-end"]){
       return YGJustifyFlexEnd;
    } else if([string isEqualToString:@"space-between"]){
       return YGJustifySpaceBetween;
    } else if([string isEqualToString:@"space-around"]){
      return YGJustifySpaceAround;
    } else if([string isEqualToString:@"space-evenly"]){
      return YGJustifySpaceEvenly;
    }
    return YGJustifyCenter;
}

+ (YGAlign)HMStringToYGAlign:(NSString *)string {
    if([string isEqualToString:@"flex-start"]){
        return YGAlignFlexStart;
    } else if([string isEqualToString:@"center"]){
        return YGAlignCenter;
    } else if([string isEqualToString:@"flex-end"]){
        return YGAlignFlexEnd;
    } else if([string isEqualToString:@"space-between"]){
        return YGAlignStretch;
    } else if([string isEqualToString:@"space-around"]){
        return YGAlignBaseline;
    } else if([string isEqualToString:@"space-evenly"]){
        return YGAlignSpaceBetween;
    } else if([string isEqualToString:@"space-around"]){
        return YGAlignSpaceAround;
    }
    return YGAlignAuto;
}

+ (YGPositionType)HMStringToYGPosition:(NSString *)string {
    if([string isEqualToString:@"absolute"]){
        return YGPositionTypeAbsolute;
    }
    return YGPositionTypeRelative;
}

+ (YGWrap)HMStringToYGFlexWrap:(NSString *)string {
    if([string isEqualToString:@"wrap"]){
        return YGWrapWrap;
    } else if([string isEqualToString:@"wrap-reverse"]){
        return YGWrapWrapReverse;
    } else if([string isEqualToString:@"no-wrap"]){
        return YGWrapNoWrap;
    }
    return YGWrapNoWrap;
}

+ (YGOverflow)HMStringToYGOverflow:(NSString *)string {
    if([string isEqualToString:@"visiable"]){
        return YGOverflowVisible;
    }
    return YGOverflowHidden;
}

+ (YGDisplay)HMStringToYGDisplay:(NSString *)string {
    if([string isEqualToString:@"none"]){
        return YGDisplayNone;
    }
    return YGDisplayFlex;
}

#pragma mark - text

+ (NSTextAlignment)HMStringToTextAlignment:(NSString *)string {
    if ([string isEqualToString:@"center"]) {
        return NSTextAlignmentCenter;
    } else if ([string isEqualToString:@"right"]) {
        return NSTextAlignmentRight;
    }
    return NSTextAlignmentLeft;
}

+ (NSDictionary *)HMStringToTextDecoration:(NSString *)string {
    if ([string containsString:@"line-through"]) {
        return @{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)};
    } else if ([string containsString:@"underline"]) {
        return @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    }
    
    return @{};
}

+ (NSLineBreakMode)HMStringToBreakMode:(NSString *)string {
    if([string isEqualToString:@"ellipsis"]){
        return NSLineBreakByTruncatingTail;
    }
    return NSLineBreakByClipping;
}

#pragma mark - font

+ (UIFontWeight)HMStringToFontWeight:(NSString *)string {
    if (@available(iOS 8.2, *)) {
        UIFontWeight weight = UIFontWeightRegular;
        if ([string isEqualToString:@"bold"]) {
            weight = UIFontWeightBold;
        }
        return weight;
    }
    
    UIFontWeight weight = 0.0;
    if ([string isEqualToString:@"bold"]) {
        weight = 0.4;
    }
    return weight;
}

#pragma mark - keyboard

+ (UIReturnKeyType)HMStringToReturnKeyType:(NSString *)string {
    if ([string isEqualToString:@"go"]) {
        return UIReturnKeyGo;
    } else if([string isEqualToString:@"next"]){
        return UIReturnKeyNext;
    } else if([string isEqualToString:@"search"]){
        return UIReturnKeySearch;
    } else if([string isEqualToString:@"send"]){
        return UIReturnKeySend;
    }
    return UIReturnKeyDefault;
}

#pragma mark - basic

+ (CGFloat)HMNumberToCGFloat:(NSNumber *)number {
    return [number floatValue];
}

+ (NSInteger)HMNumberToNSInteger:(NSNumber *)number {
    return [number integerValue];
}

+ (CGFloat)HMStringToFloat:(NSString *)string {
    if ([string isKindOfClass:[NSNumber class]]) {
        string = [((NSNumber *)string) stringValue];
    }
    
    CGFloat number = 0;
    NSScanner *scanner = [[NSScanner alloc] initWithString:string];
    [scanner scanDouble: &number];
    return number;
}

+ (NSString *)HMStringOrigin:(NSString *)string {
    return string;
}

#pragma mark - shadow

+ (NSArray *)HMStringToShadowAttributes:(NSString *)string {
    if (!string || [string isEqualToString:@""]) {
        return nil;
    }
    
    NSArray *array = [string componentsSeparatedByString:@" "];
    if (array.count != 4) {
        return @[];
    }
    
   return @[@([self HMStringToFloat:array[0]]),
   @([self HMStringToFloat:array[1]]),
   @([self HMStringToFloat:array[2]]),
   [self HMStringToColor:array[3]]];
}

#pragma mark - view

+ (BOOL)HMStringToViewHidden:(NSString *)string {
    if ([string isEqualToString:@"hidden"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)HMStringToClipSubviews:(NSString *)string {
    return [string isEqualToString:@"hidden"];
}

+ (UIViewContentMode)HMStringToContentMode:(NSString *)contentMode {
    if ([contentMode isEqualToString:@"origin"]) {
        return UIViewContentModeCenter;
    } else if([contentMode isEqualToString:@"contain"]){
        return UIViewContentModeScaleAspectFit;
    } else if([contentMode isEqualToString:@"cover"]){
        return UIViewContentModeScaleAspectFill;
    } else if([contentMode isEqualToString:@"stretch"]){
        return UIViewContentModeScaleToFill;
    }
    return UIViewContentModeCenter;
}

#pragma mark - collection view

+ (UICollectionViewScrollDirection)HMStringToDirection:(NSString *)string {
    if ([string isEqualToString:@"horizontal"]) {
        return UICollectionViewScrollDirectionHorizontal;
    }
    return UICollectionViewScrollDirectionVertical;
}

@end
