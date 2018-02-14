//
//  ActionListViewController.m
//  DataLinkDM
//
//  Created by BoHuang on 9/8/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import "ActionListViewController.h"
#import "ActionCellTableViewCell.h"
#import "Globals.h"
#import "BaseModel.h"
#import "ViewController.h"
#import "SettingViewController.h"
#import "EditContentViewController.h"
#import <MessageUI/MessageUI.h>
#import <EventKit/EventKit.h>

@interface ActionListViewController ()

@end

@implementation ActionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tblAction.delegate = self;
    self.tblAction.dataSource = self;
    [self init];
    
    [self.btnSetting addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLogout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.btnMessageBack addTarget:self action:@selector(closeScreen) forControlEvents:UIControlEventTouchUpInside];
    [self readAll];
    
}
-(void) readAll
{
    for (int i = 0;i < lstActions.count;i++)
    {
        BaseModel * bModel = [lstActions objectAtIndex:i];
        bModel.mRead =@"1";
        //[self serviceUpdateAction:bModel :2];
    }
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tblAction reloadData];
}
-(void) closeScreen
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         
     }];
}

-(void) setting
{
    SettingViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}
-(void) logout
{
    NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
    [preference setObject:@"" forKey:@"id"];
    [preference setObject:@"" forKey:@"name"];
    [preference setObject:@"" forKey:@"email"];
    [preference setObject:@"" forKey:@"password"];
    [preference setObject:@"0" forKey:@"iscontact"];
    [preference setObject:@"0" forKey:@"isemail"];
    [preference setObject:@"0" forKey:@"issms"];
    [preference setObject:@"0" forKey:@"iscalendar"];
    [preference synchronize];
    
    ViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return lstActions.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"ActionCellTableViewCell";
    NSInteger row = indexPath.row;
    ActionCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    BaseModel *bModel = [lstActions objectAtIndex:row];
    if(bModel.mSent != nil && [bModel.mSent isEqualToString:@"1"]) {
        cell.lblSent.text = @"[SENT]";
        cell.lblSent.hidden = NO;
    }else if(bModel.mSent != nil && [bModel.mSent isEqualToString:@"2"]){
       cell.lblSent.text = @"[ERROR]";
        cell.lblSent.hidden = NO;
    }else {
         cell.lblSent.hidden = YES;
    }
        
    if ([bModel.mType isEqualToString:@"2"])
    {
        cell.imgSms.image = [UIImage imageNamed:@"sms1.png"];
        cell.lblContent.text = bModel.mTitle;
        cell.lblName.text = bModel.mContent;
        cell.btnEdit.hidden = YES;
        cell.btnSend.tag = row;
        [cell.btnSend addTarget:self action:@selector(sendSms:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    else if ([bModel.mType isEqualToString:@"3"])
    {
        cell.imgSms.image = [UIImage imageNamed:@"call.png"];
        cell.lblContent.text = bModel.mTitle;
        cell.lblName.text = bModel.mContent;
        cell.btnEdit.hidden = YES;
        cell.btnSend.tag = row;
        [cell.btnSend addTarget:self action:@selector(sendCall:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([bModel.mType isEqualToString:@"4"])
    {
        cell.imgSms.image = [UIImage imageNamed:@"calendar.png"];
        cell.lblContent.text = bModel.mTitle;
        cell.lblName.text = bModel.mContent;
        cell.btnEdit.hidden = YES;
        cell.btnSend.tag = row;
        [cell.btnSend addTarget:self action:@selector(sendEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        cell.imgSms.image = [UIImage imageNamed:@"email.png"];
        cell.lblContent.text = bModel.mEmail;
        cell.lblName.text = bModel.mContent;
        if (mAccount.isEmail != nil && [mAccount.isEmail isEqualToString:@"1"])
        {
            cell.btnEdit.hidden = YES;
        }
        else cell.btnEdit.hidden = NO;
        [cell.btnEdit addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnEdit.tag  = indexPath.row;
        cell.btnSend.tag = row;
        [cell.btnSend addTarget:self action:@selector(sendEmail:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(void) editContent:(id) sender{
    UIButton* btnEdit = (UIButton*) sender;
    int tag = btnEdit.tag;
    EditContentViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditContentViewController"];
    viewController.currentModelIndex = tag;
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void) sendEvent:(id) sender
{
    
    UIButton *btnSend = (UIButton*)sender;
    int tag = btnSend.tag;
    BaseModel *bModel = [lstActions objectAtIndex:tag];
    
    EKEventStore *store = [EKEventStore new];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = bModel.mTitle;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // this is imporant - we set our input date format to match our input string
        // if format doesn't match you'll get nil from your string, so be careful
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
        NSDate *dateFromString = [[NSDate alloc] init];
        NSDate *dateFromString1 = [[NSDate alloc] init];
        // voila!
        dateFromString = [dateFormatter dateFromString:bModel.mStart];
        dateFromString1 = [dateFormatter dateFromString:bModel.mEnd];
        
        
        event.startDate = dateFromString; //today
        event.endDate = dateFromString1;
        event.calendar = [store defaultCalendarForNewEvents];
        NSError *err = nil;
        BOOL b = [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        NSString * eId = event.eventIdentifier;
        [self serviceAddCalendar:eId];
    }];
}
-(void) serviceAddCalendar:(NSString*) eid
{
    
    /*NSDictionary * params = @{@"image":mAccount.mImage,@"phone":mAccount.mPhone ,@"city":mAccount.mCity ,@"address":mAccount.mAddress,@"name":mAccount.mName};*/
    if(g_calenderId == nil)
        return;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *serverurl = [[[[[[[ c_baseUrl stringByAppendingString:@"addCalendarApple"]
                                  stringByAppendingString:@"/"]
                                 stringByAppendingString:g_calenderId]
                                stringByAppendingString:@"/"]
                               stringByAppendingString:[(NSNumber *)mAccount.mId stringValue]]
                             stringByAppendingString:@"/"] stringByAppendingString:eid];
                           
    serverurl = [serverurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:serverurl parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         NSString *msg = nil;
         //[Globals showErrorDialog:@"Login Error"];
         
     }];

}
-(void) sendCall:(id) sender
{
    UIButton *btnSend = (UIButton*)sender;
    int tag = btnSend.tag;
    BaseModel *bModel = [lstActions objectAtIndex:tag];
    self.selectedModel = bModel;
    
    NSString *phoneNumber = bModel.mPhone; // dynamically assigned
    NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL];
    _selectedModel.mSent = @"1";
    if(bModel.mId != nil){
        [self serviceUpdateAction:bModel.mId :2];
    }
}
-(void) sendSms:(id) sender
{
    UIButton *btnSend = (UIButton*)sender;
    int tag = btnSend.tag;
    BaseModel *bModel = [lstActions objectAtIndex:tag];

    if(bModel.mId != nil){
        [self serviceUpdateAction:bModel.mId :2];
    }

    [self showSMS:bModel];
    
    
}
-(void) sendEmail:(id) sender
{
    UIButton *btnSend = (UIButton*) sender;
    int tag = btnSend.tag;
    BaseModel *bModel = [lstActions objectAtIndex:tag];
    [self serviceUpdateAction:bModel.mId :2];
    [self showEmail:bModel];
}
-(void) showEmail:(BaseModel*) bModel
{
    if([MFMailComposeViewController canSendMail]) {
        self.selectedModel = bModel;
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:bModel.mTitle];
        [mailCont setToRecipients:[NSArray arrayWithObject:bModel.mEmail]];
        [mailCont setMessageBody:bModel.mContent isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
        
        //[mailCont release];
    }
}



// Then implement the delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    if(error == nil && result == MFMailComposeResultSent) {
        if(self.selectedModel != nil)
            self.selectedModel.mSent =  @"1";
    }
    [self dismissViewControllerAnimated:YES  completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            if(self.selectedModel != nil)
                self.selectedModel.mSent =  @"1";
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)showSMS:(BaseModel*)bModel {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    self.selectedModel = bModel;
    NSArray *recipents = @[bModel.mPhone];
    NSString *message = bModel.mContent;
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    // Add this instance of TestClass as an observer of the TestNotification.
    // We tell the notification center to inform us of "TestNotification"
    // notifications using the receiveTestNotification: selector. By
    // specifying object:nil, we tell the notification center that we are not
    // interested in who posted the notification. If you provided an actual
    // object rather than nil, the notification center will only notify you
    // when the notification was posted by that particular object.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];
    
    return self;
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"TestNotification"])
    {
        NSLog (@"Successfully received the test notification!");
        [self.tblAction reloadData];
    }
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
