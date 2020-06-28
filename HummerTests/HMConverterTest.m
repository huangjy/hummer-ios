//
//  HMConverterTest.m
//  HummerTests
//
//  Copyright © 2019 huangjy. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "HMConverter.h"

@interface HMConverterTest : XCTestCase

@end

@implementation HMConverterTest

#pragma mark - color

- (void)testColorToString {
    UIColor *white = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    NSString *colorString = [HMConverter HMColorToString:white];
    XCTAssert([colorString isEqualToString:@"#FFFFFF"],
              @"incorrect color to string conversion");
    
    NSString *emptyString = [HMConverter HMColorToString:nil];
    XCTAssertNil(emptyString, @"should be empty string");
}

- (void)testStringToColor {
    UIColor *blackColor = [HMConverter HMStringToColor:@"#000000"];
    UIColor *colorWithAlpha = [HMConverter HMStringToColor:@"#FFFFFF00"];
    UIColor *wrongFormat = [HMConverter HMStringToColor:@"1111111"];
    UIColor *empty = [HMConverter HMStringToColor:@""];

    
    
    XCTAssert(CGColorEqualToColor(blackColor.CGColor,
                                  [UIColor colorWithRed:0
                                                  green:0
                                                   blue:0
                                                  alpha:1.0].CGColor),
              @"can not convert string to color");
    XCTAssert(CGColorEqualToColor(colorWithAlpha.CGColor,
                                  [UIColor colorWithRed:1.0
                                                  green:1.0
                                                   blue:1.0
                                                  alpha:0.0].CGColor),
              @"can not convert string to color");
    XCTAssertNil(wrongFormat, @"should be empty string");
    XCTAssertNil(empty, @"should be empty string");
}

#pragma mark - yoga

- (void)testStringToYGDirection {
    YGDirection left = [HMConverter HMStringToYGDirection:@"left"];
    YGDirection right = [HMConverter HMStringToYGDirection:@"right"];
    YGDirection nilValue = [HMConverter HMStringToYGDirection:nil];
    
    XCTAssertEqual(left, YGDirectionLTR, @"should be left");
    XCTAssertEqual(right, YGDirectionRTL, @"should be right");
    XCTAssertEqual(nilValue, YGDirectionInherit, @"should be inherit");
}

- (void)testStringToYGFlexDirection {
    YGFlexDirection row = [HMConverter HMStringToYGFlexDirection:@"row"];
    YGFlexDirection rowReverse = [HMConverter HMStringToYGFlexDirection:@"row-reverse"];
    YGFlexDirection column = [HMConverter HMStringToYGFlexDirection:@"column"];
    YGFlexDirection columnReverse = [HMConverter HMStringToYGFlexDirection:@"column-reverse"];
    YGFlexDirection nilValue = [HMConverter HMStringToYGFlexDirection:nil];
    
    XCTAssertEqual(row, YGFlexDirectionRow, @"should be row");
    XCTAssertEqual(rowReverse, YGFlexDirectionRowReverse, @"should be row reverse");
    XCTAssertEqual(column, YGFlexDirectionColumn, @"should be column");
    XCTAssertEqual(columnReverse, YGFlexDirectionColumnReverse, @"should be column reverse");
    XCTAssertEqual(nilValue, YGFlexDirectionColumn, @"should be column");
}

- (void)testStringToYGJustify {
    YGJustify start = [HMConverter HMStringToYGJustify:@"flex-start"];
    YGJustify center = [HMConverter HMStringToYGJustify:@"cneter"];
    YGJustify end = [HMConverter HMStringToYGJustify:@"flex-end"];
    YGJustify spaceBetween = [HMConverter HMStringToYGJustify:@"space-between"];
    YGJustify spaceAround = [HMConverter HMStringToYGJustify:@"space-around"];
    YGJustify spaceEvenly = [HMConverter HMStringToYGJustify:@"space-evenly"];
    YGJustify nilValue = [HMConverter HMStringToYGJustify:nil];
    
    XCTAssertEqual(start, YGJustifyFlexStart, @"should be flex start");
    XCTAssertEqual(center, YGJustifyCenter, @"should be center");
    XCTAssertEqual(end, YGJustifyFlexEnd, @"should be flex end");
    XCTAssertEqual(spaceBetween, YGJustifySpaceBetween, @"should be space between");
    XCTAssertEqual(spaceAround, YGJustifySpaceAround, @"should be space around");
    XCTAssertEqual(spaceEvenly, YGJustifySpaceEvenly, @"should be space evenly");
    XCTAssertEqual(nilValue, YGJustifyCenter, @"should be center");
}

