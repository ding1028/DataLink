//
//  EditContentViewController.m
//  DataLinkDM
//
//  Created by BoHuang on 9/8/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import "EditContentViewController.h"
#import "Globals.h"

@interface EditContentViewController ()

@end

@implementation EditContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_currentModelIndex>=0 && lstActions.count >0){
        self.currentContent = [lstActions objectAtIndex:self.currentModelIndex];
        self.txtContent.text = self.currentContent.mContent;
    }else
        self.currentModelIndex = -1;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveAction:(id)sender {
    if([_txtContent.text isEqualToString:@""]){
        [Globals showErrorDialog:@"Please input the content"];
        return;
    }
    self.currentContent.mContent = _txtContent.text;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
