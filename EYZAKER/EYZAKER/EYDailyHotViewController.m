//
//  EYDailyHotViewController.m
//  EYZAKER
//
//  Created by mac on 14-9-24.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYDailyHotViewController.h"
#import "EYDailyHotCellA.h"
#import "EYDailyHotCellB.h"
#import "EYRequest.h"
#import "EYDailyHotModal.h"
#import "MJRefresh.h"
#import "EYContentView.h"

@interface EYDailyHotViewController () <UITableViewDataSource, UITableViewDelegate, EYRequestDelegate, MJRefreshBaseViewDelegate>
//显示文章信息
@property (nonatomic, strong)UITableView *tableView;
//数据源
@property (nonatomic, strong)NSMutableArray *articles;

@property (nonatomic, strong)MJRefreshHeaderView *headerView;
@property (nonatomic, strong)MJRefreshFooterView *footerView;
@property (nonatomic, strong)MJRefreshBaseView *baseView;
@end

@implementation EYDailyHotViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"推荐" image:[UIImage imageNamed:@"DashboardTabBarItemDailyHot"] tag:0];
        self.tabBarItem = tabBarItem;
        
        self.articles = [NSMutableArray array];
        
        
    }
    return self;
}

- (UIImageView *)createNavigationBar
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    view.userInteractionEnabled = YES;
    view.image = [UIImage imageNamed:@"toolbar_bg"];
    //标题
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(140, 20, 40, 44)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont fontWithName:@"FZLanTingHei-DB-GBK" size:17];
    lable.text = @"推荐";
    [view addSubview:lable];
    
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(288, 26, 32, 32)];
    leftImage.image = [UIImage imageNamed:@"DailyHot_PreferencesButton"];
    [view addSubview:leftImage];
    leftImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readPreference)];
    [leftImage addGestureRecognizer:tap];
    
    return view;
}

- (void)readPreference
{
    NSLog(@"####");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:[self createNavigationBar]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49)];
    self.tableView.hidden = YES;
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.headerView = [[MJRefreshHeaderView alloc] initWithScrollView:self.tableView];
    self.headerView.delegate = self;
    self.footerView = [[MJRefreshFooterView alloc] initWithScrollView:self.tableView];
    self.footerView.delegate = self;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EYDailyHotCellA" bundle:nil] forCellReuseIdentifier:@"A"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EYDailyHotCellB" bundle:nil] forCellReuseIdentifier:@"B"];
    
    [self.view addSubview:self.tableView];
    [self createRequest];
    
    
}

#pragma mark MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //保存正在刷新的view
    self.baseView = refreshView;
    [self createRequest];
}


- (void)createRequest
{
    NSTimeInterval timeri = [[NSDate date] timeIntervalSince1970];
    NSLog(@"%lf",timeri);
    NSString *time = [NSString stringWithFormat:@"%lf", timeri];
    NSString *ttt = [time substringToIndex:10];
    NSString *url = [NSString stringWithFormat:@"http://hotphone.myzaker.com/daily_hot_new.php?_appid=AndroidPhone&_bsize=720_1280&_udid=860310021635752&_v=4.4.3&_version=4.51&act=pre&last_time=%@&rank=44991", ttt];
    NSLog(@"%@", url);
    EYRequest *request = [[EYRequest alloc] initRequestWithUrl:[NSURL URLWithString:@"http://hotphone.myzaker.com/daily_hot_new.php?_appid=AndroidPhone&_bsize=720_1280&_udid=860310021635752&_v=4.4.3&_version=4.51&act=pre&last_time=1411822598&rank=52985"]];
    request.delagate = self;
    [request startAsynchronous];
    
}

#pragma mark - EYRequestDelegate
- (void)requestDidFinish:(EYRequest *)request
{
    NSInteger refreshType;//标记为是上拉刷新还是下拉加载，从而改变数据源
    //停止刷新
    if (self.baseView == self.headerView)
    {
        [self.headerView endRefreshing];
        refreshType = 1;
    }
    else
    {
        [self.footerView endRefreshing];
        refreshType = 2;
    }
    
    //解析
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *array = dic[@"data"][@"articles"];
    
    for (NSDictionary *article in array) {
        EYDailyHotModal *modal = [[EYDailyHotModal alloc] init];
        modal.title = article[@"title"];
        modal.autherName = article[@"auther_name"];
        modal.clickURL = article[@"weburl"];
        //判断是否有日期
        NSString *date = article[@"date"];
        if (date != nil) {
            NSRange range = {5,5};
            modal.date = [date substringWithRange:range];
        }
        //添加图片
        if ([[article allKeys] containsObject:@"thumbnail_medias"]) {
            NSArray *medias = article[@"thumbnail_medias"];
            for (NSDictionary *media in medias) {
                [modal.imagesURL addObject:media[@"m_url"]];
            }
            //是否显示一张图片
            if (modal.imagesURL.count > 0 && modal.imagesURL.count < 3) {
                modal.showOneImage = YES;
            }
            else if (modal.imagesURL.count == 0) {
                modal.noneImage = YES;
            }
        }
        //添加标记小图片
        NSDictionary *info = article[@"special_info"];
        if ([[info allKeys] containsObject:@"icon_url"]) {
            modal.iconURL = info[@"icon_url"];
        }
        //标题高度
        unichar type;
        if (modal.showOneImage) {
            type = 'B';
        } else {
            type = 'A';
        }
        modal.titleLableHight = [self getLableSizeWithText:modal.title type:type];
        
        if (refreshType == 1) {
            [self.articles insertObject:modal atIndex:0];
        }
        else
        {
            [self.articles addObject:modal];
        }
    }
    
    self.tableView.hidden = NO;

    [self.tableView reloadData];
}

- (void)requestFailed:(EYRequest *)request
{
    self.tableView.hidden = YES;
    //停止刷新
    if (self.baseView == self.headerView)
    {
        [self.headerView endRefreshing];
    }
    else
    {
        [self.footerView endRefreshing];
    }

}

//求lable的高度或宽度
- (CGFloat)getLableSizeWithText:(NSString *)content type:(unichar)flag
{
    CGSize size;
    if (flag == 'A') {
        size = CGSizeMake(310, 100);
    }
    else
    {
        size = CGSizeMake(205, 100);
    }
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        CGRect rect = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
        return rect.size.height + 1;
    }
    else
    {
        CGSize siZe = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size];
        return siZe.height + 1;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EYDailyHotModal *modal = self.articles[indexPath.row];
    if (modal.showOneImage) {
        return 80;
    }
    return 10 + modal.titleLableHight + 5 + 10 + (modal.imagesURL.count >= 3 ? 75 : 0) + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EYDailyHotModal *modal = self.articles[indexPath.row];
    EYContentView *contentView = [[EYContentView alloc] init];
    contentView.webRequestURL = modal.clickURL;
    [self presentViewController:contentView animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.articles.count > 0) {
        
        EYDailyHotModal *modal = self.articles[indexPath.row];
        
        if (modal.showOneImage) {
            //显示一张图片
            EYDailyHotCellB *cell = [tableView dequeueReusableCellWithIdentifier:@"B"];
            [cell setCellWithModal:modal];
            return cell;
        }
        else
        {
            //不显示图片或者显示三张图片
            EYDailyHotCellA *cell = [tableView dequeueReusableCellWithIdentifier:@"A"];
            [cell setCellWithModal:modal];
            return cell;
        }
    }
    else {
        //防止刷新是崩掉
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        }
        
        return cell;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    //释放资源
    [self.headerView free];
    [self.footerView free];
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
