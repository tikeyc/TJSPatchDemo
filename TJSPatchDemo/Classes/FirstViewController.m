//
//  FirstViewController.m
//  TJSPatchDemo
//
//  Created by ways on 2017/12/6.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[self addSubView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - init

//- (void)addSubView {
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 200, 44)];
//    button.backgroundColor = [UIColor redColor];
//    [button setTitle:@"JSPatch" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//}

- (void)buttonClick:(UIButton *)button {
    NSLog(@"buttonClick");
    
}

@end
