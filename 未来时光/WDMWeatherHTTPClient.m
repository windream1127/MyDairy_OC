//
//  WDMWeatherHTTPClient.m
//  未来时光
//
//  Created by Windream on 14-6-4.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import "WDMWeatherHTTPClient.h"
@implementation WDMWeatherHTTPClient
// Set this to your World Weather Online API Key
static NSString * const WorldWeatherOnlineAPIKey = @"727423daf36a3ebbceda3ffd5d47d12eac585d29";
static NSString * const WorldWeatherOnlineURLString = @"http://api.worldweatheronline.com/free/v1/";

//单例
+ (WDMWeatherHTTPClient *)sharedWeatherHTTPClient;
{
    static WDMWeatherHTTPClient *_sharedWeatherHTTPClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWeatherHTTPClient = [[self alloc] initWithBaseURL:[NSURL
                                                                  URLWithString:WorldWeatherOnlineURLString]];
    });
    return _sharedWeatherHTTPClient;
}

//根据url初始化
- (instancetype)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

//获取地点（location）几天（number）的天气数据
- (void)updateWeatherAtLocation:(CLLocation *)location
                forNumberOfDays:(NSUInteger)number{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"num_of_days"] = @(number);
    parameters[@"q"] = [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
    parameters[@"format"] = @"json";
    parameters[@"key"] = WorldWeatherOnlineAPIKey;
    [self GET:@"weather.ashx" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate
             respondsToSelector:@selector(weatherHTTPClient:didUpdateWithWeather:)]) {
            [self.delegate weatherHTTPClient:self
                        didUpdateWithWeather:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate
             respondsToSelector:@selector(weatherHTTPClient:didFailWithError:)]) {
            [self.delegate weatherHTTPClient:self didFailWithError:error];
        }
    }];
}
@end
