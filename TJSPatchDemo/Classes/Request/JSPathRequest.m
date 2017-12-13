//
//  JSPathRequest.m
//  TJSPatchDemo
//
//  Created by ways on 2017/12/12.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "JSPathRequest.h"

#import "RSA.h"
#import "JPLoader.h"
#import "JPEngine.h"

//获取版本号
#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleShortVersionString"]

#define App_load_js_zip_version @"App_load_js_zip_version"

#define App_load_js_version @"App_load_js_version"
#define Script_string_cache @"Script_string_cache"

/**
 ***使用流程是：
 1-通过 tools/pack.php 这个脚本打包需要下发的文件。
 2-手动上传打包后的文件到自己的服务器指定位置（${rootUrl}/${appVersion}/${patchFile}）
 3-客户端调用相关接口下载/执行上述脚本文件。
 
 ***脚本打包
 1-JSPatch 脚本文件规则：可以有多个 js 文件，脚本内可以调用 include() 接口包含，没有目录层级，必须包含一个 main.js 文件作为入口。
 
 2-在命令行使用 Loader/tools/pack.php 脚本打包 JS 文件，由用户放到自己的服务器上给客户端下载。
 
 ***示例
 终端输入命令一:$ php pack.php main.js other.js
 会在当前目录生成 v1.zip 文件，打包了所有 js 文件并包含了校验文件。也可以在最后通过 -o 指定输出文件名：
 
 终端输入命令二:$ php pack.php main.js -o v2
 脚本文件名代表当前 patch 版本，与后续的 +updateToVersion:callback: 接口相关。
 */
@implementation JSPathRequest

/**注意 JSPatch Loader 只处理脚本校验，防止传输过程被第三方篡改，但不会对脚本内容进行加密传输和存储，对脚本内容有加密需求的可以自行加上加密逻辑。
 
 ***下载/更新脚本
 
 客户端在得知服务端脚本有更新时，调用 +updateToVersion:callback: 接口下载对应版本的脚本。
 至于如何得知服务端脚本更新可以自行定义，可以另外加个请求每次唤醒时询问服务器，也可以在 APP 原有的请求里加上这个信息。
 
 举个例子，客户端当前 App 版本号为 1.0，上述配置 rootUrl 变量配为 http://localhost/JSPatch/，服务端告诉客户端最新脚本版本号为2，
 于是调用 [JPLoader updateToVersion:2 callback:nil]，这时会去请求 http://localhost/JSPatch/1.0/v2.zip 这个文件并解压验证，保存到本地目录等待执行。
 
 ***执行脚本
 
 通过 +run 接口执行已下载到本地的 JSPatch 脚本文件，
 建议在程序启动的 -application:didFinishLaunchingWithOptions: 里第一句调用这个接口，
 防止调用后执行 JSPatch 脚本过程中其他线程同时在执行相关代码，导致意想不到的问题。
 */
+ (void)loadServiceJSZip {
    //1.先获取服务器脚本版本号
    NSString *patchURLString = [NSString stringWithFormat:@"%@/getCurrentJSVersion?",rootUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:patchURLString]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setTimeoutInterval:20];
    [urlRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@", response);
        
        NSError *error1;
        NSDictionary *responseResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error1];
        if (!error1) {
            NSString *js_version_cache = [[NSUserDefaults standardUserDefaults] objectForKey:App_load_js_zip_version];
            if (!js_version_cache || [js_version_cache isEqualToString:@""]) {//为空说明第一次请求，设置为0
                js_version_cache = @"0";
            }
            //服务器脚本版本号
            NSInteger js_version = [responseResult[@"js_version"] integerValue];
            
            //服务器脚本版本号与上次保存不一致说明要服务器更新了zip文件，需要重新加载获取
            if ([js_version_cache integerValue] != js_version) {
                //下载使用packer.php打包js后上传至服务器的zip压缩文件
                [JPLoader updateToVersion:js_version callback:^(NSError *error) {
                    if (error) {
                        NSLog(@"JPLoader_updateToVersion_error:%@",error.description);
                    } else {
                        //下载成功后在缓存当前js_version
                        [[NSUserDefaults standardUserDefaults] setObject:[@(js_version) stringValue] forKey:App_load_js_zip_version];
                        //执行下载下来的js文件
                        [JPLoader run];
                    }
                }];
            }
            
        }
    }];
    
    [task resume];
}

/**
 下载/更新脚本
 
 客户端在得知服务端脚本有更新时，调用 +updateToVersion:callback: 接口下载对应版本的脚本。至于如何得知服务端脚本更新可以自行定义，可以另外加个请求每次唤醒时询问服务器，也可以在 APP 原有的请求里加上这个信息。
 
 举个例子，客户端当前 App 版本号为 1.0，上述配置 rootUrl 变量配为 http://localhost/JSPatch/，服务端告诉客户端最新脚本版本号为2，于是调用 [JPLoader updateToVersion:2 callback:nil]，这时会去请求 http://localhost/JSPatch/1.0/v2.zip 这个文件并解压验证，保存到本地目录等待执行。
 
 ***下面是对照[JPLoader updateToVersion:2 callback:nil]方法自定义直接的下载单独js文件的方法
 */
+ (void)loadServiceScriptString {
    
    //获取上次储存的version(请求头中获取)和js内容
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:App_load_js_version];
    NSString *oldScript = [[NSUserDefaults standardUserDefaults] objectForKey:Script_string_cache];
    
    //上次储存的js内容不为空，直接加载
    if (oldScript && ![oldScript isEqualToString:@""]) {
        NSLog(@"执行本地沙盒的热更新脚本");
        [JPEngine evaluateScript:oldScript];
    }
    
    //version为空设为0
    if (!version || [version isEqualToString:@""]) {
        version = @"v0";
    }
    
    //构造请求地址，并传参数version
    NSString *patchURLString = [NSString stringWithFormat:@"%@/%@?v=%@.js",rootUrl,AppVersion,version];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:patchURLString]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setTimeoutInterval:20];
    [urlRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@", response);
        
        //获取请求头中的version并储存
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSDictionary *allHeaderFields = httpResponse.allHeaderFields;
        NSString *newversion = [allHeaderFields objectForKey:@"js_version"];
        [[NSUserDefaults standardUserDefaults] setObject:newversion forKey:App_load_js_version];
        
        //加密的js脚本
        NSString *script = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        //获取请求到的内容并解密，然后储存
        NSString *newscript = [RSA decryptString:script publicKey:publicKey];
        
        if(newscript && ![newscript isEqualToString:@""]) {
            [[NSUserDefaults standardUserDefaults] setObject:newscript forKey:Script_string_cache];
            //加载js内容
            NSLog(@"执行热更新脚本");
            [JPEngine evaluateScript:newscript];
        }
    }];
    
    [task resume];
}

@end
