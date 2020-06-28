//
//  HMConfigure.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMConfigure : NSObject

@property (nonatomic, strong) NSString *rootDir;    // default is [NSBundle mainBundle].bundlePath
@property (nonatomic, assign) CGFloat deviceWidth;  // default is portrait: 750.0f, landscape : 1240.0f;
@property (nonatomic, assign) CGFloat calRatio;     // default is deviceWidth / [UIScreen mainScreen].bounds.size.width
@property (nonatomic, assign) CGFloat deviceHeight; // default is [UIScreen mainScreen].bounds.size.height * calRatio
@property (nonatomic, assign) NSInteger orientation;// default is UIDeviceOrientationPortrait

+ (instancetype)sharedInstance;

@end
