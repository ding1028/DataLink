//
//  BlockViewController.h
//  DataLinkDM
//
//  Created by Twinklestar on 12/16/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *btnBlockBack;
@property (weak, nonatomic) IBOutlet UITableView *tblBlockList;
@property (strong, nonatomic) NSMutableArray * blockList;

@end
