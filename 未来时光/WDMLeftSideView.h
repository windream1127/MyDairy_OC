//
//  WDMLeftSideView.h
//  未来时光
//
//  Created by Windream on 14-5-4.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Common.h"
@interface WDMLeftSideView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    UITableView *_tableView;
}
@property (strong,nonatomic)NSArray *listData;
@end
