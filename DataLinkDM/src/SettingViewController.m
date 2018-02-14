//
//  SettingViewController.m
//  DataLinkDM
//
//  Created by BoHuang on 9/8/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import "SettingViewController.h"
#import "ActionListViewController.h"
#import "InstallViewController.h"
#import "ViewController.h"
#import "Globals.h"
#import "AppDelegate.h"
#import "ContactModel.h"
#import "AFNetworking.h"
#import "BlockViewController.h"
#import "MyTimePickerView.h"
#import "CallSettingViewController.h"
#import "QuestionSettingViewController.h"
@interface SettingViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, strong) NSArray *arrEvents;


-(void)requestAccessToEvents;

-(void)loadEvents;
@end
@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   // [self performSelector:@selector(requestAccessToEvents) withObject:nil afterDelay:0.4];
    // Do any additional setup after loading the view.
    [self.btnContact setTag:0];
    [self.btnCalendar setTag:1];
    [self.btnSms setTag:2];
    [self.btnEmail setTag:3];
    [self.btnCall setTag:4];
    [self.btnQuestion setTag:5];
    
    [self.btnContact setImage:[UIImage imageNamed:@"chk_active_new.png"] forState:UIControlStateSelected];
    [self.btnContact setImage:[UIImage imageNamed:@"chk_normal_new.png"] forState:UIControlStateNormal];
    
    [self.btnCalendar setImage:[UIImage imageNamed:@"chk_active_new.png"] forState:UIControlStateSelected];
    [self.btnCalendar setImage:[UIImage imageNamed:@"chk_normal_new.png"] forState:UIControlStateNormal];
    
    [self.btnSms setImage:[UIImage imageNamed:@"chk_active_new.png"] forState:UIControlStateSelected];
    [self.btnSms setImage:[UIImage imageNamed:@"chk_normal_new.png"] forState:UIControlStateNormal];
    
    [self.btnEmail setImage:[UIImage imageNamed:@"chk_active_new.png"] forState:UIControlStateSelected];
    [self.btnEmail setImage:[UIImage imageNamed:@"chk_normal_new.png"] forState:UIControlStateNormal];
    
    [self.btnCall setImage:[UIImage imageNamed:@"chk_active_new.png"] forState:UIControlStateSelected];
    [self.btnCall setImage:[UIImage imageNamed:@"chk_normal_new.png"] forState:UIControlStateNormal];
    
    [self.btnQuestion setImage:[UIImage imageNamed:@"chk_active_new.png"] forState:UIControlStateSelected];
    [self.btnQuestion setImage:[UIImage imageNamed:@"chk_normal_new.png"] forState:UIControlStateNormal];
    [self.btnSettingBack addTarget:self action:@selector(closeScreen) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnContact addTarget:self action:@selector(settingClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCalendar addTarget:self action:@selector(settingClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSms addTarget:self action:@selector(settingClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnEmail addTarget:self action:@selector(settingClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCall addTarget:self action:@selector(settingClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnQuestion addTarget:self action:@selector(settingClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnSave addTarget:self action:@selector(saveSetting) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLogout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    if ([mAccount.isSms isEqualToString:@"1"])
        self.btnSms.selected = true;
    if ([mAccount.isEmail isEqualToString:@"1"])
        self.btnEmail.selected = true;
    if ([mAccount.isContact isEqualToString:@"1"])
        self.btnContact.selected = true;
    if ([mAccount.isCalendar isEqualToString:@"1"])
        self.btnCalendar.selected = true;
    if ([mAccount.isCall isEqualToString:@"1"])
        self.btnCall.selected = true;
    if ([mAccount.isQuestion isEqualToString:@"1"])
        self.btnQuestion.selected = true;
    [self setStatus];
    
    UITapGestureRecognizer *ignoreClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ignoreClick:)];
    [self.vwIgnore addGestureRecognizer:ignoreClick];
    
    
    [self requestAccessToEvents];
    [self requestAccessToContact];
    
}

-(void) ignoreClick:(UITapGestureRecognizer *) recognizer
{
    BlockViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BlockViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}


-(void) closeScreen
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         
     }];
}
-(void) setStatus
{
    if ([mAccount.isSms isEqualToString:@"1"])
        self.lblSmsStatus.text = @"Auto";
    else self.lblSmsStatus.text = @"Manual";
    if ([mAccount.isContact isEqualToString:@"1"])
        self.lblContactStatus.text = @"Enabled";
    else self.lblContactStatus.text = @"Disabled";
    if ([mAccount.isCalendar isEqualToString:@"1"])
        self.lblCalendarStatus.text = @"Enabled";
    else self.lblCalendarStatus.text = @"Disabled";
    if ([mAccount.isEmail isEqualToString:@"1"])
        self.lblEmailStatus.text = @"Auto";
    else self.lblEmailStatus.text = @"Manual";
    if ([mAccount.isCall isEqualToString:@"1"])
        self.lblCallStatus.text = @"Enabled";
    else self.lblCallStatus.text = @"Disabled";
    if ([mAccount.isQuestion isEqualToString:@"1"])
        self.lblQuestionStatus.text = @"Enabled";
    else self.lblQuestionStatus.text = @"Disabled";
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)settingClick:(id)sender
{
    int tag = [sender tag];
    
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.selected; // toggle the selected property, just a simple BOOL
    
    switch(tag)
    {
        case 0:
            if (btn.selected)
            {
                /*[Globals ConfirmWithCompletionBlock:self Message:@"In order to enable this feature, click on \"Allow\" when you are prompted to give MyMAP access to your contacts." Title:@"Notice" withCompletion:^(NSString *result) {
                    if([result  isEqualToString:@"Allow"])
                        mAccount.isContact = @"1";
                    else {
                        mAccount.isContact = @"0";
                        self.btnContact.selected = false;
                    }
                 
                }];*/
                
                [self requestAccessToContact];
                [self setStatus];
            }
            else mAccount.isContact = @"0";
            break;
        case 1:
            if (btn.selected) {
                mAccount.isCalendar = @"1";
                [self requestAccessToEvents];
                
                /*[Globals ConfirmWithCompletionBlock:self Message:@"In order to enable this feature, click on \"Allow\" when you are prompted to give MyMAP access to your calendar." Title:@"Notice" withCompletion:^(NSString *result) {
                    if([result isEqualToString:@"Allow"]){
         
                    }
                    else {
                        mAccount.isCalendar = @"0";
                        self.btnCalendar.selected = false;
                    }
          
                }];*/
                
                [self setStatus];

            }
            else mAccount.isCalendar = @"0";
            break;
        case 3:
            if (btn.selected)
            {
                InstallViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InstallViewController"];
                [self presentViewController:viewController animated:YES completion:nil];
                mAccount.isEmail = @"1";
            }
            else
            {
                //mAccount.mEmailAccount = nil;
                //mAccount.mEmailPassword = nil;
                //mAccount.mEmailProvider = nil;
                mAccount.isEmail = @"0";
            }
            break;
        case 4:
            if (btn.selected)
            {
                mAccount.isCall = @"1";
               /* [MyTimePickerView showTimePickerViewDeadLine:@"20201231" CompleteBlock:^(NSDictionary *infoDic) {
                    mAccount.callStartHour = [infoDic[@"time_hour"] integerValue];
                    mAccount.callStartMin = [infoDic[@"time_min"] integerValue];
                    
                    [MyTimePickerView showTimePickerViewDeadLine:@"20201231" CompleteBlock:^(NSDictionary *infoDic) {
                        mAccount.callEndHour = [infoDic[@"time_hour"] integerValue];
                        mAccount.callEndMin = [infoDic[@"time_min"] integerValue];
                        
                    }];
                    
                    
                    
                }];*/
                CallSettingViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CallSettingViewController"];
                [self presentViewController:viewController animated:YES completion:nil];
            
            }
            else
            {
                mAccount.isCall = @"0";
            }
            break;
        case 5:
            if (btn.selected)
            {
                mAccount.isQuestion = @"1";
                /*[MyTimePickerView showTimePickerViewDeadLine:@"20201231" CompleteBlock:^(NSDictionary *infoDic) {
                    mAccount.questionStartHour = [infoDic[@"time_hour"] integerValue];
                    mAccount.questionStartMin = [infoDic[@"time_min"] integerValue];
                    
                    [MyTimePickerView showTimePickerViewDeadLine:@"20201231" CompleteBlock:^(NSDictionary *infoDic) {
                        mAccount.questionEndHour = [infoDic[@"time_hour"] integerValue];
                        mAccount.questionEndMin = [infoDic[@"time_min"] integerValue];
                        
                    }];
                    
                    
                    
                }];*/
                QuestionSettingViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuestionSettingViewController"];
                [self presentViewController:viewController animated:YES completion:nil];
            }
            else
            {
                mAccount.isQuestion = @"0";
                
            }
            break;
    }
    [self setStatus];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0)
    {
        if (buttonIndex == 0)
        {
            mAccount.isContact = @"1";
        
        }
        else if (buttonIndex == 1)
        {

        }
        [self setStatus];
    }
    else if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {

        }
    }
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
    [preference setObject:@"0" forKey:@"iscall"];
    [preference setObject:@"0" forKey:@"isquestion"];
    [preference synchronize];
    
    ViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}
