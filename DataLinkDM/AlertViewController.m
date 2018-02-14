//
//  AlertViewController.m
//  DataLinkDM
//
//  Created by Twinklestar on 12/16/16.
//  Copyright © 2016 Yujin. All rights reserved.
//


#import "AlertViewController.h"
#import "AlertCellTableViewCell.h"
#import "Globals.h"


@interface AlertViewController ()

@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self testData];
    [self.btnAlertBack addTarget:self action:@selector(closeScreen) forControlEvents:UIControlEventTouchUpInside];
    self.tblAlert.delegate = self;
    self.tblAlert.dataSource = self;
    self.tblAlert.estimatedRowHeight = 90;
    self.tblAlert.rowHeight = UITableViewAutomaticDimension;
    [self readAll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) testData {
    BaseModel* bModel = [[BaseModel alloc] init];
    bModel.mType = @"3";
    bModel.mTitle = @"Tesasdfasdfasjdhfjkashkdjfhkjashdkfjhaskjdhfjashdkfjhaskjdhfkjahskdjfhkashdft";
    bModel.mContent = @"Test Measdfasjkdfhjkashdkfhaksjhdfkjsahdkfjhaskdjhfjkasdhfkjahsldjfhaskdjfhkajsdhfkjahsdkjfhaskjdhfkjashdfkjhaskdjfhasjkdhfkjashdfjashdkfjhaskjdhfajksdhfkashdkjfhaskjdhfssage";
    bModel.mPhone = @"12121212";
    bModel.mId = @"1";
    bModel.mGUID = @"guidx";
    [lstAlerts addObject:bModel];
    BaseModel* bModel2 = [[BaseModel alloc] init];
    bModel2.mType = @"3";
    bModel2.mTitle = @"Tesasdfasdfasjdhfjkjdhfkjahskdjfhkashdft";
    bModel2.mContent = @"TestMeasdfasjkdfhjkashdkfhaksjhdfkjsahdkf";
    bModel2.mPhone = @"12121212";
    bModel2.mId = @"1";
    bModel2.mGUID = @"guidx";
    [lstAlerts addObject:bModel2];

}

-(void) readAll
{
    for (int i = 0;i < lstAlerts.count;i++)
    {
        BaseModel * bModel = [lstAlerts objectAtIndex:i];
        bModel.mRead =@"1";
        //[self serviceUpdateAction:bModel :2];
    }
}
-(void) closeScreen
{
    if (lstAlerts.count > 0)
    {
        BaseModel * bModel = [lstAlerts objectAtIndex:0];
        [self serviceUpdateAction:bModel.mId :2];
    }
    [self dismissViewControllerAnimated:YES completion:^
     {
         
     }];
}
-(void) serviceUpdateAction:(NSString*) mId :(int) state
{
    //g_token = @"dfsf";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *serverurl = [ c_baseUrl stringByAppendingString:c_updateAction];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *modeStr = [NSString stringWithFormat:@"%d",state];
    [param setObject:mId forKey:@"mid"];
    [param setObject:modeStr forKey:@"state"];
    
    
    serverurl = [serverurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:serverurl parameters:param
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         
         
         
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         NSString *msg = nil;
         [Globals showErrorDialog:@"Error"];
         
     }];
    
}

//#progma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return lstAlerts.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AlertCellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AlertCellTableViewCell" forIndexPath:indexPath];
    
    BaseModel * model = [lstAlerts objectAtIndex:indexPath.row];
    cell.lblTitle.text = model.mTitle;
    if([model.mType isEqualToString:@"1"]){
        cell.lblType.text = @"Question";
    }
    
    if([model.mType isEqualToString:@"2"]){
        cell.lblType.text = @"3 Way Calling";
    }
    
    if([model.mType isEqualToString:@"3"]){
        cell.lblType.text = @"";
    }
    if(model.mTitle != nil)
    cell.lblTitle.text = model.mTitle;
    if(model.mContent != nil)
    cell.lblDescription.text = model.mContent;
    
    return cell;
    
    //model
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
    
}*/

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // EventTableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    BaseModel * model = [lstAlerts objectAtIndex:indexPath.row];
    if(model.mType != nil && ![model.mType isEqualToString:@"3"]){
        [self showAlertAvailableBox:model];
        [self serviceUpdateAction:model.mId :2];
    }


}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
//#progma mark helper
- (void) showAlertAvailableBox:(BaseModel*) model {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *availableAction = [UIAlertAction actionWithTitle:@"Available" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {[self showCallAlert:model];}];
    UIAlertAction *unavailableAction = [UIAlertAction actionWithTitle:@"Unavailable" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action) {[self unavailableAction:model];}];
    UIAlertAction *blockAction = [UIAlertAction actionWithTitle:@"Block User" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {[self blockAction:model];}];
    
    [alertController addAction:availableAction];
    [alertController addAction:unavailableAction];
    [alertController addAction:blockAction];
    UIImage* btnImage = [UIImage imageNamed:@"chk_normal.png"];
    UIButton* imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [imageButton setImage:[UIImage imageNamed:@"chk_active.png"] forState:UIControlStateSelected];
    [imageButton setImage:[UIImage imageNamed:@"chk_normal.png"] forState:UIControlStateNormal];
    
    [imageButton addTarget:self action:@selector(checkboxAction:) forControlEvents:UIControlEventTouchUpInside];
   // [alertController.view addSubview:imageButton];
    [self presentViewController:alertController animated:YES completion:nil];
    self.currentModel = model;
}

- (void) showCallAlert:(BaseModel*) model{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    NSString* callString = @"Call ";
    callString = [callString stringByAppendingString:model.mTitle];
    UIAlertAction *callAction = [UIAlertAction actionWithTitle:callString style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {[self callAction:model];}];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action) {[self unavailableAction:model];}];
    [alertController addAction:callAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

}
- (void) unavailableAction :(BaseModel*) model{
    
}
- (void) callAction :(BaseModel*) model{
    NSString* telUrl = @"tel:";
    if(model.mPhone == nil || [model.mPhone isEqualToString:@""])
        return;
        [self serviceUpdateAction:model.mId :3];
    telUrl = [telUrl stringByAppendingString:model.mPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];

}
- (void) checkboxAction:(UIButton*)sender{

}

- (void) blockAction : (BaseModel*) model{
    ContactModel* contactModel = [[ContactModel alloc]init];
    contactModel.mId = model.mUserId;
    contactModel.mName = model.mTitle;
    contactModel.mPhone = model.mPhone;
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];

    [delegate.dbManager insertBlockContact:contactModel];
}
@end
