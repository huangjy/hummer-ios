//
//  HMImageView.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "HMImageView.h"
#import "HMExportManager.h"
#import "HMAttrManager.h"
#import "HMConverter.h"
#import "JSValue+Hummer.h"
#import "NSObject+Hummer.h"
#import "HMUtility.h"
#import "HMInterceptor.h"

@interface HMImageView()

@property (nonatomic, copy) NSString *imageSrc;

@end

@implementation HMImageView

HM_EXPORT_CLASS(Image, HMImageView)

HM_EXPORT_PROPERTY(src, src, setSrc:)

HM_EXPORT_ATTRIBUTE(resize, contentMode, HMStringToContentMode:)

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeCenter;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - Export Property

- (NSString *)src {
    return self.imageSrc;
}

- (void)setSrc:(JSValue *)src {
    self.imageSrc = [src.toString copy];
    NSString *imageSrc = [src.toString copy];
    if ([imageSrc hasPrefix:@"http"] ||
        [imageSrc hasPrefix:@"https"] ) {
        NSURL *imgURL = [NSURL URLWithString:imageSrc];
        [self loadImageWithURL:imgURL];
    } else {
        self.image = HMImageFromLocalAssetName(imageSrc);
    }
}

#pragma mark - Export Method

- (void)loadImageWithURL:(NSURL *)url {
    
    NSArray *interceptors = Interceptor(@protocol(HMWebImageProtocol));
    if(interceptors.count > 0) {
        for(id<HMWebImageProtocol> interceptor in interceptors){
            if ([interceptor respondsToSelector:@selector(setImageView:withURL:placeholderImage:)]) {
                [interceptor setImageView:self withURL:url placeholderImage:@""];
            }
        }
    } else {
        __weak typeof(self) weakSelf = self;
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url
                                                                     completionHandler:^(NSData * _Nullable data,
                                                                                         NSURLResponse * _Nullable response,
                                                                                         NSError * _Nullable error) {
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.image = image;
            });
        }];
        [dataTask resume];
    }
}

@end
