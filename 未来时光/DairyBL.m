//
//  DairyBL.m
//  业务逻辑
//
//  Created by Windream on 14-3-12.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import "DairyBL.h"

@implementation DairyBL

//插入Dairy方法
-(NSMutableArray*) createDairy:(Dairy*)model{
    DataCenter *dao = [DataCenter sharedManager];
    [dao create:model];
    
    return [dao findAll];
}

//删除Dairy方法
-(NSMutableArray*) remove:(Dairy*)model{
    DataCenter *dao = [DataCenter sharedManager];
    [dao remove:model];
    
    return [dao findAll];
}

//修改Dairy方法
-(NSMutableArray*) modify:(Dairy*)model{
    DataCenter *dao = [DataCenter sharedManager];
    [dao modify:model];
    
    return [dao findAll];
}

//查询所用数据方法
-(NSMutableArray*) findAll{
    DataCenter *dao = [DataCenter sharedManager];
    
    return [dao findAll];
}

//查询所有数据总数
-(NSUInteger) getCount{
    DataCenter *dao = [DataCenter sharedManager];
    
    return [[dao findAll] count];
}

@end
