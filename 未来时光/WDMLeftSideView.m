//
//  WDMLeftSideView.m
//  未来时光
//
//  Created by Windream on 14-5-4.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import "WDMLeftSideView.h"
#import "IIViewDeckController.h"
#import "WDMDairyView.h"
#import "WDMShareView.h"
#import "WDMNotificationView.h"
#import "WDMWeatherView.h"
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
@interface WDMLeftSideView ()

@end

@implementation WDMLeftSideView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IndexBG.png"]];
    bgImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    bgImageView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:bgImageView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0,45.0, self.view.width, self.view.height) style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.sectionHeaderHeight = 32;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
    
    NSArray *array = [[NSArray alloc]initWithObjects:
                      @"日记",
                      @"提醒",
                      @"心情分享",
                      @"天气预报",
                      nil];
    self.listData = array;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -private
-(void)goBackRoot:(id)sender{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        
        WDMDairyView *root = [[WDMDairyView alloc]init];
        UINavigationController *rootVC = [[UINavigationController alloc] initWithRootViewController:root];
        self.viewDeckController.centerController = rootVC;
        
        self.view.userInteractionEnabled = YES;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TablIdentifier = @"TablIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TablIdentifier];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TablIdentifier];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [self.listData objectAtIndex:row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
    cell.backgroundColor = [UIColor clearColor];
    UIImageView *lineView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"IndexLine.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1]];
    lineView.frame = CGRectMake(0.0, cell.contentView.height, cell.contentView.width, lineView.height);
    lineView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [cell addSubview:lineView];
    return cell;
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - UITableViewDalegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        self.view.userInteractionEnabled = NO;
        case 0:
        {
            [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
                
                WDMDairyView *root = [[WDMDairyView alloc]init];
                UINavigationController *rootVC = [[UINavigationController alloc] initWithRootViewController:root];
                self.viewDeckController.centerController = rootVC;
                
                self.view.userInteractionEnabled = YES;
            }];
            break;
        }
        case 1:
        {
            [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
                
                WDMNotificationView *root = [[WDMNotificationView alloc]init];
                UINavigationController *rootVC = [[UINavigationController alloc] initWithRootViewController:root];
                self.viewDeckController.centerController = rootVC;
                
                self.view.userInteractionEnabled = YES;
            }];
            break;
        }
        case 2:
        {
            [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
                
                WDMShareView *root = [[WDMShareView alloc]init];
                UINavigationController *rootVC = [[UINavigationController alloc] initWithRootViewController:root];
                self.viewDeckController.centerController = rootVC;
                
                self.view.userInteractionEnabled = YES;
            }];
            break;
        }
        case 3:
        {
            [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
                
                WDMWeatherView *root = [[WDMWeatherView alloc]init];
                UINavigationController *rootVC = [[UINavigationController alloc] initWithRootViewController:root];
                self.viewDeckController.centerController = rootVC;
                
                self.view.userInteractionEnabled = YES;
            }];
            break;
        }
        default:
            break;
    }
}


@end
