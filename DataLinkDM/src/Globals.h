//
//  Globals.h
//  AdNote
//
//  Created by TwinkleStar on 12/3/15.
//  Copyright © 2015 TwinkleStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "WNAActivityIndicator.h"
#import "ContactModel.h"

#import "SettingViewController.h"
#import "ActionListViewController.h"
#import "ViewController.h"
#import "Globals.h"
#import "AppDelegate.h"
#import "ContactModel.h"
#import "AFNetworking.h"


extern NSString *c_baseUrl;
extern NSString *c_loginUrl ;
extern NSString *c_registerUrl ;
extern NSString *c_synchronizeUrl;
extern NSString *c_submitHelp;
extern NSString *c_updateAction;
extern NSString *c_messageBody;
extern NSString *c_getMessagesUrl;
extern NSString *c_saveSetting_url;
extern NSString *c_updateToken;
extern NSString *c_smtp;
extern UserModel *mAccount;

extern NSString *g_token;

extern NSMutableArray *lstContacts;

extern NSMutableDictionary *lstSignals;
extern NSMutableArray *lstProviders;

extern NSMutableArray *lstActions;
extern NSMutableArray *lstAlerts;

extern UserModel *selectedFriend;
extern int isEdit;
extern int isProvider;
extern NSArray *g_arrEvents;
extern NSString *g_calenderId;
extern BOOL isFirstAppRun;





@interface Globals : NSObject

@property (strong, nonatomic) NSMutableArray *lstNotes;
@property (strong, nonatomic) NSMutableArray *lstContacts;
@property (strong, nonatomic) NSMutableArray *lstSearchUsers;
@property (strong, nonatomic) NSMutableArray *lstWaitingFriends;

+(Globals *) sharedInstance;

+(NSString *) getCurrentDateTime;
+(UIColor*)colorWithHexString:(NSString*)hex;
+ (UIImage *)imageWithColor:(UIColor *)color ;
+(void) showErrorDialog:(NSString *)msg;
+(void) saveUserInfo;
+(void) saveUserAccount;
+(void) loadUserInfo;
+(void)showIndicator:(UIViewController*)viewcon;
+(void)stopIndicator:(UIViewController*)viewcon;
+ (void)removeActivityIndicator :(WNAActivityIndicator*) activityIndicator :(UIView *) parentView;
+(BOOL) loadContact;
+(void) serviceSaveCalendar;
+(void) serviceSaveContact;
+(void) serviceUpdateError:(NSString*) mId withErrorMsg: (NSString*) error;
+ (void)getContactsWithAddressBook:(ABAddressBookRef )addressBook;
+(void)AlertMessage:(UIViewController*)viewController Message:(NSString*)message Title:(NSString*)title;
+(void)ConfirmWithCompletionBlock:(UIViewController*)viewController Message:(NSString*)message Title:(NSString*)title withCompletion:(void(^)(NSString* result))onComplete;
+(void) serviceTestError:(NSString*) uId withEmail:(NSString*) email  withError: (NSString*) error withSuccess: (NSString*) success;
@end
