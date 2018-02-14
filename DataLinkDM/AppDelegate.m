//
//  AppDelegate.m
//  DataLinkDM
//
//  Created by BoHuang on 9/8/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import "AppDelegate.h"
#import "Globals.h"
#import "BaseModel.h"
#import "IQKeyboardManager.h"
#import <MessageUI/MessageUI.h>
#import <MailCore/MailCore.h>
#import <UserNotifications/UserNotifications.h>

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface AppDelegate ()
@property (nonatomic, strong) AppDelegate *appDelegate;


-(void)requestAccessToEvents;

-(void)loadEvents;
@end
		
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    //[self initService];
    [self registerForRemoteNotifications];
    [self initDatabase];
    [Globals loadUserInfo];

    
    
    return YES;
}
-(void) initDatabase{
    if(_dbManager == nil)
        _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"datalink_db.db"];
}


-(void) initService
{
    // Register the supported interaction types.
    
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    
    // Register for remote notifications.
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString* newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    g_token = [NSString stringWithFormat:@"%@", newToken];
    NSLog(@"My token is: %@", newToken);
    if(mAccount.mId != nil) {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:mAccount.mId forKey:@"UserID"];
        [param setValue:g_token forKey:@"DeviceToken"];
        NSString *serverurl = [ c_baseUrl stringByAppendingString:c_updateToken];
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
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSDictionary *test =(NSDictionary *)[userInfo objectForKey:@"aps"];
    [self processNotification:test];
    
}

- (void)registerForRemoteNotifications
{
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        center.delegate = self;
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            
            if(!error){
                
                [[UIApplication sharedApplication] registerForRemoteNotifications];
                
            }
            
        }];
        
    }
    
    else {
        
        // Code for old versions
        
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        
                                                        UIUserNotificationTypeBadge |
                                                        
                                                        UIUserNotificationTypeSound);
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                
                                                                                 categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }
    
}

-(void) calendarSync {
    
    if(mAccount.isCalendar != nil && [mAccount.isCalendar isEqualToString:@"1"]) {
        [self loadCalendarEvent];
        UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        topWindow.rootViewController = [UIViewController new];
        topWindow.windowLevel = UIWindowLevelAlert + 1;
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Calendar is Syncing." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"OK") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [Globals serviceSaveCalendar];
            topWindow.hidden = YES;
        }]];
        
        [topWindow makeKeyAndVisible];
        [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    

}

