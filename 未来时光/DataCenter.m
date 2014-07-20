//
//  DataCenter.m
//  未来时光
//
//  Created by Windream on 14-5-6.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import "DataCenter.h"

@implementation DataCenter

//单例模式
static DataCenter *sharedManager = nil;

+ (DataCenter*)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharedManager = [[self alloc] init];
        [sharedManager createEditableCopyOfDatabaseIfNeeded];
        
        
    });
    return sharedManager;
}


- (void)createEditableCopyOfDatabaseIfNeeded {
	
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    
    FMDatabase *db = [FMDatabase databaseWithPath:writableDBPath];
    if ([db open]) {
        NSString * sql = @"CREATE TABLE 'Dairy' (ID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , content TEXT , title TEXT,cdate TEXT)";
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"succ to creating db table");
        }
        [db close];
    } else {
        NSLog(@"error when open db");
    }

//    if (sqlite3_open([writableDBPath UTF8String], &db) != SQLITE_OK) {
//        sqlite3_close(db);
//        NSAssert(NO,@"数据库打开失败。");
//    } else {
//        char *err;
//        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS Dairy (ID INT PRIMARY KEY, content TEXT , title TEXT,cdate TEXT);"];
//        if (sqlite3_exec(db,[createSQL UTF8String],NULL,NULL,&err) != SQLITE_OK) {
//            sqlite3_close(db);
//            NSAssert1(NO, @"建表失败, %s", err);
//        }
//        sqlite3_close(db);
//    }
}

- (NSString *)applicationDocumentsDirectoryFile {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:DBFILE_NAME];
    
	return path;
}


//插入Dairy方法
-(int) create:(Dairy*)model
{
    static int idx = 0;
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    
    FMDatabase *db = [FMDatabase databaseWithPath:writableDBPath];
    if ([db open]) {
        NSString * sql = @"INSERT OR REPLACE INTO dairy (title, content, cdate) VALUES (?,?,?)";
     
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *nsdate = [dateFormatter stringFromDate:model.date];

        BOOL res = [db executeUpdate:sql,model.title,model.content,nsdate];
        if (!res) {
            NSLog(@"error to insert data");
        } else {
            NSLog(@"succ to insert data");
        }
        [db close];
        idx++;
    }

//    NSString *path = [self applicationDocumentsDirectoryFile];
//    
//    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
//		sqlite3_close(db);
//		NSAssert(NO,@"数据库打开失败。");
//	} else {
//		
//		NSString *sqlStr = @"INSERT OR REPLACE INTO dairy (ID, title, content, cdate) VALUES (?,?,?,?)";
//		
//		sqlite3_stmt *statement;
//		//预处理过程
//		if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSString *nsdate = [dateFormatter stringFromDate:model.date];
//            
//			//绑定参数开始
//            int ID = [self.findAll count]+1;
//            sqlite3_bind_int(statement, 1, ID);
//			sqlite3_bind_text(statement, 2, [model.title UTF8String], -1, NULL);
//			sqlite3_bind_text(statement, 3, [model.content UTF8String], -1, NULL);
//            sqlite3_bind_text(statement, 4, [nsdate UTF8String], -1, NULL);
//			
//			//执行插入
//			if (sqlite3_step(statement) != SQLITE_DONE) {
//				NSAssert(NO, @"插入数据失败。");
//			}
//		}
//		
//		sqlite3_finalize(statement);
//		sqlite3_close(db);
    
    return 0;
}

//删除Dairy方法
-(int) remove:(Dairy*)model
{
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    
    FMDatabase *db = [FMDatabase databaseWithPath:writableDBPath];
    if ([db open]) {
        NSString * sql = @"DELETE  from dairy where ID =?";
        NSNumber *ID = [NSNumber numberWithInt:model.ID];
        BOOL res = [db executeUpdate:sql,ID];
        if (!res) {
            NSLog(@"error to delete data");
        } else {
            NSLog(@"succ to delete data");
        }
        [db close];
    }
//    NSString *path = [self applicationDocumentsDirectoryFile];
//    
//    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
//		sqlite3_close(db);
//		NSAssert(NO,@"数据库打开失败。");
//	} else {
//		
//		NSString *sqlStr = @"DELETE  from dairy where ID =?";
//		
//		sqlite3_stmt *statement;
//		//预处理过程
//		if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//            
//			//绑定参数开始
//            sqlite3_bind_int(statement, 1, model.ID);
//            //			sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);
//			//执行
//			if (sqlite3_step(statement) != SQLITE_DONE) {
//				NSAssert(NO, @"删除数据失败。");
//			}
//		}
//		
//		sqlite3_finalize(statement);
//		sqlite3_close(db);
//    }
    
    return 0;
}

