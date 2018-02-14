//
//  UserModel.h
//  Fitcard
//
//  Created by BoHuang on 7/27/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject


@property (nonatomic, strong) NSString* mId;
@property (nonatomic, strong) NSString* mGuid;
@property (nonatomic, strong) NSString* mName;
@property (nonatomic, strong) NSString* mPassword;
@property (nonatomic, strong) NSString* mEmail;
@property (nonatomic, strong) NSString* mType;
@property (nonatomic, strong) NSString* mToken;

@property (nonatomic, strong) NSString* mGetSmtp;

@property (nonatomic, strong) NSString* mEmailAccount;
@property (nonatomic, strong) NSString* mEmailPassword;
//@property (nonatomic, strong) NSString* mEmailProvider;

@property (nonatomic, strong) NSString* mEmailHostName;
@property (nonatomic, strong) NSString* mEmailPort;
@property (nonatomic, strong) NSString* mEmailAuthType;



@property (nonatomic, strong) NSString*  isContact;
@property (nonatomic, strong) NSString*  isSms;
@property (nonatomic, strong) NSString*  isEmail;
@property (nonatomic, strong) NSString*  isCalendar;
@property (nonatomic, strong) NSString*  isCall;

@property (nonatomic, strong) NSString*  isQuestion;
@property (nonatomic, strong) NSString*  isRemeber;

@property  int callStartHour;
@property  int callStartMin;
@property  int callEndHour;
@property  int callEndMin;

@property  int questionStartHour;
@property  int questionStartMin;
@property  int questionEndHour;
@property  int questionEndMin;




@end
