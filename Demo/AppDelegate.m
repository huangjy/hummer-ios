//
//  AppDelegate.m
//  Hummer
//
//  Copyright © 2019年 huangjy. All rights reserved.
//

#import "AppDelegate.h"
#import "HMExportManager.h"
#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "Hummer.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Hummer startEngine:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ViewController *vc = [[ViewController alloc] init];
    self.controller = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window.rootViewController = self.controller;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
