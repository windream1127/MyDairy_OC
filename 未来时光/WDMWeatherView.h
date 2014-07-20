//
//  WDMWeatherView.h
//  未来时光
//
//  Created by Windream on 14-6-4.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMWeatherHTTPClient.h"
@interface WDMWeatherView : UITableViewController<CLLocationManagerDelegate, WeatherHTTPClientDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@end
