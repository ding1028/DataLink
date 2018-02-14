//
//  EditContentViewController.h
//  DataLinkDM
//
//  Created by BoHuang on 9/8/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface EditContentViewController : UIViewController
@property (nonatomic, assign) int currentModelIndex;
@property (nonatomic, strong) BaseModel* currentContent;
@property (weak, nonatomic) IBOutlet UITextField *txtContent;

@end
