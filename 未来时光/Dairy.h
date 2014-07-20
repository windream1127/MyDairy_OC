//
//  Dairy.h
//  底层功能
//
//  Created by Windream on 14-3-12.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dairy : NSObject

@property(nonatomic, strong) NSDate* date;
@property(nonatomic, strong) NSString* content;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, assign) NSUInteger ID;

@end
