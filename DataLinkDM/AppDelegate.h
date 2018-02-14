//
//  AppDelegate.h
//  DataLinkDM
//
//  Created by BoHuang on 9/8/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventManager.h"
#import "BaseModel.h"
#import "DBManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) EventManager *eventManager;
@property (nonatomic, strong) DBManager *dbManager;

//-(void) sendGmail:(BaseModel *) bModel;
-(void) sendEmail:(BaseModel *) bModel;
//-(void) sendHotmail:(BaseModel *) bModel;
-(void) processNotification:(NSDictionary* ) test;
-(void) calendarSync;
-(void) contactSync;
@end