- (void)testStringToYGAlign {
    YGAlign autoValue = [HMConverter HMStringToYGAlign:@"auto"];
    YGAlign start = [HMConverter HMStringToYGAlign:@"flex-start"];
    YGAlign center = [HMConverter HMStringToYGAlign:@"center"];
    YGAlign end = [HMConverter HMStringToYGAlign:@"flex-end"];
    YGAlign stretch = [HMConverter HMStringToYGAlign:@"stretch"];
    YGAlign baseline = [HMConverter HMStringToYGAlign:@"baseline"];
    YGAlign spaceBetween = [HMConverter HMStringToYGAlign:@"space-between"];
    YGAlign SpaceAround = [HMConverter HMStringToYGAlign:@"space-around"];
    YGAlign nilValue = [HMConverter HMStringToYGAlign:nil];
    
    XCTAssertEqual(autoValue, YGAlignAuto, @"should be auto");
    XCTAssertEqual(start, YGAlignFlexStart, @"should be flex start");
    XCTAssertEqual(center, YGAlignCenter, @"should be center");
    XCTAssertEqual(end, YGAlignFlexEnd, @"should be flex end");
    XCTAssertEqual(stretch, YGAlignStretch, @"should be stretch");
    XCTAssertEqual(baseline, YGAlignBaseline, @"should be baseline");
    XCTAssertEqual(spaceBetween, YGAlignSpaceBetween, @"should be space between");
    XCTAssertEqual(SpaceAround, YGAlignSpaceAround, @"should be space around");
    XCTAssertEqual(nilValue, YGAlignAuto, @"should be auto");
}

- (void)testStringToYGPosition {
    YGPositionType absolute = [HMConverter HMStringToYGPosition:@"absolute"];
    YGPositionType relative = [HMConverter HMStringToYGPosition:@"relative"];
    YGPositionType nilValue = [HMConverter HMStringToYGPosition:nil];
    
    XCTAssertEqual(absolute, YGPositionTypeAbsolute, @"should be absolute");
    XCTAssertEqual(relative, YGPositionTypeRelative, @"should be relative");
    XCTAssertEqual(nilValue, YGPositionTypeRelative, @"should be relative");
}

- (void)testStringToYGFlexWrap {
    YGWrap wrap = [HMConverter HMStringToYGFlexWrap:@"wrap"];
    YGWrap wrapReverse = [HMConverter HMStringToYGFlexWrap:@"wrap-reverse"];
    YGWrap noWrap = [HMConverter HMStringToYGFlexWrap:@"no-wrap"];
    YGWrap nilValue = [HMConverter HMStringToYGFlexWrap:nil];
    
    XCTAssertEqual(wrap, YGWrapWrap, @"should be wrap");
    XCTAssertEqual(wrapReverse, YGWrapWrapReverse, @"should be wrap-reverse");
    XCTAssertEqual(noWrap, YGWrapNoWrap, @"should be no-wrap");
    XCTAssertEqual(nilValue, YGPositionTypeRelative, @"should be no-wrap");
}

- (void)testStringToYGOverflow {
    YGOverflow visible = [HMConverter HMStringToYGOverflow:@"visible"];
    YGOverflow hidden = [HMConverter HMStringToYGOverflow:@"hidden"];
    YGOverflow nilValue = [HMConverter HMStringToYGOverflow:nil];
    
    XCTAssertEqual(visible, YGOverflowVisible, @"should be visible");
    XCTAssertEqual(hidden, YGOverflowHidden, @"should be hidden");
    XCTAssertEqual(nilValue, YGOverflowHidden, @"should be hidden");
}

- (void)testStringToYGDisplay {
    YGDisplay flex = [HMConverter HMStringToYGDisplay:@"flex"];
    YGDisplay none = [HMConverter HMStringToYGDisplay:@"none"];
    YGDisplay nilValue = [HMConverter HMStringToYGDisplay:nil];
    
    XCTAssertEqual(flex, YGDisplayFlex, @"should be flex");
    XCTAssertEqual(none, YGDisplayNone, @"should be none");
    XCTAssertEqual(nilValue, YGDisplayFlex, @"should be flex");
}

