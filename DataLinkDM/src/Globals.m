//
//  Globals.m
//  AdNote
//
//  Created by TwinkleStar on 12/3/15.
//  Copyright © 2015 TwinkleStar. All rights reserved.
//

#import "Globals.h"


//NSString *c_baseUrl = @"http://192.168.1.113/WebServiceDataLink/Webservice/";
NSString *c_baseUrl = @"https://api.duplimark.com/WebService/";
NSString *c_loginUrl = @"login";
NSString *c_getMessagesUrl =@"GetMessages";
NSString *c_registerUrl = @"register";
NSString *c_synchronizeUrl = @"savePhoneData";
NSString *c_submitHelp = @"submitHelp";
NSString *c_updateAction = @"updateAction";
NSString *c_messageBody = @"messageBody";
NSString *c_smtp = @"smtp";
NSString *c_saveSetting_url = @"saveSetting";
NSString *c_updateToken = @"updatetoken";
NSString *g_token;

UserModel *mAccount;

NSMutableArray *lstContacts;
NSMutableArray *lstSearchUsers;
NSMutableArray *lstWaitingFriends;

NSMutableArray *lstActions;
NSMutableArray *lstAlerts;

NSMutableDictionary *lstSignals;
NSMutableArray *lstProviders;
NSString *g_calenderId;
NSArray *g_arrEvents;


UserModel *selectedFriend;
int isEdit = 0;
int isProvider = 0;
BOOL isFirstAppRun = false;



@implementation Globals

NSMutableArray *lstNotes;

+(Globals*)sharedInstance{
    static dispatch_once_t onceToken;
    static Globals* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[Globals alloc] init];
    });
    return instance;
}


