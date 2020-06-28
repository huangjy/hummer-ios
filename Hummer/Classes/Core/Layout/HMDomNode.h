//
//  HMDomNode.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMDomNode<NSObject>

@property (nonatomic, readonly) NSDictionary *style;
@property (nonatomic, readonly) NSDictionary *attribute;

+ (instancetype)nodeForView:(UIView *)view;

- (void)configureLayout:(NSDictionary *)domStyle;

- (void)configureAttribute:(NSDictionary *)domAttr;

@end

@interface HMDomNode : NSObject<HMDomNode>

@end
