//
//  WDMDairyDetaiView.h
//  未来时光
//
//  Created by Windream on 14-5-6.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DairyBL.h"
#import "CommomMacro.h"
#import "WDMActionSheet.h"
@interface WDMDairyDetaiView : UIViewController<UITextViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) UITextView *contentDetail;
@property (strong, nonatomic)UIToolbar *toolBar;
@property (strong ,nonatomic)UISwitch *canle;
@property (strong ,nonatomic)UIButton *notify;
@property (strong ,nonatomic)UIButton *share;
@property (strong, nonatomic)NSString *contents;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic)Dairy *dairy;
@property (assign,nonatomic) int flag;
@property (strong ,nonatomic)WDMActionSheet *actionSheet;
//保存数据
- (void)save;
@end
