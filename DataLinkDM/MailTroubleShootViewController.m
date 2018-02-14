//
//  MailTroubleShootViewController.m
//  DataLinkDM
//
//  Created by BoHuang on 9/21/17.
//  Copyright © 2017 Yujin. All rights reserved.
//

#import "MailTroubleShootViewController.h"
#import "Globals.h"
#import <MailCore/MailCore.h>

@interface MailTroubleShootViewController ()

@end

@implementation MailTroubleShootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sendAction:(id)sender {
    NSString* email = self.tfSendTo.text;
    NSString* subject = self.tfSubject.text;
    NSString* message = self.tfMessage.text;
    if([email isEqualToString:@""]) {
        [Globals AlertMessage:self Message:@"Please enter email." Title:@"Alert"];
        return;
    }
    
    if(mAccount.mEmailAccount == nil || mAccount.mEmailPassword == nil){
        return;
    }
    

    
    

        [Globals showIndicator:self];
        MCOSMTPSession *smtpSession = [[MCOSMTPSession alloc] init];
        smtpSession.hostname = mAccount.mEmailHostName == nil ? @"" : mAccount.mEmailHostName;
        smtpSession.port = mAccount.mEmailPort == nil ? 0 : [mAccount.mEmailPort intValue];
        smtpSession.username = mAccount.mEmailAccount;
        smtpSession.password = mAccount.mEmailPassword;
        if(mAccount.mEmailAuthType != nil && [mAccount.mEmailAuthType isEqualToString:@"plain"]){
            smtpSession.authType = MCOAuthTypeSASLPlain;
            smtpSession.connectionType = MCOConnectionTypeTLS;
        }else {
            smtpSession.connectionType = MCOConnectionTypeStartTLS;
        }

        //smtpSession.checkCertificateEnabled = NO;
        MCOMessageBuilder *builder = [[MCOMessageBuilder alloc] init];
        [[builder header] setFrom:[MCOAddress addressWithDisplayName:nil mailbox:mAccount.mEmailAccount]];
        NSMutableArray *to = [[NSMutableArray alloc] init];
        [to addObject:[MCOAddress addressWithMailbox:email]];
        [[builder header] setTo:to];
        [[builder header] setSubject:subject];
        [builder setTextBody:message];
        [[builder header] setTo:to];
        NSData *rfc822Data = [builder data];
        MCOSMTPSendOperation *sendOperation = [smtpSession sendOperationWithData:rfc822Data];
    
        [sendOperation start:^(NSError * _Nullable error) {
            [Globals stopIndicator:self];
            if (error) {
                [Globals AlertMessage:self Message:error.localizedDescription  Title:@"Failure"];
                [Globals serviceTestError:mAccount.mId withEmail:mAccount.mEmailAccount withError:error.localizedDescription withSuccess:@"n"];
            }
            else {
                [Globals serviceTestError:mAccount.mId withEmail:mAccount.mEmailAccount withError:@"" withSuccess:@"y"];
                [Globals AlertMessage:self Message:@"Mail successfully sent." Title:@"Success"];

            }
        }];
  
    

}




@end
