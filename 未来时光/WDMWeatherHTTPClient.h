//
//  WDMWeatherHTTPClient.h
//  未来时光
//
//  Created by Windream on 14-6-4.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFHTTPSessionManager.h"
#import <CoreLocation/CoreLocation.h>
@protocol WeatherHTTPClientDelegate;
@interface WDMWeatherHTTPClient : AFHTTPSessionManager

@property (nonatomic, weak) id<WeatherHTTPClientDelegate>delegate;

+ (WDMWeatherHTTPClient *)sharedWeatherHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)updateWeatherAtLocation:(CLLocation *)location
                forNumberOfDays:(NSUInteger)number;
@end

@protocol WeatherHTTPClientDelegate <NSObject>
@optional
-(void)weatherHTTPClient:(WDMWeatherHTTPClient *)client
    didUpdateWithWeather:(id)weather;
-(void)weatherHTTPClient:(WDMWeatherHTTPClient *)client didFailWithError:(NSError
                                                                       *)error;
@end
