//
//  WDMDairyView.h
//  未来时光
//
//  Created by Windream on 14-5-6.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommomMacro.h"
#import "WDMDairyDetaiView.h"

@interface WDMDairyView : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property(nonatomic,strong)UITableView *TableView;
@property(nonatomic,strong)UISearchBar *SearchBar;
@property(nonatomic,strong)UISearchDisplayController *SearchDisplayController;
//保存数据列表
@property (nonatomic,strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *listFilter;

//保存数据列表
@property (nonatomic,strong) DairyBL* bl;
//新建按钮点击
- (void)creatNewDairy;
//查询方法
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSUInteger)scope;
@end
