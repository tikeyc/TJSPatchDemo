//
//  LoginViewController.m
//  TJSPatchDemo
//
//  Created by ways on 2017/12/12.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "LoginViewController.h"

#import "PPNetworkHelper.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UIButton *loginButton;


- (IBAction)loginButtonClick:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButtonClick:(UIButton *)sender {
    
    [self loginRequest];
}


- (void)loginRequest {
    
    NSString *url = [NSString stringWithFormat:@""];
    NSDictionary *parameters = [[NSDictionary alloc] init];
    //假设当此处出现BUG(url的密码用户输入了特殊字符：&\\//等时)，需要对url进行NSUTF8StringEncoding处理
    //url = [url stringByRemovingPercentEncoding]; 在js文件中实现
    
    [PPNetworkHelper GET:url parameters:parameters success:^(id responseObject) {
        //假设当此处出现BUG，需要对responseObject进行别的处理时，在js文件中处理
        
        self.view.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]].instantiateInitialViewController;
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
}


@end
