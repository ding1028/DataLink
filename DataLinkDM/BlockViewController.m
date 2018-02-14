//
//  BlockViewController.m
//  DataLinkDM
//
//  Created by Twinklestar on 12/16/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import "BlockViewController.h"
#import "BlockContactTableViewCell.h"
#import "AppDelegate.h"

@interface BlockViewController ()

@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.btnBlockBack addTarget:self action:@selector(closeScreen) forControlEvents:UIControlEventTouchUpInside];
    self.tblBlockList.dataSource = self;
    [self.tblBlockList registerNib:[UINib nibWithNibName:@"BlockContactTableViewCell" bundle:nil] forCellReuseIdentifier:@"BlockContactTableViewCell"];
    [self loadBlockContacts];
}

-(void) closeScreen
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadBlockContacts{
    if(!self.blockList)
        self.blockList = [[NSMutableArray alloc] init];
    [self.blockList removeAllObjects];
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    NSMutableArray* items = [delegate.dbManager getBlockContacts:0];
    self.blockList = items;
    [self.tblBlockList reloadData];

}

//#progma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.blockList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BlockContactTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BlockContactTableViewCell" forIndexPath:indexPath];
    
    ContactModel * model = [self.blockList objectAtIndex:indexPath.row];
    cell.name.text = model.mName;
    cell.phone.text = model.mPhone;
    cell.removeButton.tag = indexPath.row;
    [cell.removeButton addTarget:self action:@selector(removeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
    //model
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)removeButtonClicked:(UIButton*)sender
{
    int row = sender.tag;
    ContactModel* model = [self.blockList objectAtIndex:row];
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    [delegate.dbManager removeBlockContact:model];
    [self loadBlockContacts];
}

@end
