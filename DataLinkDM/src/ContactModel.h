//
//  ContactModel.h
//  DataLinkDM
//
//  Created by q on 9/10/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject


@property (nonatomic, strong) NSString* mId;
@property (nonatomic, strong) NSString* mName;
@property (nonatomic, strong) NSString* mPhone;
@property (nonatomic, strong) NSString* mEmail;
@property (nonatomic, strong) NSString* mAddress;
@property (nonatomic, strong) NSString* mCity;
@property (nonatomic, strong) NSString* mState;
@property (nonatomic, strong) NSString* mZip;
@property (nonatomic, strong) NSString* mNotes;
@property (nonatomic, strong) NSString* mCompany;

@end
