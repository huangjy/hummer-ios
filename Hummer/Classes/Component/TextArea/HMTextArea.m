//
//  HMTextArea.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMTextArea.h"
#import "HMExportManager.h"
#import "HMAttrManager.h"
#import "HMConverter.h"
#import "JSValue+Hummer.h"
#import "NSObject+Hummer.h"
#import "HMUtility.h"
#import "HMInputEvent.h"
#import "UIView+HMEvent.h"

@interface HMTextArea() <UITextViewDelegate>

@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, copy) NSString *fontFamily;
@property (nonatomic, strong) UIColor *caretColor;
@property (nonatomic, strong) NSMutableDictionary *placeholderAttributes;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, assign) CGFloat placeholderFontSize;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, assign) NSInteger numberOfLines;
@property (nonatomic, copy) NSString *keyboardTypeString;

@end

@implementation HMTextArea

HM_EXPORT_CLASS(TextArea, HMTextArea)

HM_EXPORT_PROPERTY(text, __text, __setText:)
HM_EXPORT_PROPERTY(placeholder, __placeholder, __setPlaceholder:)
HM_EXPORT_PROPERTY(focused, __focused, __setFocused:)

HM_EXPORT_ATTRIBUTE(type, keyboardTypeString, HMStringOrigin:)
HM_EXPORT_ATTRIBUTE(color, textColor, HMStringToColor:)
HM_EXPORT_ATTRIBUTE(cursorColor, caretColor, HMStringToColor:)
HM_EXPORT_ATTRIBUTE(textAlign, textAlignment, HMStringToTextAlignment:)
HM_EXPORT_ATTRIBUTE(fontFamily, fontFamily, HMStringOrigin:)
HM_EXPORT_ATTRIBUTE(fontSize, fontSize, HMStringToFloat:)
HM_EXPORT_ATTRIBUTE(placeholderColor, placeholderColor, HMStringToColor:)
HM_EXPORT_ATTRIBUTE(placeholderFontSize, placeholderFontSize, HMStringToFloat:)
HM_EXPORT_ATTRIBUTE(maxLength, maxLength, HMNumberToNSInteger:)
HM_EXPORT_ATTRIBUTE(returnKeyType, returnKeyType, HMStringToReturnKeyType:)
HM_EXPORT_ATTRIBUTE(textLineClamp, numberOfLines, HMNumberToNSInteger:)

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        _fontSize = 12.0;
        _placeholderAttributes = [[NSMutableDictionary alloc] init];
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.textColor = [HMConverter HMStringToColor:@"#757575"];
        self.fontSize = 16.0;
        self.placeholderFontSize = 16.0;
        _maxLength = NSUIntegerMax;
        _numberOfLines = NSUIntegerMax;
        self.textColor = [UIColor blackColor];
        [self addSubview:_placeholderLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIView *textContainerView = self.subviews.firstObject;
    CGRect containerFrame = textContainerView.frame;
    CGFloat xOffset = 4.0;
    CGRect frame = CGRectMake(containerFrame.origin.x + xOffset,
                              containerFrame.origin.y,
                              containerFrame.size.width - xOffset,
                              containerFrame.size.height);
    self.placeholderLabel.frame = frame;
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

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    if (self.placeholderAttributes) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                     attributes:self.placeholderAttributes];
        self.placeholderLabel.attributedText = self.attributedPlaceholder;
    } else {
        self.placeholderLabel.text = placeholder;
    }
}

- (void)updatePlaceholderFont {
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder ?: @""
                                                                 attributes:self.placeholderAttributes];
    self.placeholderLabel.attributedText = self.attributedPlaceholder;
}

#pragma mark - Export Property

- (JSValue *)__text {
    return [JSValue valueWithObject:self.text inContext:self.jsContext];
}

- (void)__setText:(JSValue *)text {
    [self setText:[text toString]];
}

- (JSValue *)__placeholder {
    return [JSValue valueWithObject:self.placeholder inContext:self.jsContext];
}

- (void)__setPlaceholder:(JSValue *)placeholder {
    self.placeholder = [placeholder toString];
    self.placeholderLabel.text = self.placeholder;
}

- (JSValue *)__focused {
    return [JSValue valueWithBool:self.isFirstResponder inContext:self.jsContext];
}

- (void)__setFocused:(JSValue *)focused {
    BOOL theFocused = [focused toBool];
    if (theFocused) {
        [self becomeFirstResponder];
    } else {
        [self resignFirstResponder];
    }
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self updateFont];
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

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    self.placeholderLabel.textAlignment = textAlignment;
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

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(__unused UITextView *)textView {
    JSValue *value = [JSValue valueWithClass:[HMInputEvent class] inContext:self.jsContext];
    NSDictionary *dict = @{kHMInputState:@(HMInputEventBegan), kHMInputText:self.text?:@""};
    [self hm_notifyEvent:HMInputEventName withValue:value withArgument:dict];
}

- (void)textViewDidEndEditing:(__unused UITextView *)textView {
    JSValue *value = [JSValue valueWithClass:[HMInputEvent class] inContext:self.jsContext];
    NSDictionary *dict = @{kHMInputState:@(HMInputEventEnded), kHMInputText:self.text?:@""};
    [self hm_notifyEvent:HMInputEventName withValue:value withArgument:dict];
}

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(nonnull NSString *)text {
    if (self.maxLength == 0 || textView.text.length < range.location + range.length) return NO;

    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    BOOL isOverMaxLength = newString.length > self.maxLength;
    
    NSUInteger maxNumberOfLines = self.numberOfLines;
    CGFloat limitWidth = textView.textContainer.size.width - textView.textContainer.lineFragmentPadding*2;
    CGSize newSize = [newString boundingRectWithSize:CGSizeMake(limitWidth, MAXFLOAT)
                                             options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                          attributes:@{NSFontAttributeName:self.font}
                                             context:nil].size;
    NSUInteger numLines = ceil(newSize.height)/textView.font.lineHeight;
    BOOL isOverMaxLine = numLines > maxNumberOfLines;
    
    BOOL shouldInput = !isOverMaxLine && !isOverMaxLength;
    
    if (shouldInput) {
        JSValue *value = [JSValue valueWithClass:[HMInputEvent class] inContext:self.jsContext];
        NSDictionary *dict = @{kHMInputState:@(HMInputEventChanged), kHMInputText:newString?:@""};
        [self hm_notifyEvent:HMInputEventName withValue:value withArgument:dict];
    }

    return shouldInput;
}

@end
