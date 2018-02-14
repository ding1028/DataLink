//
//  InstallViewController.h
//  DataLinkDM
//
//  Created by Twinklestar on 12/16/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownPicker.h"

@interface InstallViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *imgInstallBack;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtProvider;
@property (weak, nonatomic) IBOutlet UIButton *btnInstall;

@property (strong, nonatomic) IBOutlet DownPicker *downPicker;

@end
