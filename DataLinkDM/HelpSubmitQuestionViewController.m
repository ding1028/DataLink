	//
//  HelpSubmitQuestionViewController.m
//  DataLinkDM
//
//  Created by BoHuang on 3/24/17.
//  Copyright © 2017 Yujin. All rights reserved.
//

#import "HelpSubmitQuestionViewController.h"
#import "AFNetworking.h"
#import "Globals.h"

@interface HelpSubmitQuestionViewController ()

@end

@implementation HelpSubmitQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.questionTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.questionTextView.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    self.questionTextView.layer.cornerRadius = 5;
    self.questionTextView.layer.borderWidth =0.5;
    self.questionTextView.clipsToBounds = YES;
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
- (IBAction)submitAction:(id)sender {
    NSString* question = self.questionTextView.text;
    NSString* phone = self.phoneTextView.text;
    [self serviceSubmitHelp:question withCallNumber:phone withMode:1];
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) serviceSubmitHelp:(NSString *)question  withCallNumber:(NSString *) callNumber withMode:(int) mode
{
    //g_token = @"dfsf";
    if([callNumber isEqualToString:@""]){
        [Globals showErrorDialog:@"Please input call number."];
        return;
    }
    if([question isEqualToString:@""]){
        [Globals showErrorDialog:@"Please input question."];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *serverurl = [ c_baseUrl stringByAppendingString:c_submitHelp];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *modeStr = [NSString stringWithFormat:@"%d",mode];
    [param setObject:modeStr forKey:@"sType"];
    [param setObject:callNumber forKey:@"phone"];
    [param setObject:question forKey:@"question"];
    [param setObject:mAccount.mId forKey:@"userId"];
    
    
    
    serverurl = [serverurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:serverurl parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         NSString* result =[receivedData valueForKey:@"result"];
         if(result && [result integerValue] == 200){
             [Globals showErrorDialog:@"Submit Success."];
         }
         
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         NSString *msg = nil;
         [Globals showErrorDialog:@"Connection Error."];
         
     }];
}


@end
