# TJSPatchDemo
iOS热更新

#### iOS热更新实现方式     
http://www.jianshu.com/p/00111d447e7e     


```

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
    NSString *sourcePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Resource/main.js"];
    [JPEngine evaluateScriptWithPath:sourcePath];
#else
    //执行下载下来的js文件
    [JPLoader run];
    
    //下载模块化js zip文件
    [JSPathRequest loadServiceJSZip];
    //下载单个js文件
    //[JSPathRequest loadServiceScriptString];
#endif


```
