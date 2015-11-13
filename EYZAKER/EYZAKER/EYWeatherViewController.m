//
//  EYWeatherViewController.m
//  EYZAKER
//
//  Created by mac on 14-9-25.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYWeatherViewController.h"
#import "EYSortCity.h"
#import "EYCityCell.h"
#import "EYRequest.h"

#define requestCitysURL @"http://iphone.myzaker.com/zaker/getcity.php"

@interface EYWeatherViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, EYRequestDelegate>

@property (nonatomic, strong)NSArray *cityData;
@property (nonatomic, strong)UITableView *tableView;
//索引
@property (nonatomic, strong)UITableView *indexView;
//搜索框
@property (nonatomic, strong)UITextField *searchField;
//请求城市
@property (nonatomic, strong)EYRequest *requestCity;
@end

@implementation EYWeatherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //给数据源赋值
        self.cityData = [EYSortCity sortCity];
    }
    return self;
}

- (UIImageView *)createNavigationBar
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    view.userInteractionEnabled = YES;
    view.image = [UIImage imageNamed:@"toolbar_bg"];
    //标题
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(32, 20, 150, 44)];
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont fontWithName:@"FZLanTingHei-DB-GBK" size:15];
    lable.text = @"选择你所在的城市";
    [view addSubview:lable];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 26, 32, 32)];
    backImage.image = [UIImage imageNamed:@"addRootBlock_toolbar_return"];
    [view addSubview:backImage];
    backImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [backImage addGestureRecognizer:tap];

    return view;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    //初始化导航条
    [self.view addSubview:[self createNavigationBar]];
    //初始化搜索框
    UIImageView *searchBar = [[UIImageView alloc] initWithFrame:CGRectMake(3, 67, 314, 34)];
    searchBar.userInteractionEnabled = YES;
    searchBar.image = [UIImage imageNamed:@"SearchBarBackground"];
    searchBar.contentMode = UIViewContentModeScaleToFill;
    
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10, 12, 12)];
    searchIcon.image = [UIImage imageNamed:@"SearchBarTextFieldIcon"];
    [searchBar addSubview:searchIcon];
    
    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(25, 2, 292, 30)];
    self.searchField.delegate = self;
    [searchBar addSubview:self.searchField];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInputWord) name:UITextFieldTextDidChangeNotification object:nil];

    [self.view addSubview:searchBar];
    
    //初始化tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, 320, self.view.frame.size.height - 104) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"EYCityCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    //初始化索引
    [self.view addSubview:[self createIndexView]];
    
    
}
//搜索框输入时调用
- (void)didInputWord
{
    self.cityData = [EYSortCity selectCityWithOption:self.searchField.text];
    [self.tableView reloadData];
}

//请求城市列表
- (void)getCity
{
    self.requestCity = [[EYRequest alloc] initRequestWithUrl:[NSURL URLWithString:requestCitysURL]];
    self.requestCity.delagate = self;
    [self.requestCity startAsynchronous];
}

#pragma mark - EYRequestDelegate
- (void)requestDidFinish:(EYRequest *)request
{
    
}
- (void)requestFailed:(EYRequest *)request
{
    
}


//初始化索引
- (UIView *)createIndexView
{
    UIView *indexView = [[UIView alloc] initWithFrame:CGRectMake(305, 101, 13, 351)];
    UILabel *first = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
    first.text = @"#";
    first.textColor = [UIColor darkGrayColor];
    first.textAlignment = NSTextAlignmentCenter;
    first.font = [UIFont boldSystemFontOfSize:10];
    first.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSection:)];
    [first addGestureRecognizer:tap];
    [indexView addSubview:first];
    
    for (NSInteger i = 0; i < 26; i++) {
        UILabel *index = [[UILabel alloc] initWithFrame:CGRectMake(0, 13 * (i + 1), 13, 13)];
        index.text = [NSString stringWithFormat:@"%c", i + 97];
        index.textColor = [UIColor darkGrayColor];
        index.font = [UIFont boldSystemFontOfSize:10];
        index.textAlignment = NSTextAlignmentCenter;
        index.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSection:)];
        [index addGestureRecognizer:tap1];

        [indexView addSubview:index];
    }
    return indexView;
}
//索引，跳转到指定段
- (void)gotoSection:(UITapGestureRecognizer *)tap
{
    UILabel *lable = (UILabel *)[tap view];
    NSInteger section;
    if ([lable.text isEqualToString:@"#"]) {
        section = 0;
    }
    else {
        unichar c = [lable.text characterAtIndex:0];
        section = c - 96;
    }
    if ([self.cityData[section] count] == 0) {
        return;
    }
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:section];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDelegate
//设置段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.cityData[section] count] == 0) {
        return 0;
    }
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
//设置段头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    if (section == 0) {
        lable.text = @"   热门城市";
    } else {
        lable.text = [NSString stringWithFormat:@"   %c", section + 64];
    }
    lable.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    lable.font = [UIFont fontWithName:@"FZLanTingHei-R-GBK" size:11];
    return lable;
}
//选择cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = self.cityData[indexPath.section];
    [userDefaults setObject:array[indexPath.row] forKey:@"selectCity"];
    [userDefaults synchronize];
    [tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - UITableViewDataSource
//返回段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityData.count;
}
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *citys = self.cityData[section];
    return citys.count;
}
//cell
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     EYCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
     
     NSArray *citys = self.cityData[indexPath.section];
     [cell fillCellWithName:citys[indexPath.row]];
     
     NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
     NSString *selectCity = [userDefaults objectForKey:@"selectCity"];
     if ([citys[indexPath.row] isEqualToString:selectCity]) {
         [cell selected:YES];
     }
     else
     {
         [cell selected:NO];
     }
     return cell;
 }

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.requestCity cancel];
    self.tabBarController.tabBar.hidden = NO;
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

@end
