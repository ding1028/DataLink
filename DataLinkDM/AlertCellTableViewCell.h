//
//  AlertCellTableViewCell.h
//  DataLinkDM
//
//  Created by Twinklestar on 12/16/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;

@end
