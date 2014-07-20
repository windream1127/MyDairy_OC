//
//  WDMDairyDetaiView.m
//  未来时光
//
//  Created by Windream on 14-5-6.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import "WDMDairyDetaiView.h"
#import "ShareSDK/ShareSDK.h"
#import "WDMActionSheet.h"
#import "WDM11111.h"
@interface WDMDairyDetaiView ()

@end

@implementation WDMDairyDetaiView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//保存数据
- (void)save{
    NSLog(@"保存按钮");
    
    int index;
    DairyBL *bl = [[DairyBL alloc]init];
    //获得dairy的标题（第一段字符串）
    for (index=0; index!=self.contentDetail.text.length; index++) {
        if ('\n' == [self.contentDetail.text characterAtIndex:index]) {
            break;
        }
    }
    if (0 == self.contentDetail.text.length) {
        
        [self.navigationController popViewControllerAnimated:YES];//返回上一个页面
        
    }
    else{
        self.dairy.title = [self.contentDetail.text substringToIndex:index];
        self.dairy.content = self.contentDetail.text;
        self.dairy.date = [[NSDate alloc]init];
        
        if (self.flag) {
            [bl createDairy:self.dairy];
        }
        else{
            [bl modify:self.dairy];
            
        }
    }
    
    
    [self.contentDetail resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor grayColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    self.view.autoresizesSubviews =UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view.backgroundColor = [UIColor whiteColor];
    //标题
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.navigationItem.title = [dateformatter stringFromDate:self.dairy.date];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    //textView
    self.contentDetail = [[UITextView alloc]initWithFrame:CGRectMake(0.0,0.0, self.view.width, self.view.height-45)];
    self.contentDetail.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentDetail.text = self.dairy.content;
    self.contentDetail.font = [UIFont systemFontOfSize:18.0f];
    [self.view addSubview:self.contentDetail];
    

    //添加个工具条
    self.toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0,self.view.height - 45, self.view.width, 45)];
    self.toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
//    self.toolBar.backgroundColor = [UIColor blackColor];
    
    self.notify = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 10.0, 70, 30.0)];
    [self.notify setImage:[UIImage imageNamed:@"11.png"] forState:UIControlStateNormal];
    [self.notify addTarget:self action:@selector(notify:) forControlEvents:UIControlEventTouchUpInside];

    self.share = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 10.0, 70, 30.0)];
    [self.share setImage:[UIImage imageNamed:@"ShareButtonIcon.png"] forState:UIControlStateNormal];
    [self.share addTarget:self action:@selector(Share:) forControlEvents:UIControlEventTouchUpInside];
    
    self.canle = [[UISwitch alloc]initWithFrame:CGRectMake(0.0, 6.0, 80, 30.0)];
    [self.canle  addTarget:self action:@selector(cancelNotification) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *notify = [[UIBarButtonItem alloc] initWithCustomView:self.notify];
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithCustomView:self.share];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithCustomView:self.canle];

    //[nextStepBarBtn setWidth:1080];
    
    UIButton *s = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.width*0.2, 30.0)];
    s.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    UIBarButtonItem *spaceButtonItem=[[UIBarButtonItem alloc]initWithCustomView:s];
    
    self.toolBar.items = @[spaceButtonItem,cancel ,notify,share];

    [self.view addSubview:self.toolBar];

    [self.canle setOn:YES animated:YES];
    //初始化textView
    self.title = self.dairy.title;
    self.contentDetail.delegate = self;
    
    if (self.flag == 1) {
        [self.contentDetail becomeFirstResponder];
    }
}
-(IBAction)notify:(id)sender{
    self.actionSheet = [[WDMActionSheet alloc]initWithPicker];
    self.actionSheet.delegate = self;
    [self.actionSheet showInView:self.view];

}
//-(IBAction)BUTTONtext:send{
//    self.actionSheet = [[WDMActionSheet alloc]initWithPicker];
//    self.actionSheet.delegate = self;
////    [self.actionSheet showInView:self.view];
//    [self.actionSheet showFromBarButtonItem:self.notify animated:YES];
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // to update NoteView
    [self.contentDetail setNeedsDisplay];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //监听键盘出现
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleKeyboadDidShow:)
     name:UIKeyboardDidShowNotification
     object:nil];
    //监听键盘消失
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleKeyboadWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];

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
#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"保存"
                                  style:UIBarButtonItemStyleDone
                                  target:self
                                  action:@selector(save)];
    
    self.navigationItem.rightBarButtonItem = newButton;
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    
    self.navigationItem.rightBarButtonItem = nil;
}
#pragma mark -监听方法
-(void)handleKeyboadDidShow:(NSNotification *)paramNotification{
    NSValue *keyboardRectAsObject = [[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];
//    self.contentDetail.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, keyboardRect.size.height, 0.0f);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    CGRect frame = self.view.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height - keyboardRect.size.height + 45);
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

-(void)handleKeyboadWillHide:(NSNotification *)paramNotification{
    
//    self.contentDetail.contentInset = UIEdgeInsetsZero;
    NSValue *keyboardRectAsObject = [[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    CGRect frame = self.view.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height + keyboardRect.size.height - 45);
    [self.view setFrame:frame];
    
    [UIView commitAnimations];
}

#pragma mark -分享
-(void)Share:(id)sender{
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:self.dairy.content
                                       defaultContent:@""
                                                image:nil
                                                title:@"123"
                                                  url:@"http://www.xiami.com"
                                          description:@"分享"
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
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:nil],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:nil],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"分享内容"
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

#pragma -mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat  = @"yyyy/MM/dd HH:mm";
    NSString *str = [formatter stringFromDate:self.actionSheet.dateSelected];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"时间" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [self ButtonClick:self.actionSheet.dateSelected];
    NSLog(@"%@",str);
}

#pragma -mark 设置消息通知
-(void)ButtonClick:(NSDate *)endDate{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        
        NSDate *now=[NSDate new];
        NSTimeInterval timeInterval = [endDate timeIntervalSinceNow];
        notification.fireDate=[now dateByAddingTimeInterval:timeInterval]; //触发通知的时间
        notification.repeatInterval=0; //循环次数，kCFCalendarUnitWeekday一周一次
        
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertBody=self.dairy.title;
        
        notification.alertAction = @"打开";  //提示框按钮
        notification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
        
        notification.applicationIconBadgeNumber = 1; //设置app图标右上角的数字
        
        //下面设置本地通知发送的消息，这个消息可以接受
        NSString *key = [NSString stringWithFormat:@"%i",self.dairy.ID];
        NSString *value   =  @"notification";
        NSDictionary* infoDic = [NSDictionary dictionaryWithObject:value forKey:key];
        notification.userInfo = infoDic;
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

-(void)cancelNotification{
    if (!self.canle.on) {
        //设置通知按钮隐藏
        [self.notify setHidden:YES];
        //取消某一个通知
        NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
        //获取当前所有的本地通知
        if (!notificaitons || notificaitons.count <= 0) {
            return;
        }
        for (UILocalNotification *notify in notificaitons) {
            NSString *key = [NSString stringWithFormat:@"%i",self.dairy.ID];
            
            if ([[notify.userInfo objectForKey:key] isEqualToString:@"notification"]) {
                //取消一个特定的通知
                [[UIApplication sharedApplication] cancelLocalNotification:notify];
                NSLog(@"取消了通知%@",key);
                break;
            }
        }

    }
    else{
        [self.notify setHidden:NO];
    }
    //取消所有的本地通知
    //    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
@end
