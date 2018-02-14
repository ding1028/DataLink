//
//  LoginViewController.m
//  DataLinkDM
//
//  Created by BoHuang on 9/8/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import "LoginViewController.h"
#import "AgreeViewController.h"
#import "Globals.h"
#import "AFNetworking.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize btnClose;
@synthesize btnLogin;
@synthesize editPassword;
@synthesize editUserName;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.btnClose addTarget:self action:@selector(closeScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLogin addTarget:self action:@selector(actionLogin) forControlEvents:UIControlEventTouchUpInside];
    
    [Globals loadUserInfo];
    //self.editPassword.text = @"qqqqqq";
    //self.editUserName.text = @"Yujin";
}
-(void) closeScreen
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         
     }];
}
-(void) actionLogin
{
    NSString *strUser = editUserName.text;
    NSString *strPassword = editPassword.text;
    if ([strUser isEqualToString:@""])
    {
        [Globals showErrorDialog:@"Input UserName"];
        return;
    }
    if ([strPassword isEqual:@""])
    {
        [Globals showErrorDialog:@"Input Password"];
        return;
    }
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

@end
