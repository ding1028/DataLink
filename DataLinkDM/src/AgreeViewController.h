//
//  AgreeViewController.h
//  DataLinkDM
//
//  Created by BoHuang on 9/8/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgreeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UITextView *txtPolicy;
@property (weak, nonatomic) IBOutlet UIButton *btnAgree;
@property (weak, nonatomic) IBOutlet UIWebView *webAgree;

@end