+(NSString *) getCurrentDateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *result = [dateFormatter stringFromDate:[NSDate date]];
    return result;
}
+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+(void)showIndicator:(UIViewController*)viewcon{
    UIActivityIndicatorView* view = (UIActivityIndicatorView*)[viewcon.view viewWithTag:1000];
    
    if(view == nil){
        CGFloat width = 60.0;
        CGFloat height = 60.0;
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [indicatorView setColor:[UIColor blackColor]];
        indicatorView.center = viewcon.view.center;
        indicatorView.tag = 1000;
        [viewcon.view addSubview:indicatorView];
        [viewcon.view bringSubviewToFront:indicatorView];
        
        view = indicatorView;
    }
    
    view.hidden = false;
    [view startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
}
+(void)stopIndicator:(UIViewController*)viewcon{
    UIActivityIndicatorView* view = (UIActivityIndicatorView*)[viewcon.view viewWithTag:1000];
    if(view != nil){
        view.hidden = YES;
        [view stopAnimating];
        
    }
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

+ (void)removeActivityIndicator :(WNAActivityIndicator*) activityIndicator :(UIView *) parentView
{
    [activityIndicator setHidden:YES];
    [activityIndicator removeFromSuperview];
    activityIndicator = nil;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+(void) showErrorDialog:(NSString *)msg
{
    UIAlertView *errDlg = [[UIAlertView alloc] initWithTitle:msg message:@""delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [errDlg show];
}
+(void) loadUserInfo
{
    NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
    if(mAccount == nil)
        mAccount = [[UserModel alloc] init];
    mAccount.isRemeber = [preference objectForKey:@"isremember"];
    mAccount.mId = [preference objectForKey:@"id"];
    mAccount.mName = [preference objectForKey:@"name"];
    mAccount.isContact = [preference objectForKey:@"iscontact"];
    if(mAccount.isContact == nil) mAccount.isContact = @"1";
    if(mAccount.isCalendar == nil) mAccount.isCalendar = @"1";
    mAccount.isEmail = [preference objectForKey:@"isemail"];
    mAccount.isSms = [preference objectForKey:@"issms"];
    if(mAccount.isSms == nil) mAccount.isSms = @"0";
    mAccount.isCalendar = [preference objectForKey:@"iscalendar"];
    mAccount.isCall = [preference objectForKey:@"iscall"];
    if(mAccount.isCall == nil) mAccount.isCall = @"1";
    mAccount.isQuestion = [preference objectForKey:@"isquestion"];
    if(mAccount.isQuestion == nil) mAccount.isQuestion = @"1";
    //mAccount.mEmailProvider = [preference objectForKey:@"emailprovider"];
    mAccount.mEmailAccount = [preference objectForKey:@"emailaccount"];
    mAccount.mEmailPassword = [preference objectForKey:@"emailpassword"];
    mAccount.mEmailHostName = [preference objectForKey:@"emailhostname"];
    mAccount.mEmailPort = [preference objectForKey:@"emailport"];
    mAccount.mEmailAuthType = [preference objectForKey:@"emailauthtype"];
}

+(void) saveUserAccount {
    NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
    [preference setObject:mAccount.mId forKey:@"id"];
    [preference setObject:mAccount.mName forKey:@"name"];
    if (mAccount.isRemeber == nil)
        mAccount.isRemeber = @"1";
    if ([mAccount.isRemeber isEqualToString:@"1"])
    {
        [preference setObject:mAccount.mEmail forKey:@"email"];
        [preference setObject:mAccount.mPassword forKey:@"password"];
    }
    [preference synchronize];
}
+(void) saveUserInfo
{
    NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
    [preference setObject:mAccount.mId forKey:@"id"];
    [preference setObject:mAccount.mName forKey:@"name"];
    if (mAccount.isRemeber == nil)
        mAccount.isRemeber = @"1";
    if ([mAccount.isRemeber isEqualToString:@"1"])
    {
        [preference setObject:mAccount.mEmail forKey:@"email"];
        [preference setObject:mAccount.mPassword forKey:@"password"];
    }
    [preference setObject:mAccount.isRemeber forKey:@"isremember"];
    if (mAccount.isContact == nil)
        mAccount.isContact = @"0";
    [preference setObject:mAccount.isContact forKey:@"iscontact"];
    if (mAccount.isEmail == nil)
        mAccount.isEmail = @"0";
    [preference setObject:mAccount.isEmail forKey:@"isemail"];
    if (mAccount.isSms == nil)
        mAccount.isSms = @"0";
    [preference setObject:mAccount.isSms forKey:@"issms"];
    if (mAccount.isCalendar == nil)
        mAccount.isCalendar = @"0";
    [preference setObject:mAccount.isCalendar forKey:@"iscalendar"];
    if (mAccount.isCall == nil)
        mAccount.isCall = @"0";
    [preference setObject:mAccount.isCall forKey:@"iscall"];
    if (mAccount.isQuestion == nil)
        mAccount.isQuestion = @"0";
    [preference setObject:mAccount.isQuestion forKey:@"isquestion"];
    //if (mAccount.mEmailProvider == nil)
    //    mAccount.mEmailProvider = @"";
    if (mAccount.mEmailPassword == nil)
        mAccount.mEmailPassword = @"";
    if (mAccount.mEmailAccount == nil)
        mAccount.mEmailAccount = @"";
    //[preference setObject:mAccount.mEmailProvider forKey:@"emailprovider"];
    [preference setObject: mAccount.mEmailAccount forKey:@"emailaccount"];
    [preference setObject:mAccount.mEmailPassword forKey:@"emailpassword"];
    [preference setObject:mAccount.mEmailHostName forKey:@"emailhostname"];
    [preference setObject:mAccount.mEmailPort forKey:@"emailport"];
    [preference setObject:mAccount.mEmailAuthType forKey:@"emailauthtype"];
    [preference synchronize];
}

+(BOOL) loadContact
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
    return accessGranted;
}
// Get the contacts.
+ (void)getContactsWithAddressBook:(ABAddressBookRef )addressBook {
    
    lstContacts = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++) {
        ContactModel *dOfPerson=[ContactModel alloc];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For username and surname
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        
        CFStringRef firstName, lastName, company;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        company   = ABRecordCopyValue(ref, kABPersonOrganizationProperty);
        dOfPerson.mName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        dOfPerson.mCompany = (__bridge NSString *)(company);
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        int inc =0;
        if(ABMultiValueGetCount(eMail) > 0) {
            
            for (int i=0; i<ABMultiValueGetCount(eMail); i++){
                NSString* emailStr = (__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, i) ;
                if(emailStr != nil && ![emailStr isEqualToString:@""]){
                    if(inc == 0){
                        dOfPerson.mEmail = emailStr;
                        
                    }else{
                        dOfPerson.mEmail = [[dOfPerson.mEmail stringByAppendingString:@";"] stringByAppendingString:emailStr];
                    }
                    inc++;
                }
            }

        }
        NSString *note = CFBridgingRelease(ABRecordCopyValue(ref, kABPersonNoteProperty));
        dOfPerson.mNotes = note;
    
        
        //For Address
        ABMutableMultiValueRef address = ABRecordCopyValue(ref,kABPersonAddressProperty);
        inc =0;
        if(ABMultiValueGetCount(address) > 0) {
            
            CFDictionaryRef dict = ABMultiValueCopyValueAtIndex(address, 0);
            dOfPerson.mAddress = (__bridge NSString *)(CFDictionaryGetValue(dict, kABPersonAddressStreetKey));
        }
        
        //For Phone number
        NSString* mobileLabel;
        inc = 0;
        
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            NSString* phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i);
            if(phone != nil && ![phone isEqualToString:@""]){
                if(inc == 0){
                    dOfPerson.mPhone = phone;
                }else{
                    dOfPerson.mPhone = [[dOfPerson.mPhone stringByAppendingString:@";"] stringByAppendingString:phone];
                }
                inc++;
            }
            /*
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                dOfPerson.mPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i);
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                dOfPerson.mPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i);
                break ;
            }*/
            
        }
        [lstContacts addObject:dOfPerson];
        
    }
    NSLog(@"Contacts = %@",lstContacts);
}
+(void) serviceSaveCalendar
{
    /*NSDictionary * params = @{@"image":mAccount.mImage,@"phone":mAccount.mPhone ,@"city":mAccount.mCity ,@"address":mAccount.mAddress,@"name":mAccount.mName};*/
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (g_arrEvents != nil)
    {
        for (int i = 0;i <  g_arrEvents.count;i++)
        {
            // Get each single event.
            EKEvent *event = [g_arrEvents objectAtIndex:i];
            
            NSString *key = [[@	"calendars[" stringByAppendingString:[NSString stringWithFormat:@"%d",i]] stringByAppendingString:@"]."];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *strStart = @"";
            NSString *strEnd = @"";
            long timeStamp = [event.startDate timeIntervalSince1970];
            long cTime = [[NSDate date] timeIntervalSince1970];

                if  (event.startDate != nil)
                    strStart = [dateFormatter stringFromDate:event.startDate];
                if (event.endDate != nil)
                    strEnd = [dateFormatter stringFromDate:event.endDate];
                [param setValue:event.eventIdentifier forKey:[key stringByAppendingString:@"cId"]];
                [param setValue:event.title forKey:[key stringByAppendingString:@"calendarName"]];
                [param setValue:@"" forKey:[key stringByAppendingString:@"calendarDescription"]];
                [param setValue:strStart forKey:[key stringByAppendingString:@"calendarStartDate"]];
                [param setValue:strEnd forKey:[key stringByAppendingString:@"calendarEndDate"]];
        }
    }
    
    if(mAccount.mId != nil){
        [param setValue:mAccount.mId forKey:@"userId"];
    }else {
        
        NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
        NSString* mId = [preference objectForKey:@"id"];
        if(mId != nil) {
            [param setValue:mId forKey:@"userId"];
        }else{
            return;
        }
    }
    
    NSString *serverurl = [ c_baseUrl stringByAppendingString:@"savePhoneDataCalendar"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:serverurl parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         //[Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}

+(void) serviceTestError:(NSString*) uId withEmail:(NSString*) email  withError: (NSString*) error withSuccess: (NSString*) success {
    if(error == nil)
        error = @"Fail";
    if(success == nil)
        success = @"n";
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:uId forKey:@"Uid"];
    [param setObject:email forKey:@"Email"];
    [param setObject:error forKey:@"Error"];
    [param setObject:success forKey:@"Success"];
    NSString *serverurl = [ c_baseUrl stringByAppendingString:@"testError"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:serverurl parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         //[Globals removeActivityIndicator:self.activityIndicator :self.view];
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         //[Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}

+(void) serviceUpdateError:(NSString*) mId withErrorMsg: (NSString*) error {
    if(error == nil)
        error = @"Unknown Error";
     NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:mId forKey:@"Mid"];
    [param setObject:error forKey:@"Error"];
    NSString *serverurl = [ c_baseUrl stringByAppendingString:@"updateError"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:serverurl parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         //[Globals removeActivityIndicator:self.activityIndicator :self.view];
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         //[Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];

}

+(void) serviceSaveContact
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
                cModel.mId = @"-1";
            [param setObject:cModel.mId forKey:[key stringByAppendingString:@"id"]];
            if (cModel.mName == nil) cModel.mName = @"Unknown";
            [param setObject:cModel.mName forKey:[key stringByAppendingString:@"name"]];
            if (cModel.mPhone == nil) cModel.mPhone = @"Unknown";
            [param setObject:cModel.mPhone forKey:[key stringByAppendingString:@"phone"]];
            if (cModel.mEmail == nil) cModel.mEmail = @"Unknown";
            [param setObject:cModel.mEmail forKey:[key stringByAppendingString:@"email"]];
            
            if (cModel.mNotes == nil) cModel.mNotes = @"Unknown";
            [param setObject:cModel.mNotes forKey:[key stringByAppendingString:@"notes"]];
            if (cModel.mAddress == nil) cModel.mAddress = @"";
            [param setObject:cModel.mAddress  forKey:[key stringByAppendingString:@"address"]];
            if(cModel.mCompany == nil)
                cModel.mCompany = @"";
             [param setObject:cModel.mCompany  forKey:[key stringByAppendingString:@"company"]];
            
        }
    }
    if(mAccount.mId != nil){
        [param setValue:mAccount.mId forKey:@"userId"];
    }else {

        NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
        NSString* mId = [preference objectForKey:@"id"];
        if(mId != nil) {
            [param setValue:mId forKey:@"userId"];
        }else{
            return;
        }
    }
    NSString *serverurl = [ c_baseUrl stringByAppendingString:@"savePhoneDataContact"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:serverurl parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         //[Globals removeActivityIndicator:self.activityIndicator :self.view];
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         //[Globals removeActivityIndicator:self.activityIndicator :self.view];
     }];
}

+(void)AlertMessage:(UIViewController*)viewController Message:(NSString*)message Title:(NSString*)title{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                               }];
    
    
    [alert addAction:okButton];
    
    
    [viewController presentViewController:alert animated:YES completion:nil];
}


+(void)ConfirmWithCompletionBlock:(UIViewController*)viewController Message:(NSString*)message Title:(NSString*)title withCompletion:(void(^)(NSString* result))onComplete{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Allow"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   onComplete(@"Allow");
                                   
                               }];
    
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:@"Disallow"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * action) {
                                       //Handle your yes please button action here
                                       onComplete(@"Disallow");
                                       
                                   }];
    [alert addAction:okButton];
    [alert addAction:cancelButton];
    
    
    [viewController presentViewController:alert animated:YES completion:nil];
}


@end