-(void) contactSync {
    if(mAccount.isContact != nil && [mAccount.isContact isEqualToString:@"1"]) {
        [Globals loadContact];
        UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        topWindow.rootViewController = [UIViewController new];
        topWindow.windowLevel = UIWindowLevelAlert + 1;
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Contacts are Syncing." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"OK") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [Globals serviceSaveContact];
            topWindow.hidden = YES;
        }]];
        
        [topWindow makeKeyAndVisible];
        [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

-(void) processNotification:(NSDictionary* ) test {
    NSInteger *type = [[test objectForKey:@"type"] integerValue];
    if (type == 1) //Email Notification
    {
        BaseModel *bModel = [[BaseModel alloc] init];
        bModel.mEmail = [test objectForKey:@"email"];
        bModel.mTitle = [test objectForKey:@"title"];
        bModel.mContent = [test objectForKey:@"content"];
        if([test objectForKey:@"msg"] != nil)
            bModel.mContent = [test objectForKey:@"msg"];
        bModel.mType = @"1";
        bModel.mGUID = [test objectForKey:@"mguid"];
        bModel.mId = [test objectForKey:@"mid"];
        [self serviceMessageBody:bModel withType:(int)type];
        
        
    }
    else if (type == 2) //Sms Notification
    {
        BaseModel *bModel = [[BaseModel alloc] init];
        bModel.mEmail = [test objectForKey:@"email"];
        bModel.mTitle = [test objectForKey:@"title"];
        bModel.mContent = [test objectForKey:@"content"];
        bModel.mGUID = [test objectForKey:@"mguid"];
        if([test objectForKey:@"msg"] != nil)
            bModel.mContent = [test objectForKey:@"msg"];
        bModel.mId = [test objectForKey:@"mid"];
        
        
        bModel.mPhone = [test objectForKey:@"phone"];
        bModel.mType = @"2";
        [self serviceMessageBody:bModel withType:(int)type];
        
    }
    else if (type == 3) //Call
    {
        BaseModel *bModel = [[BaseModel alloc] init];
        bModel.mTitle = [test objectForKey:@"title"];
        bModel.mContent = [test objectForKey:@"content"];
        bModel.mPhone = [test objectForKey:@"phone"];
        bModel.mId = [test objectForKey:@"mid"];
        bModel.mType = @"3";
        if(bModel.mId != nil){
            [self serviceUpdateAction:bModel.mId :1];
        }
        [lstAlerts addObject:bModel];
    }
    else if (type == 4) //Add Calendar
    {
        g_calenderId = [test objectForKey:@"uniqueid"];
        BaseModel *bModel = [[BaseModel alloc] init];
        bModel.mTitle = [test objectForKey:@"title"];
        bModel.mContent = [test objectForKey:@"content"];
        bModel.mStart = [test objectForKey:@"start"];
        bModel.mEnd = [test objectForKey:@"end"];
        bModel.mType = @"4";
        [lstActions addObject:bModel];
    }
    else if (type == 9) // Question
    {
        NSString* uid = [test objectForKey:@"uid"];
        NSString* guid = [test objectForKey:@"guid"];
        
        UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        topWindow.rootViewController = [UIViewController new];
        topWindow.windowLevel = UIWindowLevelAlert + 1;
        NSString* title =@"Alert";
        NSString* content = @"Getting Campaign Messages.";
        if(mAccount.isEmail != nil && mAccount.isSms != nil){
            if(![mAccount.isEmail isEqualToString:@"1"]) {
                    title = @"Getting Campaign Messages.";
                    content = @"Your email and text message sending is set to \"Manual Sending\". Click the Messages icon and send each message.";
            }
            if([mAccount.isEmail isEqualToString:@"1"]) {
                title = @"Getting Campaign Messages.";
                content = @"Click the Messages icon and send each Text Message.";
            }
            
        }
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"OK") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self serviceGetUnreadNotifications:uid withGuid:guid];
            topWindow.hidden = YES;
        }]];
        
        [topWindow makeKeyAndVisible];
        [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];

    }
    else if (type == 5) //Send Phone Contact
    {
        [self contactSync];

        
    }
    else if (type == 6) //Send Phone Calendar
    {
        [self calendarSync];
    }
    else if (type == 8)
    {
        //NSString* eventId = [test objectForKey:@"cid"];
        //[self deleteEventCalendar:eventId];
        
        BaseModel *bModel = [[BaseModel alloc] init];
        bModel.mStart =[test objectForKey:@"date"];
        bModel.mTitle = [test objectForKey:@"title"];
        bModel.mPhone = [test objectForKey:@"phone"];
        if([[test objectForKey:@"stype"] isKindOfClass:[NSString class]]){
            bModel.mType = [test objectForKey:@"stype"];
        }else {
            int paramType = [[test objectForKey:@"stype"] intValue];
            bModel.mType =  [NSString stringWithFormat:@"%d", paramType] ;
        }
        bModel.mContent = [test objectForKey:@"content"];
        bModel.mUserId = [test objectForKey:@"userid"];
        bModel.mGUID = [test objectForKey:@"mguid"];
        bModel.mUserId = [test objectForKey:@"userid"];
        bModel.mId = [test objectForKey:@"mid"];
        
        
        bModel.mPhone = [test objectForKey:@"phone"];
        [self serviceMessageBody:bModel withType:(int)type];
        /*BaseModel *bModel = [[BaseModel alloc] init];
         bModel.mId = [test objectForKey:@"mid"];
         bModel.mStart =[test objectForKey:@"date"];
         bModel.mTitle = [test objectForKey:@"title"];
         bModel.mPhone = [test objectForKey:@"phone"];
         bModel.mType = [test objectForKey:@"stype"];
         bModel.mContent = [test objectForKey:@"content"];
         bModel.mUserId = [test objectForKey:@"userid"];
         if(![self.dbManager checkBlockUser:bModel.mUserId]){
         [lstAlerts addObject:bModel];
         }
         
         [self serviceUpdateAction:bModel.mId :1];
         */
        
    }
    [self someMethod];
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

