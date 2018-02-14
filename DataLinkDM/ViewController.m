//
//  ViewController.m
//  DataLinkDM
//
//  Created by BoHuang on 9/8/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "Globals.h"
#import "AFNetworking.h"
#import "AgreeViewController.h"
#import "HomeViewController.h"		

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    lstActions = [[NSMutableArray alloc] init];
    lstAlerts = [[NSMutableArray alloc] init];
    [self.btnMainLogin addTarget:self action:@selector(loginScreen) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
    NSString *isRemeber = [preference objectForKey:@"isremember"];
    
    
    [self.btnRemeber setImage:[UIImage imageNamed:@"chk_active.png"] forState:UIControlStateSelected];
    [self.btnRemeber setImage:[UIImage imageNamed:@"chk_normal.png"] forState:UIControlStateNormal];

    
    if (isRemeber == nil || [isRemeber isEqualToString:@"1"])
    {
        self.btnRemeber.selected = true;
        NSString *strEmail = [preference objectForKey:@"name"];
        NSString *strPassword = [preference objectForKey:@"password"];
        self.editPassword.text = strPassword;
        self.editEmail.text = strEmail;
    }
    else{
        self.editEmail.text = @"";
        self.editPassword.text = @"";

        self.btnRemeber.selected = false;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) loginScreen
{
    /*LoginViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:viewController animated:YES completion:nil];*/
    
    NSString *strUser = self.editEmail.text;
    NSString *strPassword = self.editPassword.text;
    if ([strUser isEqualToString:@""])
    {
        [Globals showErrorDialog:@"Input Email"];
        return;
    }
    if ([strPassword isEqual:@""])
    {
        [Globals showErrorDialog:@"Input Password"];
        return;
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [self serviceLogin:strUser withPassword:strPassword];
 
}
- (IBAction)rememberChanged:(id)sender {
    self.btnRemeber.selected = !self.btnRemeber.selected;
    NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
    [preference setValue:self.btnRemeber.selected?@"1":@"0" forKey:@"isremember"];
}

-(void) serviceGetUnreadNotifications:(NSString*) userId withGuid:(NSString*) guid {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *serverurl = [[[[[ c_baseUrl stringByAppendingString:c_getMessagesUrl]
                                  stringByAppendingString:@"?uid="]
                                 stringByAppendingString:userId]
                                stringByAppendingString:@"&guid="]
                               stringByAppendingString:guid];
    [Globals showIndicator:self];
    serverurl = [serverurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:serverurl parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
       

            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
         
             for(NSDictionary* notificationData in receivedData) {
                 [appDelegate processNotification:notificationData];
                 
             }

         [Globals stopIndicator:self];
         
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         NSString *msg = nil;
         [Globals stopIndicator:self];
         [Globals showErrorDialog:@"Login Error"];
         
         
     }];

}

-(void) serviceSMTP{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *serverurl = [[[[[ c_baseUrl stringByAppendingString:c_smtp]
                              stringByAppendingString:@"?uid="]
                             stringByAppendingString:mAccount.mId]
                            stringByAppendingString:@"&email="]
                           stringByAppendingString:mAccount.mEmailAccount];
    
    serverurl = [serverurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         @try {
             NSArray *receivedData = responseObject;
             NSDictionary *setting = receivedData[0];
             if([setting objectForKey:@"hostname"] != nil)
                 mAccount.mEmailHostName =  [setting objectForKey:@"hostname"];
             if([setting objectForKey:@"port"] != nil)
                 mAccount.mEmailPort = [setting objectForKey:@"port"];
             if([setting objectForKey:@"authtype"] != nil)
                 mAccount.mEmailAuthType = [setting objectForKey:@"authtype"];
             
             [Globals saveUserInfo];
             
             
         } @catch (NSException *exception) {
             
         } @finally {
             
         }
         
         
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         NSString *msg = nil;
         // [Globals showErrorDialog:@"Error"];
         
     }];

}

-(void) serviceLogin:(NSString *) user withPassword:(NSString *) pass
{
    //g_token = @"dfsf";
    if(g_token == nil) g_token = @"token";
    [Globals showIndicator:self];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *serverurl = [[[[[[[[[ c_baseUrl stringByAppendingString:c_loginUrl]
                                stringByAppendingString:@"?user="]
                               stringByAppendingString:user]
                              stringByAppendingString:@"&password="]
                             stringByAppendingString:pass]
                            stringByAppendingString:@"&deviceToken="]
                           stringByAppendingString:g_token]
                            stringByAppendingString:@"&deviceType="] stringByAppendingString:@"2"];
    
    serverurl = [serverurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:serverurl parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;

        
         
         NSString *status = [receivedData objectForKey:@"result"];
         if(status == nil){
             mAccount = [[UserModel alloc] init];
             NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
             [Globals loadUserInfo];
             BOOL isFirstRun = YES;
             if(mAccount.mId != nil){
                 isFirstRun = NO;
             }
             isFirstAppRun = isFirstRun;
             
             long uId =[[receivedData objectForKey:@"id"] integerValue];
             
             mAccount.mId = [NSString stringWithFormat:@"%ld",uId];
             mAccount.mGuid = [receivedData objectForKey:@"guid"];
             mAccount.mName = [receivedData objectForKey:@"name"];
             mAccount.mEmail = [receivedData objectForKey:@"email"];
             int smtp = [[receivedData objectForKey:@"getsmtp"] intValue];
             mAccount.mGetSmtp =[NSString stringWithFormat:@"%d",smtp];
             mAccount.mPassword = pass;
             if (self.btnRemeber.selected) mAccount.isRemeber = @"1";
             else mAccount.isRemeber = @"0";
             [Globals saveUserAccount];
             [preference setObject:@"1" forKey:@"login"];
             [preference synchronize];
             
             if([mAccount.mGetSmtp isEqualToString:@"1"]) {
                 if(mAccount.mEmailAccount == nil || [mAccount.mEmailAccount isEqualToString:@""]) {
                     mAccount.mEmailAccount = mAccount.mEmail;
                 }
                 [self serviceSMTP];
                 
             }
             /*if(isFirstRun){
                 AgreeViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AgreeViewController"];
                 [self presentViewController:viewController animated:YES completion:nil];
             } else {*/
                 HomeViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeViewController"];
                 [self presentViewController:viewController animated:YES completion:nil];
             //}
             
        
             

             [Globals stopIndicator:self];
             [self serviceGetUnreadNotifications:mAccount.mId withGuid:mAccount.mGuid];
         }
         else
         {
             [Globals stopIndicator:self];
             [Globals showErrorDialog:@"Login Error"];
         }
         
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         NSString *msg = nil;
         [Globals stopIndicator:self];
         [Globals showErrorDialog:@"Login Error"];
         
     }];
}

@end
