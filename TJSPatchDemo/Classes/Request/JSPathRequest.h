//
//  JSPathRequest.h
//  TJSPatchDemo
//
//  Created by ways on 2017/12/12.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <Foundation/Foundation.h>

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


/**
 下载/更新脚本
 
 客户端在得知服务端脚本有更新时，调用 +updateToVersion:callback: 接口下载对应版本的脚本。至于如何得知服务端脚本更新可以自行定义，可以另外加个请求每次唤醒时询问服务器，也可以在 APP 原有的请求里加上这个信息。
 
 举个例子，客户端当前 App 版本号为 1.0，上述配置 rootUrl 变量配为 http://localhost/JSPatch/，服务端告诉客户端最新脚本版本号为2，于是调用 [JPLoader updateToVersion:2 callback:nil]，这时会去请求 http://localhost/JSPatch/1.0/v2.zip 这个文件并解压验证，保存到本地目录等待执行。
 
 ***下面是对照[JPLoader updateToVersion:2 callback:nil]方法自定义直接的下载单独js文件的方法
 */
+ (void)loadServiceScriptString;

@end