-(void) saveSetting
{
    //if (self.btnCalendar.selected) mAccount.isCalendar = @"1"; else mAccount.isCalendar = @"0";
    //if (self.btnContact.selected) mAccount.isContact = @"1"; else mAccount.isContact = @"0";
    /*if (![mAccount.isSms isEqualToString:@"2"]){
        if(self.btnSms.selected)
            mAccount.isSms = @"1";
        else
            mAccount.isSms = @"0";
    }*/
    if (self.btnEmail.selected) mAccount.isEmail = @"1"; else mAccount.isEmail = @"0";
    //if (self.btnCall.selected) mAccount.isCall = @"1"; else mAccount.isCall = @"0";
    //if (self.btnQuestion.selected) mAccount.isQuestion = @"1"; else mAccount.isQuestion = @"0";
    
    [Globals saveUserInfo];
    [self synchronizeDatabase];
    [self saveUserSetting];
    
}
-(void) synchronizeDatabase
{
    
    //Event
    
    // Load the events with a small delay, so the store event gets ready.
    //[self performSelector:@selector(loadEvents) withObject:nil afterDelay:0.5];
    [self loadEvents];
    [Globals loadContact];
    //[self serviceSynchronize];
    
    /*ActionListViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ActionListViewController"];
    [self presentViewController:viewController animated:YES completion:nil];*/

    [self closeScreen];
    
    
    
}

