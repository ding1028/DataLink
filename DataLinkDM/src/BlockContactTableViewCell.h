//
//  BlockContactTableViewCell.h
//  DataLinkDM
//
//  Created by BoHuang on 4/2/17.
//  Copyright © 2017 Yujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockContactTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@end
