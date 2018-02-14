//
//  HelpViewController.m
//  DataLinkDM
//
//  Created by Twinklestar on 12/16/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import "HelpViewController.h"
#import "AFNetworking.h"
#import "HelpSubmitCallViewController.h"
#import "HelpSubmitQuestionViewController.h"
#import "Globals.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.btnHelpBack addTarget:self action:@selector(closeScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.btnHelpCall addTarget:self action:@selector(callClick) forControlEvents:UIControlEventTouchUpInside];
    [self.btnHelpQuestion addTarget:self action:@selector(questionClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) closeScreen
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         
     }];
}

-(void) callClick
{
    HelpSubmitCallViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpSubmitCallViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void) questionClick
{
    HelpSubmitQuestionViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpSubmitQuestionViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
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