//修改Dairy方法
-(int) modify:(Dairy*)model
{
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    
    FMDatabase *db = [FMDatabase databaseWithPath:writableDBPath];
    if ([db open]) {
        NSString * sql = @"UPDATE dairy SET cdate=?,content =?,title=? where ID=?";
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *nsdate = [dateFormatter stringFromDate:model.date];
        NSNumber *ID = [NSNumber numberWithInt:model.ID];
        BOOL res = [db executeUpdate:sql,nsdate,model.content,model.title,ID];
        if (!res) {
            NSLog(@"error to modify data");
        } else {
            NSLog(@"succ to modify data");
        }
        [db close];
    }
//    NSString *path = [self applicationDocumentsDirectoryFile];
//    
//    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
//		sqlite3_close(db);
//		NSAssert(NO,@"数据库打开失败。");
//	} else {
//        
//		NSString *sqlStr = @"UPDATE dairy SET cdate=?,content =?,title=? where ID=?";
//		
//		sqlite3_stmt *statement;
//		//预处理过程
//		if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//            
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSString *nsdate = [dateFormatter stringFromDate:model.date];
//            
//			//绑定参数开始
//            sqlite3_bind_text(statement, 1, [nsdate UTF8String], -1, NULL);
//            sqlite3_bind_text(statement, 2, [model.content UTF8String], -1, NULL);
//			sqlite3_bind_text(statement, 3, [model.title UTF8String], -1, NULL);
//            sqlite3_bind_int(statement, 4, model.ID);
//			//执行
//			if (sqlite3_step(statement) != SQLITE_DONE) {
//				NSAssert(NO, @"修改数据失败。");
//			}
//		}
//		
//		sqlite3_finalize(statement);
//		sqlite3_close(db);
//    }
    return 0;
}

//查询所有数据方法
-(NSMutableArray*) findAll
{
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    FMDatabase *db = [FMDatabase databaseWithPath:writableDBPath];
    if ([db open]) {
        NSString * sql = @"SELECT ID,title,content,cdate FROM Dairy order by cdate desc";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            Dairy* dairy = [[Dairy alloc] init];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            dairy.ID   = [rs intForColumn:@"ID"];
            NSString *cdate = [rs stringForColumn:@"cdate"];
            dairy.date = [dateFormatter dateFromString:cdate];
            dairy.content = [rs stringForColumn:@"content"];
            dairy.title = [rs stringForColumn:@"title"];
            [listData addObject:dairy];
        }
        [db close];
    }
    return listData;
//    NSString *path = [self applicationDocumentsDirectoryFile];
//    NSMutableArray *listData = [[NSMutableArray alloc] init];
//    
//	if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
//		sqlite3_close(db);
//		NSAssert(NO,@"数据库打开失败。");
//	} else {
//		
//		NSString *qsql = @"SELECT ID,title,content,cdate FROM Dairy order by cdate desc";
//		
//		sqlite3_stmt *statement;
//		//预处理过程
//        
//		if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//            
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            
//			//执行
//			while (sqlite3_step(statement) == SQLITE_ROW) {
//                int  ID     = sqlite3_column_int(statement, 0);
//				char *title = (char *) sqlite3_column_text(statement, 1);
//				NSString * nstitle = [[NSString alloc] initWithUTF8String: title];
//				
//				char *content = (char *) sqlite3_column_text(statement, 2);
//				NSString * nscontent = [[NSString alloc] initWithUTF8String: content];
//                
//                char *cdate = (char *) sqlite3_column_text(statement, 3);
//				NSString *nscdate = [[NSString alloc] initWithUTF8String: cdate];
//                
//                Dairy* dairy = [[Dairy alloc] init];
//                dairy.ID   = ID;
//                dairy.date = [dateFormatter dateFromString:nscdate];
//                dairy.content = nscontent;
//                dairy.title = nstitle;
//                
//                [listData addObject:dairy];
//                
//			}
//		}
//		
//		sqlite3_finalize(statement);
//		sqlite3_close(db);
//		
//	}
//    return listData;
}

//按照主键查询数据方法
-(Dairy*) findById:(Dairy*)model
{
//    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
//    FMDatabase *db = [FMDatabase databaseWithPath:writableDBPath];
//    if ([db open]) {
//        NSString * sql = @"SELECT ID,title,content,cdate FROM dairy where ID =?";
//        FMResultSet * rs = [db executeQuery:sql];
//        while ([rs next]) {
//            int userId = [rs intForColumn:@"id"];
//            NSString * name = [rs stringForColumn:@"name"];
//            NSString * pass = [rs stringForColumn:@"password"];
//            debugLog(@"user id = %d, name = %@, pass = %@", userId, name, pass);
//        }
//        [db close];
//    }

//    NSString *path = [self applicationDocumentsDirectoryFile];
//    
//	if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
//		sqlite3_close(db);
//		NSAssert(NO,@"数据库打开失败。");
//	} else {
//		
//		NSString *qsql = @"SELECT ID,title,content,cdate FROM dairy where ID =?";
//		
//		sqlite3_stmt *statement;
//		//预处理过程
//		if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//			//准备参数
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSString *nsdate = [dateFormatter stringFromDate:model.date];
//            //绑定参数开始
//			sqlite3_bind_text(statement, 1, [nsdate UTF8String], -1, NULL);
//            
//			//执行
//			if (sqlite3_step(statement) == SQLITE_ROW) {
//                int   ID    =  sqlite3_column_int(statement, 0);
//				char *title = (char *) sqlite3_column_text(statement, 1);
//				NSString * nstitle = [[NSString alloc] initWithUTF8String: title];
//				
//				char *content = (char *) sqlite3_column_text(statement, 2);
//				NSString * nscontent = [[NSString alloc] initWithUTF8String: content];
//                
//                char *cdate = (char *) sqlite3_column_text(statement, 3);
//				NSString *nscdate = [[NSString alloc] initWithUTF8String: cdate];
//                
//                Dairy* dairy = [[Dairy alloc] init];
//                dairy.ID    = ID;
//                dairy.title = nstitle;
//                dairy.date = [dateFormatter dateFromString:nscdate];
//                dairy.content = nscontent;
//                
//                sqlite3_finalize(statement);
//                sqlite3_close(db);
//                
//                return dairy;
//			}
//		}
//		
//		sqlite3_finalize(statement);
//		sqlite3_close(db);
//		
//	}
   return nil;
}

@end
