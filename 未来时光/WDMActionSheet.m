//
//  WDMActionSheet.m
//  未来时光
//
//  Created by Windream on 14-5-19.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import "WDMActionSheet.h"
#define currentMonth [currentMonthString integerValue]
@implementation WDMActionSheet
{
    
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSMutableArray *DaysArray;
    NSMutableArray *hoursArray;
    NSMutableArray *minutesArray;
    
    NSString *currentMonthString;
    
    int selectedYearRow;
    int selectedMonthRow;
    int selectedDayRow;
    int selectedHourRow;
    int selectedMinuteRow;
}

-(NSDate*)dateSelected{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat  = @"yyyy/MM/dd HH:mm";
    
    NSString *year  = [yearArray objectAtIndex:selectedYearRow];
    NSString *month = [monthArray objectAtIndex:selectedMonthRow];
    NSString *day   = [DaysArray objectAtIndex:selectedDayRow];
    NSString *hour  = [hoursArray objectAtIndex:selectedHourRow];
    NSString *min   = [minutesArray objectAtIndex:selectedMinuteRow];

    NSString *strdate = [NSString stringWithFormat:@"%@/%@/%@ %@:%@ ",year,month,day,hour,min];
    return [formatter dateFromString:strdate];
}
//初始化时间数组
-(void)initpickerViewData{
    // PickerView -  Years data
    
    yearArray = [[NSMutableArray alloc]init];
    
    
    for (int i = 1970; i <= 2050 ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    
    // PickerView -  Months data
    
    
    monthArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    
    // PickerView -  Hours data
    
    
    hoursArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 24; i++)
    {
        
        [hoursArray addObject:[NSString stringWithFormat:@"%02d",i]];
        
    }
    // PickerView -  Hours data
    
    minutesArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 60; i++)
    {
        
        [minutesArray addObject:[NSString stringWithFormat:@"%02d",i]];
        
    }
    
    
    
    
    // PickerView -  days data
    
    DaysArray = [[NSMutableArray alloc]init];
    
    for (int i = 1; i <= 31; i++)
    {
        [DaysArray addObject:[NSString stringWithFormat:@"%02d",i]];
        
    }

}

-(id)initWithPicker{
    //空够足够多的行，确保放得下视图
    NSString* titleBlank = @"\n\n\n\n\n\n\n\n\n\n\n";
    self = [super initWithTitle:titleBlank
                       delegate:nil
              cancelButtonTitle:@"确定"
         destructiveButtonTitle:nil
              otherButtonTitles:nil];
    if (self) {
        //初始化pickView所需要的数据
        self.customPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(10.0, 0.0, 300,300)];
        self.customPicker.delegate = self;
        self.customPicker.dataSource = self;

        [self addSubview:self.customPicker];

        //初始设置当前时间
        NSDate *date = [NSDate date];
        // Get Current Year
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy"];
        
        NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                       [formatter stringFromDate:date]];
        
        
        // Get Current  Month
        
        [formatter setDateFormat:@"MM"];
        
        currentMonthString = [NSString stringWithFormat:@"%d",[[formatter stringFromDate:date]integerValue]];
        
        
        // Get Current  Date
        
        [formatter setDateFormat:@"dd"];
        NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        
        
        // Get Current  Hour
        [formatter setDateFormat:@"hh"];
        NSString *currentHourString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        
        // Get Current  Minutes
        [formatter setDateFormat:@"mm"];
        NSString *currentMinutesString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        
        [self initpickerViewData];
 
        // PickerView - Default Selection as per current Date
        
        [self.customPicker selectRow:[yearArray indexOfObject:currentyearString] inComponent:0 animated:YES];
        selectedYearRow =[yearArray indexOfObject:currentyearString];
        [self.customPicker selectRow:[monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];
        selectedMonthRow =[monthArray indexOfObject:currentMonthString];
        [self.customPicker selectRow:[DaysArray indexOfObject:currentDateString] inComponent:2 animated:YES];
        selectedDayRow =[DaysArray indexOfObject:currentDateString];
        [self.customPicker selectRow:[hoursArray indexOfObject:currentHourString] inComponent:3 animated:YES];
        selectedHourRow =[hoursArray indexOfObject:currentHourString];
        [self.customPicker selectRow:[minutesArray indexOfObject:currentMinutesString] inComponent:4 animated:YES];
        selectedMinuteRow =[minutesArray indexOfObject:currentMinutesString];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - UIPickerViewDelegate


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        selectedYearRow = row;
        [self.customPicker reloadAllComponents];
    }
    else if (component == 1)
    {
        selectedMonthRow = row;
        [self.customPicker reloadAllComponents];
    }
    else if (component == 2)
    {
        selectedDayRow = row;
        
        [self.customPicker reloadAllComponents];
        
    }
    else if (component ==3)
    {
        selectedHourRow = row;
    }
    else if (component == 4)
    {
        selectedMinuteRow = row;
    }
 }


#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    
    
    
    if (component == 0)
    {
        pickerLabel.text =  [yearArray objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [monthArray objectAtIndex:row];  // Month
    }
    else if (component == 2)
    {
        pickerLabel.text =  [DaysArray objectAtIndex:row]; // Date
        
    }
    else if (component == 3)
    {
        pickerLabel.text =  [hoursArray objectAtIndex:row]; // Hours
    }
    else if (component == 4)
    {
        pickerLabel.text =  [minutesArray objectAtIndex:row]; // Mins
    }

    
    return pickerLabel;
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 5;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        return [yearArray count];
        
    }
    else if (component == 1)
    {
        return [monthArray count];
    }
    else if (component == 2)
    { // day
        
        if (selectedMonthRow == 0 || selectedMonthRow == 2 || selectedMonthRow == 4 || selectedMonthRow == 6 || selectedMonthRow == 7 || selectedMonthRow == 9 || selectedMonthRow == 11)
        {
            return 31;
        }
        else if (selectedMonthRow == 1)
        {
            int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
            if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                return 29;
            }
            else
            {
                return 28; // or return 29
            }
                
                
        }
        else
        {
            return 30;
        }

        
    }
    else if (component == 3)
    { // hour
        
        return 24;
        
    }
    else
    { // min
        return 60;
    }
    
}

@end