- (void)testNumberToYGPoint {
    YGValue one = [HMConverter HMNumberToYGPoint:@(1.0)];
    YGValue nilValue = [HMConverter HMNumberToYGPoint:nil];
    
    XCTAssertEqual(one.value, 1.0, @"should be 1.0");
    XCTAssertEqual(nilValue.value, 0.0, @"should be 0.0");
}

#pragma mark - text

- (void)HMStringToTextAlignment {
    NSTextAlignment left = [HMConverter HMStringToTextAlignment:@"left"];
    NSTextAlignment center = [HMConverter HMStringToTextAlignment:@"center"];
    NSTextAlignment right = [HMConverter HMStringToTextAlignment:@"right"];
    NSTextAlignment nilValue = [HMConverter HMStringToTextAlignment:nil];
    
    XCTAssertEqual(left, NSTextAlignmentLeft, @"should be left");
    XCTAssertEqual(center, NSTextAlignmentCenter, @"should be center");
    XCTAssertEqual(right, NSTextAlignmentRight, @"should be right");
    XCTAssertEqual(nilValue, NSTextAlignmentCenter, @"should be center");
}

- (void)testStringToTextDecoration {
    NSDictionary *lineThrough = [HMConverter HMStringToTextDecoration:@"line-through"];
    NSDictionary *underline = [HMConverter HMStringToTextDecoration:@"underline"];
    NSDictionary *nilValue = [HMConverter HMStringToTextDecoration:nil];
    
    XCTAssertEqualObjects(lineThrough, @{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)}, @"should equal");
    XCTAssertEqualObjects(underline, @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}, @"should equal");
    XCTAssertEqual(nilValue, @{}, @"should be equal");
}

- (void)testStringToBreakMode {
    NSLineBreakMode ellipsis = [HMConverter HMStringToBreakMode:@"ellipsis"];
    NSLineBreakMode nilValue = [HMConverter HMStringToBreakMode:nil];
    
    XCTAssertEqual(ellipsis, NSLineBreakByTruncatingTail, @"should equal");
    XCTAssertEqual(nilValue, NSLineBreakByClipping, @"should equal");
}

#pragma mark - font

- (void)testStringToFontWeight {
    UIFontWeight bold = [HMConverter HMStringToFontWeight:@"bold"];
    UIFontWeight nilValue = [HMConverter HMStringToFontWeight:nil];
    
    XCTAssertEqual(bold, UIFontWeightBold, @"should equal");
    XCTAssertEqual(nilValue, UIFontWeightRegular, @"should equal");
}

#pragma mark - keyboard

- (void)testStringToReturnKeyType {
    UIReturnKeyType done = [HMConverter HMStringToReturnKeyType:@"done"];
    UIReturnKeyType go = [HMConverter HMStringToReturnKeyType:@"go"];
    UIReturnKeyType next = [HMConverter HMStringToReturnKeyType:@"next"];
    UIReturnKeyType search = [HMConverter HMStringToReturnKeyType:@"search"];
    UIReturnKeyType send = [HMConverter HMStringToReturnKeyType:@"send"];
    UIReturnKeyType nilValue = [HMConverter HMStringToReturnKeyType:nil];
    
    XCTAssertEqual(done, UIReturnKeyDefault, @"should equal");
    XCTAssertEqual(go, UIReturnKeyGo, @"should equal");
    XCTAssertEqual(next, UIReturnKeyNext, @"should equal");
    XCTAssertEqual(search, UIReturnKeySearch, @"should equal");
    XCTAssertEqual(send, UIReturnKeySend, @"should equal");
    XCTAssertEqual(nilValue, UIReturnKeyDefault, @"should equal");
}

#pragma mark - basic

- (void)testNumberToCGFloat {
    CGFloat one = [HMConverter HMNumberToCGFloat:@(1.0)];
    CGFloat nilValue = [HMConverter HMNumberToCGFloat:nil];
    
    XCTAssertEqual(one, 1.0, @"should equal");
    XCTAssertEqual(nilValue, 0.0, @"should equal");
}

- (void)testNumberToNSInteger {
    NSInteger one = [HMConverter HMNumberToNSInteger:@(1.0)];
    NSInteger nilValue = [HMConverter HMNumberToNSInteger:nil];
    
    XCTAssertEqual(one, 1, @"should equal");
    XCTAssertEqual(nilValue, 0, @"should equal");
}

