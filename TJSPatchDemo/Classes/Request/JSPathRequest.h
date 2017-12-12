//
//  JSPathRequest.h
//  TJSPatchDemo
//
//  Created by ways on 2017/12/12.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSPathRequest : NSObject 

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
+ (void)loadServiceJSZip;


+ (void)loadServiceScriptString;

@end
