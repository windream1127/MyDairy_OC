//
//  DataCenter.h
//  未来时光
//
//  Created by Windream on 14-5-6.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dairy.h"
#import "sqlite3.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#define DBFILE_NAME @"MyDB.sqlite3"
@interface DataCenter : NSObject

+ (DataCenter*)sharedManager;

- (NSString *)applicationDocumentsDirectoryFile;
- (void)createEditableCopyOfDatabaseIfNeeded;

//插入Dairy方法
-(int) create:(Dairy*)model;

//删除Dairy方法
-(int) remove:(Dairy*)model;

//修改Dairy方法
-(int) modify:(Dairy*)model;

//查询所有数据方法
-(NSMutableArray*) findAll;

//按照主键查询数据方法
-(Dairy*) findById:(Dairy*)model;@end
