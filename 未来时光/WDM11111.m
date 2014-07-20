//
//  WDM11111.m
//  未来时光
//
//  Created by Windream on 14-5-19.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import "WDM11111.h"

@implementation WDM11111


-(id)initWithPicker{
    //空够足够多的行，确保放得下视图
    NSString* titleBlank = @"\n\n\n\n\n\n\n\n\n\n";
    self = [super initWithTitle:titleBlank
                       delegate:nil
              cancelButtonTitle:@"确定"
         destructiveButtonTitle:nil
              otherButtonTitles:nil];
    if (self) {
        
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

@end