-(void) saveUserSetting {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:mAccount.mId forKey:@"user"];
    [param setValue:mAccount.isSms forKey:@"sms"];
    [param setValue:mAccount.isEmail forKey:@"emailOption"];
    [param setValue:mAccount.isCall forKey:@"call"];
    [param setValue:mAccount.isCalendar forKey:@"calendar"];
    [param setValue:mAccount.isContact forKey:@"contact"];
    
    
    NSString *serverurl = [ c_baseUrl stringByAppendingString:c_saveSetting_url];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //[self addActivityIndicator];
    [manager POST:serverurl parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         //[Globals removeActivityIndicator:self.activityIndicator :self.view];
                  NSLog(@"%@", @"success");
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         //[Globals removeActivityIndicator:self.activityIndicator :self.view];
                  NSLog(@"%@", [error localizedDescription]);
     }];
}
-(void) serviceSynchronize
{
    /*NSDictionary * params = @{@"image":mAccount.mImage,@"phone":mAccount.mPhone ,@"city":mAccount.mCity ,@"address":mAccount.mAddress,@"name":mAccount.mName};*/
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    if (lstContacts != nil)
    {
        for (int i = 0;i < lstContacts.count;i++)
        {
            ContactModel *cModel = [lstContacts objectAtIndex:i];
            NSLog(@"%@", cModel.mId);
            NSLog(@"%@", cModel.mName);
            NSLog(@"%@", cModel.mEmail);
            NSLog(@"%@", cModel.mPhone);
            NSString *key = [[@"contacts[" stringByAppendingString:[NSString stringWithFormat:@"%d",i]] stringByAppendingString:@"]."];
            if (cModel.mId == nil)
                cModel.mId = @"1";
            [param setObject:cModel.mId forKey:[key stringByAppendingString:@"id"]];
            if (cModel.mName == nil) cModel.mName = @"Unknown";
            [param setObject:cModel.mName forKey:[key stringByAppendingString:@"name"]];
            if (cModel.mPhone == nil) cModel.mPhone = @"Unknown";
            [param setObject:cModel.mPhone forKey:[key stringByAppendingString:@"phone"]];
            if (cModel.mEmail == nil) cModel.mEmail = @"Unknown";
            [param setObject:cModel.mEmail forKey:[key stringByAppendingString:@"email"]];
        }
    }
    if (self.arrEvents != nil)
    {
        for (int i = 0;i <  self.arrEvents.count;i++)
        {
            // Get each single event.
            EKEvent *event = [self.arrEvents objectAtIndex:i];
            
            NSString *key = [[@"calendars[" stringByAppendingString:[NSString stringWithFormat:@"%d",i]] stringByAppendingString:@"]."];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *strStart = @"";
            NSString *strEnd = @"";
            if  (event.startDate != nil)
                strStart = [dateFormatter stringFromDate:event.startDate];
            if (event.endDate != nil)
                strEnd = [dateFormatter stringFromDate:event.endDate];
            [param setValue:event.title forKey:[key stringByAppendingString:@"calendarName"]];
            [param setValue:@"" forKey:[key stringByAppendingString:@"calendarDescription"]];
            [param setValue:strStart forKey:[key stringByAppendingString:@"calendarStartDate"]];
            [param setValue:strEnd forKey:[key stringByAppendingString:@"calendarEndDate"]];
        }
    }
    [param setValue:mAccount.mId forKey:@"userId"];
    NSString *serverurl = [ c_baseUrl stringByAppendingString:c_synchronizeUrl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self addActivityIndicator];
    [manager POST:serverurl parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
         
         ActionListViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ActionListViewController"];
         [self presentViewController:viewController animated:YES completion:nil];
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}
- (void)addActivityIndicator
{
    if (self.activityIndicator == nil) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        self.activityIndicator = [[WNAActivityIndicator alloc] initWithFrame:screenRect];
        [self.activityIndicator setHidden:NO];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (![self.activityIndicator isDescendantOfView:self.view]) {
        [self.view addSubview:self.activityIndicator];
    }
}
-(void)requestAccessToEvents{
    [self.appDelegate.eventManager.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (error == nil) {
            // Store the returned granted value.
            self.appDelegate.eventManager.eventsAccessGranted = granted;
            if(granted)
                mAccount.isCalendar = @"1";
            else {
                mAccount.isCalendar = @"2";
                self.btnCalendar.selected = false;
            }
        }
        else{
            // In case of error, just log its description to the debugger.
            NSLog(@"%@", [error localizedDescription]);
            mAccount.isCalendar = @"2";
            self.btnCalendar.selected = false;
        }
        NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
        [preference setObject:mAccount.isCalendar forKey:@"iscalendar"];
      }];
}
-(void)requestAccessToSms {
}

