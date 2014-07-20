//
//  WDMActionSheet.h
//  未来时光
//
//  Created by Windream on 14-5-19.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDMActionSheet : UIActionSheet<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic)UIPickerView *customPicker;
@property(weak,nonatomic)NSDate *dateSelected;
//sheet初始化
-(id)initWithPicker;
//初始化时间数组
-(void)initpickerViewData;
@end
