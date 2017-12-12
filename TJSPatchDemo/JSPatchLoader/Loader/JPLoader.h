//
//  JSPatch.h
//  JSPatch
//
//  Created by bang on 15/11/14.
//  Copyright (c) 2015 bang. All rights reserved.
//

#import <Foundation/Foundation.h>

//设 JPLoader.h 的 rootUrl 为你的服务器地址。
//脚本打包后的文件在服务器的存放路径是 ${rootUrl}/${appVersion}/${patchFile}
const static NSString *rootUrl = @"http://localhost/JSPatch/";
static NSString *publicKey = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC/+7Bq4i8Xf86Vv1MwnH9CcvRehsG0Bndtzir8TdmDy5ihW0ZuyAie5IIb8uLP2SlnHVfFd6B/fGibcUtvOt0x/cZjXFQ5j3eHxSUn1aQvJnCIhisRgC5dtE1xAI/GndP/68B6MSfLaSWKdIxmE+b4en6nhcFutuLZtSjg0zFX2wIDAQAB\n-----END PUBLIC KEY-----";

typedef void (^JPUpdateCallback)(NSError *error);

typedef enum {
    JPUpdateErrorUnzipFailed = -1001,
    JPUpdateErrorVerifyFailed = -1002,
} JPUpdateError;

@interface JPLoader : NSObject
+ (BOOL)run;
+ (void)updateToVersion:(NSInteger)version callback:(JPUpdateCallback)callback;
+ (void)runTestScriptInBundle;
+ (void)setLogger:(void(^)(NSString *log))logger;
+ (NSInteger)currentVersion;
@end
