//
//  TestController.m
//  Demo
//
//  Copyright © 2019 huangjy. All rights reserved.
//

#import "TestController.h"
#import "Hummer.h"
#import "CommonDefines.h"

@interface TestController ()
@property (nonatomic, strong) HMJSContext *context;
@end

@implementation TestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.fileName;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.context = [Hummer contextWithView:self.view];
    [self loadScriptFile:self.fileName];
}

- (void)loadScriptFile:(NSString *)fileName
{
    NSString *url = [NSString stringWithFormat:@"http://%@:9292/%@", LOCAL_IPADDR, fileName];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *script = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [weakSelf.context evaluateScript:script fileName:fileName];
        });
    }];
    [task resume];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
