//
//  WDMCenterView.m
//  未来时光
//
//  Created by Windream on 14-5-4.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import "WDMCenterView.h"
#import "IIViewDeckController.h"
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
@interface WDMCenterView ()

@end

@implementation WDMCenterView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
//        self.tabBarController.tabBar.translucent = NO;
    }
    [[UINavigationBar appearance] setBarTintColor:[UIColor grayColor]];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, 320-100, 40)];
    title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [title setText:@"主页面"];
    title.font = [UIFont systemFontOfSize:17];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = title;
    
    
    if (self.labelTitle != nil) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(50, 80, 320-50-50, 40)];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.label setText:self.labelTitle];
        self.label.font = [UIFont systemFontOfSize:17];
        self.label.textColor = RGBCOLOR(0x11, 0x11, 0x11);
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.backgroundColor = [UIColor blueColor];
        [self.view addSubview:self.label];
    }
    
    
    //左按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"左按钮" style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClickHandler:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    //右按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"右按钮" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClickHandler:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor greenColor];
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
- (void)leftButtonClickHandler:(id)sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (void)rightButtonClickHandler:(id)sender
{
    [self.viewDeckController toggleRightViewAnimated:YES];
}
@end