-(void) serviceMessageBody:(BaseModel*) bModel withType:(int) type
{
    BOOL isNotification = false;
    if(bModel.mGUID == nil && bModel.mId != nil){
        //from url
        if(type == 1){

            if(mAccount.isEmail != nil && [mAccount.isEmail isEqualToString:@"1"]) {
                [self sendEmail:bModel];
            }
            /*
            if (mAccount.isEmail != nil && [mAccount.isEmail isEqualToString:@"1"] && mAccount != nil && mAccount.mEmailProvider != nil && [mAccount.mEmailProvider isEqualToString:@"Hotmail"])
            {
                [self sendHotmail:bModel];
                //bModel.mSent = @"1";
            }
            else if (mAccount.isEmail != nil && [mAccount.isEmail isEqualToString:@"1"] && mAccount != nil && mAccount.mEmailProvider != nil && [mAccount.mEmailProvider isEqualToString:@"Gmail"])
            {
                [self sendGmail:bModel];
               // bModel.mSent = @"1";
            }*/
            if(bModel.mId != nil){
                
                [self serviceUpdateAction:bModel.mId :1];
            }
            [lstActions addObject:bModel];
        }
        
        if(type == 2){
            
            [lstActions addObject:bModel];
            [self serviceUpdateAction:bModel.mId :1];
        }
        if(type == 8){

            if(![self.dbManager checkBlockUser:bModel.mUserId]){
                [lstAlerts addObject:bModel];
            }
            
            [self serviceUpdateAction:bModel.mId :1];
        }
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"updateAlert"
         object:nil];
        return;
    }
    if(bModel.mGUID == nil && bModel.mId == nil){
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //NSString *serverurl = [ c_baseUrl stringByAppendingString:c_messageBody];
    //NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    //[param setObject:bModel.mId forKey:@"mid"];
    //[param setObject:bModel.mGUID forKey:@"mguid"];
    
    NSString *serverurl = [[[[[ c_baseUrl stringByAppendingString:c_messageBody]
                                  stringByAppendingString:@"?mid="]
                                 stringByAppendingString:bModel.mId]
                                stringByAppendingString:@"&mguid="]
                           stringByAppendingString:bModel.mGUID];
    serverurl = [serverurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         BaseModel* newModel = [[BaseModel alloc] init];
         newModel.mId = bModel.mId;
         newModel.mType = bModel.mType;
         newModel.mGUID = bModel.mGUID;
         newModel.mUserId = bModel.mUserId;
         newModel.mEmail = bModel.mEmail;
         newModel.mPhone = bModel.mPhone;
         if(type == 1){
             newModel.mContent = [receivedData objectForKey:@"content"];
             newModel.mTitle = [receivedData objectForKey:@"title"];
            [lstActions addObject:newModel];

             if(mAccount.isEmail != nil && [mAccount.isEmail isEqualToString:@"1"]) {
                 [self sendEmail:bModel];
             }
            
             if(newModel.mId != nil){

                 [self serviceUpdateAction:newModel.mId :1];
             }
         }
         
         if(type == 2){
             newModel.mContent = [receivedData objectForKey:@"content"];
             newModel.mTitle = [receivedData objectForKey:@"title"];
             
             [lstActions addObject:newModel];
             [self serviceUpdateAction:newModel.mId :1];
         }
         if(type == 8){
             newModel.mContent =[receivedData objectForKey:@"content"];
             newModel.mTitle = [receivedData objectForKey:@"title"];
             if(![self.dbManager checkBlockUser:newModel.mUserId]){
                 [lstAlerts addObject:newModel];
             }
             
             [self serviceUpdateAction:newModel.mId :1];
         }
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"updateAlert"
          object:nil];
         
     }
            failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         NSString *msg = nil;
         // [Globals showErrorDialog:@"Error"];
         
     }];
    
}

