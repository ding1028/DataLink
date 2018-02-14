//
//  InstallViewController.m
//  DataLinkDM
//
//  Created by Twinklestar on 12/16/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import "InstallViewController.h"
#import "Globals.h"

@interface InstallViewController ()

@end

@implementation InstallViewController
NSMutableArray *lstEmailProvider;
- (void)viewDidLoad {
    [super viewDidLoad];
    if((mAccount.mEmailAccount == nil || [mAccount.mEmailAccount isEqualToString:@""]) && mAccount.mEmail != nil)
        mAccount.mEmailAccount = mAccount.mEmail;
    if(mAccount.mEmailAccount != nil)
        self.txtEmail.text = mAccount.mEmailAccount;
    if(mAccount.mEmailPassword != nil)
        self.txtPassword.text = mAccount.mEmailPassword;
    //if(mAccount.mEmailProvider != nil)
    //    self.txtProvider.text = mAccount.mEmailProvider;
    lstEmailProvider = [[NSMutableArray alloc] init];
    [lstEmailProvider addObject:@"Gmail"];
    [lstEmailProvider addObject:@"Hotmail"];
    
    self.downPicker = [[DownPicker alloc] initWithTextField:self.txtProvider withData:lstEmailProvider];
    
    [self.btnInstall addTarget:self action:@selector(installAccount) forControlEvents:UIControlEventTouchUpInside];
    
    [self.imgInstallBack addTarget:self action:@selector(closeScreen) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) installAccount
{
    NSString *strEmail = self.txtEmail.text;
    NSString* strPassword = self.txtPassword.text;
    NSString *strProvoider = self.txtProvider.text;
    
    if (strEmail == nil || [strEmail isEqualToString:@""])
    {
        [Globals showErrorDialog:@"Empty Email"];
        return;
        
    }
    else if (strPassword == nil || [strPassword isEqualToString:@""])
    {
        [Globals showErrorDialog:@"Empty Password"];
        return;
    }
    /*else if (strProvoider == nil || [strProvoider isEqualToString:@""])
    {
        [Globals showErrorDialog:@"Empty Provider"];
        return;
    }*/
    mAccount.mEmailAccount = strEmail;
    mAccount.mEmailPassword = strPassword;
    //mAccount.mEmailProvider = strProvoider;
    
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

             dispatch_async(dispatch_get_main_queue(), ^{
                 [self closeScreen];
             });
             
             
             
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
-(void) closeScreen
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         
     }];
}
- (IBAction)troubleShootAction:(id)sender {
    NSString *strEmail = self.txtEmail.text;
    NSString* strPassword = self.txtPassword.text;
    NSString *strProvoider = self.txtProvider.text;
    
    if (strEmail == nil || [strEmail isEqualToString:@""])
    {
        [Globals showErrorDialog:@"Empty Email"];
        return;
        
    }
    else if (strPassword == nil || [strPassword isEqualToString:@""])
    {
        [Globals showErrorDialog:@"Empty Password"];
        return;
    }
   /* else if (strProvoider == nil || [strProvoider isEqualToString:@""])
    {
        [Globals showErrorDialog:@"Empty Provider"];
        return;
    }*/
    mAccount.mEmailAccount = strEmail;
    mAccount.mEmailPassword = strPassword;
    //mAccount.mEmailProvider = strProvoider;
    
    
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
             dispatch_async(dispatch_get_main_queue(), ^{
                 InstallViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MailTroubleShootViewController"];
                 [self presentViewController:viewController animated:YES completion:nil];
             });


             
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
