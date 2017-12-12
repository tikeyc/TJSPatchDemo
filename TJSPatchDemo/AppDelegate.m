//
//  AppDelegate.m
//  TJSPatchDemo
//
//  Created by ways on 2017/12/6.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "AppDelegate.h"

#import "LoginViewController.h"

#import "JSPathRequest.h"
#import "JPEngine.h"

//取消注释就是使用本地的js热更新文件，当前是使用从服务器下载的
#define JSPatch_Test

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initJSPatch];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [[LoginViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)initJSPatch {
    
    
    // 直接执行js
//    [JPEngine startEngine];
//        [JPEngine evaluateScript:@"\
//         var alertView = require('UIAlertView').alloc().init();\
//         alertView.setTitle('Alert');\
//         alertView.setMessage('AlertView from js'); \
//         alertView.addButtonWithTitle('OK');\
//         alertView.show(); \
//         "];
    
    // 从网络拉回js脚本执行
//    [JPEngine startEngine];
    //    [[[NSURLSession alloc] init] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cnbang.net/test.js"]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //        NSString *script = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //        [JPEngine evaluateScript:script];
    //    }];
    
    // 执行本地js文件
    /*
     NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"Resource/demo" ofType:@"js"];
     NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
     [JPEngine evaluateScript:script];
     */
    //APP启动时下载热更新脚本
#ifdef JSPatch_Test
    [JPEngine startEngine];
    //如果是模块化开发(需要include导入js文件的时候)使用[JPEngine evaluateScriptWithPath:sourcePath];方法执行js文件
    NSString *sourcePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Resource/demo.js"];
    [JPEngine evaluateScriptWithPath:sourcePath];
#else
    //执行下载下来的js文件
    [JPLoader run];
    
    //下载模块化js文件
    [JSPathRequest loadServiceJSZip];
    //下载单个js文件
    [JSPathRequest loadServiceScriptString];
#endif

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    //app从后台返回前台时，重新下载热更新脚本
#ifdef JSPatch_Test
    [JPEngine startEngine];
    NSString *sourcePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"patchfile/1.0.js"];
    [JPEngine evaluateScriptWithPath:sourcePath];
#else
    //执行下载下来的js文件
    [JPLoader run];
    //下载模块化js文件
    [JSPathRequest loadServiceJSZip];
    //下载单个js文件
    [JSPathRequest loadServiceScriptString];
#endif
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
