//
//  SecondViewController.m
//  TJSPatchDemo
//
//  Created by ways on 2017/12/6.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "SecondViewController.h"

#import "JPEngine.h"
#import "TJSPatchDemo-Swift.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 执行本地js文件
    //如果是模块化开发(需要include导入js文件的时候)使用[JPEngine evaluateScriptWithPath:sourcePath];方法执行js文件
    NSString *sourcePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Resource/demo-swift.js"];
    [JPEngine evaluateScriptWithPath:sourcePath];
    
    [self addSubView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - init

- (void)addSubView {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 200, 44)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"JSPatch-Swift" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick:(UIButton *)button {
    NSLog(@"buttonClick");
    
    TableViewController *table = [[TableViewController alloc] init];
    [self.navigationController pushViewController:table animated:YES];
}


@end
