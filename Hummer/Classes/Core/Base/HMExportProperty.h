//
//  HMExportProperty.h
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMExportProperty : NSObject

@property (nonatomic, strong) NSString *propName;
@property (nonatomic, assign) SEL propGetter;
@property (nonatomic, assign) SEL propSetter;

@end
