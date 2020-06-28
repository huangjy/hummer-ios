//
//  HMLabel.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMLabel.h"
#import "HMExportManager.h"
#import "HMAttrManager.h"
#import "HMConverter.h"
#import "JSValue+Hummer.h"
#import "NSObject+Hummer.h"

@interface HMLabel()

@property (nonatomic, copy) NSDictionary *textDecoration;

@property (nonatomic, assign) bool textWrap;

@property (nonatomic, copy) NSString *fontFamily;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) UIFontWeight fontWeight;

@property (nonatomic, copy) NSString *formattedText;

@end

@implementation HMLabel

HM_EXPORT_CLASS(Text, HMLabel)

HM_EXPORT_PROPERTY(text, __text, __setText:)
HM_EXPORT_PROPERTY(formattedText, __formattedText, __setFormattedText:)

HM_EXPORT_ATTRIBUTE(color, textColor, HMStringToColor:)
HM_EXPORT_ATTRIBUTE(textAlign, textAlignment, HMStringToTextAlignment:)
HM_EXPORT_ATTRIBUTE(textDecoration, textDecoration, HMStringToTextDecoration:)
HM_EXPORT_ATTRIBUTE(fontFamily, fontFamily, HMStringOrigin:)
HM_EXPORT_ATTRIBUTE(fontSize, fontSize, HMStringToFloat:)
HM_EXPORT_ATTRIBUTE(fontWeight, fontWeight, HMStringToFontWeight:)
HM_EXPORT_ATTRIBUTE(textOverflow, lineBreakMode, HMStringToBreakMode:)
HM_EXPORT_ATTRIBUTE(textLineClamp, numberOfLines, HMNumberToNSInteger:)

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.numberOfLines = 0;
        _fontSize = 16;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (NSDictionary *)textAttributes {
    UIFont *font = self.font;
    UIColor *color = self.textColor;
    NSMutableDictionary *attributes = [@{NSFontAttributeName:font,
                                         NSForegroundColorAttributeName: color,
                                         } mutableCopy];
    [attributes addEntriesFromDictionary:self.textDecoration];
    return [attributes copy];
}

#pragma mark - Export Property

- (JSValue *)__text {
    return [JSValue valueWithObject:self.text inContext:self.jsContext];
}

- (void)__setText:(JSValue *)value {
    NSString *text = nil;
    if (value.isString) {
        text = [value toString];
    }
    
    if (self.textDecoration) {
        self.attributedText = [[NSMutableAttributedString alloc] initWithString:text ?: @""
                                                                     attributes:self.textAttributes];
    } else {
        self.text = text;
    }
    [self.yoga markDirty];
}

- (JSValue *)__formattedText {
    return [JSValue valueWithObject:self.formattedText inContext:self.jsContext];
}

- (void)__setFormattedText:(JSValue *)value {
    self.formattedText = [value toString];
    NSData *data = [self.formattedText dataUsingEncoding:NSUnicodeStringEncoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:data
                                                                   options:options
                                                        documentAttributes:nil
                                                                     error:nil];
    self.attributedText = attrStr;
}

#pragma mark - Export Attribute

- (void)setTextDecoration:(NSDictionary *)textDecoration {
    _textDecoration = [textDecoration copy];

    NSString *string = self.text ?: @"";
    NSDictionary *attributes = [self textAttributes];
    self.attributedText = [[NSMutableAttributedString alloc] initWithString:string
                                                                 attributes:attributes];
}

- (void)setFontFamily:(NSString *)fontFamily {
    _fontFamily = [fontFamily copy];
    [self updateFont];
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self updateFont];
}

- (void)setFontWeight:(UIFontWeight)fontWeight {
    _fontWeight = fontWeight;
    [self updateFont];
}

- (void)setTextAlign:(NSTextAlignment)textAlign {
    self.textAlignment = textAlign;
}

- (void)updateFont {
    UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc] init];
    if (_fontWeight) {
        UIFontDescriptorSymbolicTraits traits = fontDescriptor.symbolicTraits;
        traits = traits | UIFontDescriptorTraitBold;
        fontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:traits];
    }
    
    if (_fontFamily) {
        fontDescriptor = [fontDescriptor fontDescriptorByAddingAttributes:@{UIFontDescriptorFamilyAttribute:_fontFamily}];
    }
    
    UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:_fontSize];
    self.font = font;
}

@end