-(void)requestAccessToContact{
    BOOL accessGranted = [Globals loadContact];
    if(accessGranted)
        mAccount.isContact = @"1";
    else {
        mAccount.isContact = @"2";
        self.btnContact.selected = false;
    }
    NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
    [preference setObject:mAccount.isContact forKey:@"iscontact"];
  }
-(void)loadEvents{
    if (self.appDelegate.eventManager.eventsAccessGranted) {
        self.arrEvents = [self.appDelegate.eventManager getEventsOfSelectedCalendar];  
        //[self.tblEvents reloadData];
    }
}
-(void)eventWasSuccessfullySaved{
    // Reload all events.
    [self loadEvents];
}
- (IBAction)emailAccountAction:(id)sender {
    if(mAccount.isEmail != nil && [mAccount.isEmail isEqualToString:@"1"]) {
        
        InstallViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InstallViewController"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}
/*-(void) loadContact
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //dispatch_release(semaphore);
    }
    
    else { // We are on iOS 5 or Older
        accessGranted = YES;
        [self getContactsWithAddressBook:addressBook];
    }
    
    if (accessGranted) {
        [self getContactsWithAddressBook:addressBook];
    }
}
// Get the contacts.
- (void)getContactsWithAddressBook:(ABAddressBookRef )addressBook {
    
    lstContacts = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++) {
        ContactModel *dOfPerson=[ContactModel alloc];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For username and surname
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        
        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        dOfPerson.mName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            dOfPerson.mEmail = (__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) ;
        }
        
        //For Phone number
        NSString* mobileLabel;
        
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                dOfPerson.mPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i);
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                dOfPerson.mPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i);
                break ;
            }
            
        }
        [lstContacts addObject:dOfPerson];
        
    }
    NSLog(@"Contacts = %@",lstContacts);
}*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