- (void)testStringToFloat {
    CGFloat one = [HMConverter HMStringToFloat:@"1.0dp"];
    CGFloat nilValue = [HMConverter HMStringToFloat:nil];

    XCTAssertEqual(one, 1.0, @"should equal");
    XCTAssertEqual(nilValue, 0, @"should equal");
}

- (void)testStringOrigin {
    NSString *string = [HMConverter HMStringOrigin:@"1234"];
    NSString *emptyValue = [HMConverter HMStringOrigin:@""];
    NSString *nilValue = [HMConverter HMStringOrigin:nil];
    
    XCTAssertEqualObjects(string, @"1234", @"should equal");
    XCTAssertEqualObjects(emptyValue, @"", @"should equal");
    XCTAssertNil(nilValue, @"should be nil");
}

#pragma mark - shadow

- (void)testStringToShadowAttributes {
    NSArray *attributes = [HMConverter HMStringToShadowAttributes:@"3dp 3dp 3dp #FFFFFF"];
    NSArray *emptyValue = [HMConverter HMStringToShadowAttributes:@""];
    NSArray *nilValue = [HMConverter HMStringToShadowAttributes:nil];
    
    UIColor *white = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    NSArray *shadow = @[@(3.0), @(3.0), @(3.0), white];
    XCTAssertEqualObjects(attributes, shadow, @"should equal");
    XCTAssertNil(emptyValue, @"should be nil");
    XCTAssertNil(nilValue, @"should be nil");
}

#pragma mark - view

- (void)testStringToViewHidden {
    BOOL hidden = [HMConverter HMStringToViewHidden:@"hidden"];
    BOOL visible = [HMConverter HMStringToViewHidden:@"visible"];
    BOOL nilValue = [HMConverter HMStringToViewHidden:nil];
    
    XCTAssertTrue(hidden, @"should be true");
    XCTAssertFalse(visible, @"should be false");
    XCTAssertFalse(nilValue, @"should be false");
}

- (void)testStringToClipSubviews {
    BOOL hidden = [HMConverter HMStringToClipSubviews:@"hidden"];
    BOOL visible = [HMConverter HMStringToClipSubviews:@"visible"];
    BOOL nilValue = [HMConverter HMStringToClipSubviews:nil];
    
    XCTAssertTrue(hidden, @"should be true");
    XCTAssertFalse(visible, @"should be false");
    XCTAssertFalse(nilValue, @"should be false");
}

- (void)testStringToContentMode {
    UIViewContentMode origin = [HMConverter HMStringToContentMode:@"origin"];
    UIViewContentMode contain = [HMConverter HMStringToContentMode:@"contain"];
    UIViewContentMode cover = [HMConverter HMStringToContentMode:@"cover"];
    UIViewContentMode stretch = [HMConverter HMStringToContentMode:@"stretch"];
    UIViewContentMode emptyValue = [HMConverter HMStringToContentMode:@""];
    UIViewContentMode nilValue = [HMConverter HMStringToContentMode:nil];
    
    XCTAssertEqual(origin, UIViewContentModeCenter, @"should equal");
    XCTAssertEqual(contain, UIViewContentModeScaleAspectFit, @"should equal");
    XCTAssertEqual(cover, UIViewContentModeScaleAspectFill, @"should equal");
    XCTAssertEqual(stretch, UIViewContentModeScaleToFill, @"should equal");
    XCTAssertEqual(emptyValue, UIViewContentModeCenter, @"should equal");
    XCTAssertEqual(nilValue, UIViewContentModeCenter, @"should equal");
}

#pragma mark - collection view

- (void)testStringToDirection {
    UICollectionViewScrollDirection vertical = [HMConverter HMStringToDirection:@"vertical"];
    UICollectionViewScrollDirection horizontal = [HMConverter HMStringToDirection:@"horizontal"];
    UICollectionViewScrollDirection nilValue = [HMConverter HMStringToDirection:nil];
    
    XCTAssertEqual(vertical, UICollectionViewScrollDirectionVertical, @"should equal");
    XCTAssertEqual(horizontal, UICollectionViewScrollDirectionHorizontal, @"should equal");
    XCTAssertEqual(nilValue, UICollectionViewScrollDirectionVertical, @"should equal");
}

@end
