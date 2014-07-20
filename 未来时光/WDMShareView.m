//
//  WDMShareView.m
//  未来时光
//
//  Created by Windream on 14-5-5.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import "WDMShareView.h"
#import "ShareSDK/ShareSDK.h"
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
@interface WDMShareView ()

@end

@implementation WDMShareView

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
    // Do any additional setup after loading the view.
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 220, 40)];
        title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [title setText:@"分享页面"];
        title.font = [UIFont systemFontOfSize:17];
        title.textColor = RGBCOLOR(0x11, 0x11, 0x11);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        [self.view addSubview:title];
    
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        [button setTitle:@"分享"
                forState:UIControlStateNormal];
        button.frame = CGRectMake(60, 80, 320-60-160, 45.0);
        [button addTarget:self action:@selector(Share:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    
        self.view.backgroundColor = [UIColor whiteColor];
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
-(void)Share:(id)sender{
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"1234567890-"
                                       defaultContent:@""
                                                image:nil       //[ShareSDK imageWithPath:imagePath]
                                                title:@"123"
                                                  url:@"http://www.xiami.com"
                                          description:NSLocalizedString(@"TEXT_TEST_MSG", @"这是一条测试信息")
                                            mediaType:SSPublishContentMediaTypeNews];
    
    
    
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"111111"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"S11111"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:NSLocalizedString(@"TEXT_SHARE_TITLE", @"内容分享")
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:nil
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];

}
@end
