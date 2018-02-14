//
//  BaseModel.h
//  DataLinkDM
//
//  Created by q on 9/10/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject


@property (nonatomic, strong) NSString* mPhone;
@property (nonatomic, strong) NSString* mTitle;
@property (nonatomic, strong) NSString* mEmail;
@property (nonatomic, strong) NSString* mContent;
@property (nonatomic, strong) NSString* mType;
@property (nonatomic, strong) NSString* mStart;
@property (nonatomic, strong) NSString* mEnd;
@property (nonatomic, strong) NSString* mId;
@property (nonatomic, strong) NSString* mUserId;
@property (nonatomic, strong) NSString* mGUID;
@property (nonatomic, strong) NSString* mRead;
@property (nonatomic, strong) NSString* mSent;
@property (nonatomic, strong) NSString* mHour;
@property (nonatomic, strong) NSString* mMin;
@property (nonatomic, strong) NSString* mDate;


@end
