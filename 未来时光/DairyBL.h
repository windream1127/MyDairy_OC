//
//  DairyBL.h
//  业务逻辑
//
//  Created by Windream on 14-3-12.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataCenter.h"

@interface DairyBL : NSObject

//插入Dairy方法
-(NSMutableArray*) createDairy:(Dairy*)model;

//删除Dairy方法
-(NSMutableArray*) remove:(Dairy*)model;
 
//修改Dairy方法
-(NSMutableArray*) modify:(Dairy*)model;

//查询所用数据方法
-(NSMutableArray*) findAll;

//查询所有数据总数
-(NSUInteger) getCount;

@end
