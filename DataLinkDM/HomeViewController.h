//
//  HomeViewController.h
//  DataLinkDM
//
//  Created by Twinklestar on 12/16/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *vwHomeSetting;
@property (weak, nonatomic) IBOutlet UIView *vwHomeMessage;
@property (weak, nonatomic) IBOutlet UIView *vwHomeHelp;
@property (weak, nonatomic) IBOutlet UIView *vwHomeAlert;
@property (weak, nonatomic) IBOutlet UILabel *lblHomeAlertCount;
@property (weak, nonatomic) IBOutlet UILabel *lblHomeActionCount;

@end
