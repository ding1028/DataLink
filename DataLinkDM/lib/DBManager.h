//
//  DBManager.h
//  SQLite3DBSample
//
//  Created by Gabriel Theodoropoulos on 25/6/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactModel.h"

@interface DBManager : NSObject

@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;



-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;

- (NSMutableArray *)getBlockContacts:(int) limit;
- (void)insertBlockContact:(ContactModel*) contact;
- (void) clearContacts;
- (void)removeBlockContact:(ContactModel*) contact;
- (bool)checkBlockUser:(NSString*) userId;

@end
