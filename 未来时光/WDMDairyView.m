//
//  WDMDairyView.m
//  未来时光
//
//  Created by Windream on 14-5-6.
//  Copyright (c) 2014年 Windream. All rights reserved.
//

#import "WDMDairyView.h"
#import "IIViewDeckController.h"
#import "CommomMacro.h"
#import "UIView+Common.h"
#import "DairyBL.h"
@interface WDMDairyView ()

@end

@implementation WDMDairyView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.TableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.SearchBar.bounds));
    self.listData = [self.bl findAll];
    [self filterContentForSearchText:@"" scope:-1];
    [self.TableView reloadData];
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
        //        self.tabBarController.tabBar.translucent = NO;
    }

    //左按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"<<<" style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClickHandler:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    //右按钮
    UIBarButtonItem *NewButton = [[UIBarButtonItem alloc]initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(creatNewDairy)];

    //右按钮
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]init];
    editButton = self.editButtonItem;
    
    NSArray *rightButton = @[NewButton, editButton];
    self.navigationItem.rightBarButtonItems = rightButton;
    [[UINavigationBar appearance] setBarTintColor:[UIColor grayColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //标题
    self.navigationItem.title = @"日记";
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    //背景颜色
    self.view.backgroundColor = [UIColor grayColor];
    
    //搜索栏
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
//    self.SearchBar.placeholder = @"Search";
    self.SearchBar.delegate = self;
//    self.SearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.width, 40)];
    self.SearchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.SearchBar sizeToFit];
    
//    [self.view addSubview:self.SearchBar];
    //tableView
//    self.TableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0,CGRectGetHeight(self.SearchBar.bounds), self.view.width, self.view.height) style:UITableViewStylePlain];
    self.TableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0,0.0, self.view.width, self.view.height) style:UITableViewStylePlain];
    self.TableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.TableView.dataSource = self;
    self.TableView.delegate = self;
    self.TableView.backgroundView = nil;
    [self.view addSubview:self.TableView];
    
    //隐藏搜索栏
    self.TableView.tableHeaderView = self.SearchBar;
    
    
    self.SearchDisplayController=[[UISearchDisplayController alloc]
                                  initWithSearchBar:self.SearchBar
                                  contentsController:self];//传入创建的tableVIew
    self.SearchDisplayController.delegate = self;
    self.SearchDisplayController.searchResultsDataSource = self;
    self.SearchDisplayController.searchResultsDelegate = self;

    self.bl = [[DairyBL alloc] init];
    self.listData = [self.bl findAll];
    [self filterContentForSearchText:@"" scope:-1];
    
    
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.TableView setEditing:editing animated:animated];
    if (self.editing) {
        
        self.editButtonItem.title = @"完成";
        }
    else {
        self.editButtonItem.title = @"编辑";
    }
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
- (void)creatNewDairy{
    
    NSLog(@"newDairy按钮！");
    
    Dairy *newdairy = [[Dairy alloc]init];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *name = [dateformatter stringFromDate:[[NSDate alloc]init]];
    newdairy.title = name;
    newdairy.content = @"";
    newdairy.date = [[NSDate alloc]init];
    WDMDairyDetaiView *dairyDetail =[[WDMDairyDetaiView alloc]init];
    dairyDetail.dairy = newdairy;
    dairyDetail.flag = NEW;
    
    [self.navigationController pushViewController:dairyDetail animated:YES];
}
#pragma mark - UITableViewDataSource
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listFilter.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TablIdentifier = @"TablIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TablIdentifier];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TablIdentifier];
    }

    Dairy *dairy = [self.listFilter objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [dateFormatter stringFromDate:dairy.date];
    
    cell.textLabel.text = dairy.title;
    cell.detailTextLabel.text = date;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    UIImageView *lineView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"IndexLine.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1]];
    lineView.frame = CGRectMake(10.0, cell.contentView.height - lineView.width, cell.contentView.width, 1);
    lineView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [cell addSubview:lineView];
    
    return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Dairy *dairy = [[Dairy alloc]init];
        dairy = [self.listData objectAtIndex:indexPath.row];
        self.listData = [self.bl remove:dairy];
        [self filterContentForSearchText:@"" scope:-1];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.SearchBar resignFirstResponder];
    WDMDairyDetaiView *dairyDetail =[[WDMDairyDetaiView alloc]init];
    dairyDetail.dairy = [self.listData objectAtIndex:indexPath.row];
    dairyDetail.flag = LOOKUP;
//    dairyDetail.hidesBottomBarWhenPushed = NO;
//    [self.navigationController setToolbarHidden:NO animated:YES];
    [self.navigationController pushViewController:dairyDetail animated:YES];
    //    [self performSelector:@selector(hideSearch) withObject:nil afterDelay:0.5f];
    
}
#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSUInteger)scope;
{
    
    if([searchText length]==0)
    {
        //查询所有
        self.listFilter = [NSMutableArray arrayWithArray:self.listData];
        return;
    }
    
    NSPredicate *scopePredicate;
    NSArray *tempArray ;
    
    switch (scope) {
        case 1:
            scopePredicate = [NSPredicate predicateWithFormat:@"SELF.content contains[c] %@",searchText];
            tempArray =[self.listData filteredArrayUsingPredicate:scopePredicate];
            self.listFilter = [NSMutableArray arrayWithArray:tempArray];
            
            break;
        default:
            //查询所有
            self.listFilter = [NSMutableArray arrayWithArray:self.listData];
            break;
    }
}

#pragma mark -private
- (void)leftButtonClickHandler:(id)sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

#pragma mark - SearchBar delegate
//-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
//    self.SearchBar.showsCancelButton = YES;
//}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [self filterContentForSearchText:@"" scope:-1];
}

#pragma mark - UISearchDisplayController Delegate Methods
//当文本内容发生改变时候，向表视图数据源发出重新加载消息
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:1];
    //YES情况下表视图可以重新加载
    return YES;
}

@end
