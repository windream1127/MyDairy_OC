//
//  WDMWeatherView.m
//  未来时光
//
//  Created by Windream on 14-6-4.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import "WDMWeatherView.h"
#import "NSDictionary+weather.h"
#import "NSDictionary+weather_package.h"
#import "IIViewDeckController.h"
#import "CommomMacro.h"
#import "UIView+Common.h"
@interface WDMWeatherView ()
@property(strong) NSDictionary *weather;
@end

@implementation WDMWeatherView

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)reload{
    [self.locationManager startUpdatingLocation];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //左按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"<<<" style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClickHandler:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!self.weather)
        return 0;
    switch (section) {
        case 0: {
            return 1; }
        case 1: {
            NSArray *upcomingWeather = [self.weather upcomingWeather];
            return [upcomingWeather count];
        } default:
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weatherIdentifier" ];//forIndexPath:indexPath];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"weatherIdentifier"];
    }
    NSDictionary *daysWeather = nil;
    switch (indexPath.section) {
        case 0: {
            daysWeather = [self.weather currentCondition];
            break; }
        case 1: {
            NSArray *upcomingWeather = [self.weather upcomingWeather];
            daysWeather = upcomingWeather[indexPath.row];
            break;
        }
        default:
            break;
    }
    cell.textLabel.text = [daysWeather weatherDescription];
    // You will add code here later to customize the cell, but it's good for now.
    cell.textLabel.text = [daysWeather weatherDescription];
    NSURL *url = [NSURL URLWithString:daysWeather.weatherIconURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    __weak UITableViewCell *weakCell = cell;
    
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
     {
         weakCell.imageView.image = image;
         [weakCell setNeedsLayout];
     }
                                   failure:nil];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray*)locations
{
    // Last object contains the most recent location
    CLLocation *newLocation = [locations lastObject];
    // If the location is more than 5 minutes old, ignore it
    if([newLocation.timestamp timeIntervalSinceNow] > 300)
        return;
    [self.locationManager stopUpdatingLocation];
    WDMWeatherHTTPClient *client = [WDMWeatherHTTPClient sharedWeatherHTTPClient];
    client.delegate = self;
    [client updateWeatherAtLocation:newLocation forNumberOfDays:5];
}
#pragma mark - WeatherHTTPClientDelegate
- (void)weatherHTTPClient:(WDMWeatherHTTPClient *)client
     didUpdateWithWeather:(id)weather
{
    [self.refreshControl endRefreshing];
    self.weather = weather;
    self.title = @"天气预报";
    [self.tableView reloadData];
}
- (void)weatherHTTPClient:(WDMWeatherHTTPClient *)client didFailWithError:(NSError
                                                                        *)error
{
    [self.refreshControl endRefreshing];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"天气获取失败"
                                                       message:[NSString stringWithFormat:@"%@",error]
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [alertView show];
}

#pragma mark -private
- (void)leftButtonClickHandler:(id)sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}
@end