-(void) sendEmail:(BaseModel *) bModel {
    if(bModel.	mEmail == nil || mAccount.mEmailAccount == nil || mAccount.mEmailPassword == nil){
        return;
    }
    MCOSMTPSession *smtpSession = [[MCOSMTPSession alloc] init];
    smtpSession.hostname = mAccount.mEmailHostName == nil ? @"" : mAccount.mEmailHostName;
    smtpSession.port = mAccount.mEmailPort == nil ? 0 : [mAccount.mEmailPort intValue];
    smtpSession.username = mAccount.mEmailAccount;
    smtpSession.password = mAccount.mEmailPassword;
    if(mAccount.mEmailAuthType != nil && [mAccount.mEmailAuthType isEqualToString:@"plain"]){
        smtpSession.authType = MCOAuthTypeSASLPlain;
        smtpSession.connectionType = MCOConnectionTypeTLS;
    }else {
        smtpSession.connectionType = MCOConnectionTypeStartTLS;
    }
    
    MCOMessageBuilder *builder = [[MCOMessageBuilder alloc] init];
    [[builder header] setFrom:[MCOAddress addressWithDisplayName:nil mailbox:mAccount.mEmailAccount]];
    NSMutableArray *to = [[NSMutableArray alloc] init];
    [to addObject:[MCOAddress addressWithMailbox:bModel.mEmail]];
    [[builder header] setTo:to];
    [[builder header] setSubject:bModel.mTitle];
    [builder setTextBody:bModel.mContent];
    [[builder header] setTo:to];
    NSData *rfc822Data = [builder data];
    MCOSMTPSendOperation *sendOperation = [smtpSession sendOperationWithData:rfc822Data];
    [sendOperation start:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error");
            bModel.mSent = @"2";
            [Globals serviceUpdateError:bModel.mId withErrorMsg:[error localizedDescription]];
        }
        else {
            bModel.mSent = @"1";
            [Globals serviceUpdateError:bModel.mId withErrorMsg:@"success"];
            NSLog(@"Success");
        }
        
    }];

}

-(void) serviceGetUnreadNotifications:(NSString*) userId withGuid:(NSString*) guid {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *serverurl = [[[[[ c_baseUrl stringByAppendingString:c_getMessagesUrl]
                              stringByAppendingString:@"?uid="]
                             stringByAppendingString:userId]
                            stringByAppendingString:@"&guid="]
                           stringByAppendingString:guid];
   // [Globals showIndicator:self];
    serverurl = [serverurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:serverurl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *receivedData = responseObject;
         
         
         for(NSDictionary* notificationData in receivedData) {
             [self processNotification:notificationData];
             
         }
         
      //   [Globals stopIndicator:self];
         
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         NSString *msg = nil;
         [Globals stopIndicator:self];
         [Globals showErrorDialog:@"Login Error"];
         
         
     }];
    
}


- (void)showSMS:(BaseModel*)bModel {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[bModel.mPhone];
    NSString *message = bModel.mContent;
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    UIViewController* vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    [vc presentViewController:messageController animated:YES completion:^{}];
    // Present message view controller on screen
    //[self presentViewController:messageController animated:YES completion:nil];
}

-(void) loadCalendarEvent
{
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self performSelector:@selector(requestAccessToEvents) withObject:nil afterDelay:0.4];
    [self loadEvents];
}
-(void) deleteEventCalendar:(NSString*)eventId
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKEvent *myEvent = [eventStore eventWithIdentifier:eventId];
    if (myEvent != nil)
    {
        BOOL b = [eventStore removeEvent:myEvent span:EKSpanThisEvent error:nil];
        NSString *tst = @"";
    }
    
}
-(void)requestAccessToEvents{
    [self.appDelegate.eventManager.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (error == nil) {
            // Store the returned granted value.
            self.appDelegate.eventManager.eventsAccessGranted = granted;
        }
        else{
            // In case of error, just log its description to the debugger.
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}
-(void)loadEvents{
    if (self.appDelegate.eventManager.eventsAccessGranted) {
        g_arrEvents = [self.appDelegate.eventManager getEventsInThreeMonths];
    }

}
-(void)eventWasSuccessfullySaved{
    // Reload all events.
    [self loadEvents];
}



- (void) someMethod
{
    
    // All instances of TestClass will be notified
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"TestNotification"
     object:self];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    self.eventManager = [[EventManager alloc] init];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
