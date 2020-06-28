//
//  UIView+Hummer.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMJSObject.h"

@interface UIView(Hummer) <HMJSObject>

@property (nonatomic, copy, setter=__setViewId:, getter=__viewId) NSString *viewId;

- (UIView *)getSubviewById:(NSString *)viewId;

@end
