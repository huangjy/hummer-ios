//
//  HMTextFiled.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMTextFiled.h"

#import "HMExportManager.h"
#import "HMAttrManager.h"
#import "HMConverter.h"
#import "JSValue+Hummer.h"
#import "NSObject+Hummer.h"
#import "HMUtility.h"
#import "HMInputEvent.h"
#import "UIView+HMEvent.h"

@interface HMTextFiled() <UITextFieldDelegate>

@property (nonatomic, strong) UIColor *caretColor;

@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, copy) NSString *fontFamily;

@property (nonatomic, strong) NSMutableDictionary *placeholderAttributes;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, assign) CGFloat placeholderFontSize;

@property (nonatomic, assign) NSInteger maxLength;

@property (nonatomic, copy) NSString *keyboardTypeString;

@end

@implementation HMTextFiled

HM_EXPORT_CLASS(Input, HMTextFiled)

HM_EXPORT_PROPERTY(text, __text, __setText:)
HM_EXPORT_PROPERTY(placeholder, placeholder, __setPlaceholder:)
HM_EXPORT_PROPERTY(focused, __focused, __setFocused:)

HM_EXPORT_ATTRIBUTE(type, keyboardTypeString, HMStringOrigin:)
HM_EXPORT_ATTRIBUTE(color, textColor, HMStringToColor:)
HM_EXPORT_ATTRIBUTE(cursorColor, caretColor, HMStringToColor:)
HM_EXPORT_ATTRIBUTE(textAlign, textAlignment, HMStringToTextAlignment:)
HM_EXPORT_ATTRIBUTE(fontFamily, fontFamily, HMStringOrigin:)
HM_EXPORT_ATTRIBUTE(placeholderColor, placeholderColor, HMStringToColor:)
HM_EXPORT_ATTRIBUTE(fontSize, fontSize, HMStringToFloat:)
HM_EXPORT_ATTRIBUTE(placeholderFontSize, placeholderFontSize, HMStringToFloat:)
HM_EXPORT_ATTRIBUTE(maxLength, maxLength, HMNumberToNSInteger:)
HM_EXPORT_ATTRIBUTE(returnKeyType, returnKeyType, HMStringToReturnKeyType:)

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _fontSize = 16.0;
        _placeholderFontSize = 16.0;
        _placeholderColor = [HMConverter HMStringToColor:@"#999999"];
        _placeholderAttributes = [[NSMutableDictionary alloc] init];
        _maxLength = NSUIntegerMax;
        self.delegate = self;
    }
    return self;
}

- (void)updateFont {
    UIFont *font;
    if (self.fontFamily) {
        font = [UIFont fontWithName:self.fontFamily size:self.fontSize];
    } else {
        font = [UIFont systemFontOfSize:self.fontSize];
    }
    self.font = font;
}

- (void)updatePlaceholderFont {
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder ?: @""
                                                                 attributes:self.placeholderAttributes];
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (self.placeholderAttributes) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                     attributes:self.placeholderAttributes];
    } else {
        [super setPlaceholder:placeholder];
    }
}

#pragma mark - Export Property

- (JSValue *)__text {
    return [JSValue valueWithObject:self.text inContext:self.jsContext];
}

- (void)__setText:(JSValue *)text {
    [self setText:[text toString]];
}

- (void)__setPlaceholder:(JSValue *)placeholder {
    [self setPlaceholder:[placeholder toString]];
}

- (JSValue *)__focused {
    return [JSValue valueWithBool:!self.isFirstResponder inContext:self.jsContext];
}

- (void)__setFocused:(JSValue *)focused {
    BOOL theFocused = [focused toBool];
    if (theFocused) {
        [self becomeFirstResponder];
    } else {
        [self resignFirstResponder];
    }
}

#pragma mark - Export Attribute

- (void)setKeyboardTypeString:(NSString *)string {
    NSDictionary *map = @{@"default": @(UIKeyboardTypeDefault),
                          @"number": @(UIKeyboardTypeNumberPad),
                          @"tel": @(UIKeyboardTypePhonePad),
                          @"email": @(UIKeyboardTypeEmailAddress),
                          };
    string = string ?: @"";
    UIKeyboardType type = UIKeyboardTypeDefault;
    if (map[string]) {
        type = [map[string] integerValue];
        self.secureTextEntry = NO;
    } else {
        self.secureTextEntry = [string isEqualToString:@"password"];
    }
    
    self.keyboardType = type;
}

- (void)setCaretColor:(UIColor *)caretColor {
    _caretColor = caretColor;
    self.tintColor = caretColor;
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self updateFont];
}

- (void)setFontFamily:(NSString *)fontFamily {
    _fontFamily = [fontFamily copy];
    [self updateFont];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderAttributes[NSForegroundColorAttributeName] = placeholderColor;
    [self updatePlaceholderFont];
}

- (void)setPlaceholderFontSize:(CGFloat)placeholderFontSize {
    _placeholderFontSize = placeholderFontSize;
    UIFont *font;
    if (self.fontFamily) {
        font = [UIFont fontWithName:self.fontFamily size:placeholderFontSize];
    } else {
        font = [UIFont systemFontOfSize:placeholderFontSize];
    }
    self.placeholderAttributes[NSFontAttributeName] = font;
    [self updatePlaceholderFont];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(__unused UITextField *)textField {
    JSValue *value = [JSValue valueWithClass:[HMInputEvent class]
                                      inContext:self.jsContext];
    NSDictionary *dict = @{kHMInputState:@(HMInputEventBegan),
                           kHMInputText:self.text?:@""};
    [self hm_notifyEvent:HMInputEventName withValue:value withArgument:dict];
}

- (void)textFieldDidEndEditing:(__unused UITextField *)textField {
    JSValue *value = [JSValue valueWithClass:[HMInputEvent class]
                                      inContext:self.jsContext];
    NSDictionary *dict = @{kHMInputState:@(HMInputEventEnded),
                           kHMInputText:self.text?:@""};
    [self hm_notifyEvent:HMInputEventName withValue:value withArgument:dict];
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    if (self.maxLength == 0 || textField.text.length < range.location + range.length) return NO;
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length <= self.maxLength ||
        newString.length < textField.text.length) {
        JSValue *value = [JSValue valueWithClass:[HMInputEvent class] inContext:self.jsContext];
        NSDictionary *dict = @{kHMInputState:@(HMInputEventChanged),
                               kHMInputText:newString?:@""};
        [self hm_notifyEvent:HMInputEventName withValue:value withArgument:dict];
    }
    
    return newString.length <= self.maxLength ||
           newString.length < textField.text.length;
}

@end
