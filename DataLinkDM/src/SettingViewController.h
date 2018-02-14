//
//  SettingViewController.h
//  DataLinkDM
//
//  Created by BoHuang on 9/8/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WNAActivityIndicator.h"

@interface SettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnSettingBack;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UIButton *btnContact;
@property (weak, nonatomic) IBOutlet UIButton *btnCalendar;
@property (weak, nonatomic) IBOutlet UIButton *btnSms;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UIButton *btnQuestion;
@property (weak, nonatomic) IBOutlet UIView *vwIgnore;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblCallStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblQuestionStatus;

@property (weak, nonatomic) IBOutlet UILabel *lblContactStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblCalendarStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblSmsStatus;

@property (strong, nonatomic) WNAActivityIndicator *activityIndicator;

@end
