//
//  AlertViewController.h
//  DataLinkDM
//
//  Created by Twinklestar on 12/16/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"
@interface AlertViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *btnAlertBack;
@property (weak, nonatomic) IBOutlet UITableView *tblAlert;
@property (strong, nonatomic) BaseModel* currentModel;


@end
