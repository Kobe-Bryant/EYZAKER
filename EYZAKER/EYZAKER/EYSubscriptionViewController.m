//
//  EYSubscriptionViewController.m
//  EYZAKER
//
//  Created by mac on 14-9-24.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYSubscriptionViewController.h"
#import "EYWeatherViewController.h"
#import "EYRequest.h"
#import "UIImageView+WebCache.h"
#import "EYRootBlocksModal.h"
#import "EYBlockView.h"
#import "EYChannelView.h"
#import "EYscrollImageView.h"

@interface EYSubscriptionViewController () <EYRequestDelegate, UIScrollViewDelegate>
//自定义导航条
@property (nonatomic, strong)UIImageView *navigationView;
//显示天气信息
@property (nonatomic, strong)UIView *showWeatherView;
//显示滚动图片
@property (nonatomic, strong)UIScrollView *showImageView;
//显示页数
@property (nonatomic, strong)UIPageControl *pageControl;
//显示基本信息
@property (nonatomic, strong)UIScrollView *scrollView;
//请求天气
@property (nonatomic, strong)EYRequest *requestWeather;
//请求滚动图片
@property (nonatomic, strong)EYRequest *requestImages;
//block数据源
@property (nonatomic, strong)NSMutableArray *blocksData;

@end

@implementation EYSubscriptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"订阅" image:[UIImage imageNamed:@"DashboardTabBarItemSubscription"] tag:0];
        self.tabBarItem = tabBarItem;
        //初始化显示天气的view
        self.showWeatherView = [[UIView alloc] initWithFrame:CGRectMake(237, 20, 65, 22)];
        //初始化数据源
        self.blocksData = [NSMutableArray array];
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(230, 160, 90, 20)];
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
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
    lable.text = @"订阅";
    [view addSubview:lable];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(302, 33, 18, 18)];
    arrow.image = [UIImage imageNamed:@"SubscriptionWeatherMark"];
    [view addSubview:arrow];
    
    UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 13, 60, 18)];
    leftLable.textAlignment = NSTextAlignmentRight;
    leftLable.textColor = [UIColor whiteColor];
    leftLable.font = [UIFont fontWithName:@"FZLanTingHei-R-GBK" size:12];
    leftLable.text = @"获取天气";
    NSArray *subViews = self.showWeatherView.subviews;
    if (subViews.count > 0) {
        for (UIView *subView in subViews) {
            [subView removeFromSuperview];
        }
    }
    [self.showWeatherView addSubview:leftLable];
    
    //左视图
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(242, 20, 78, 44)];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getWeather)];
    [leftView addGestureRecognizer:tap];
    leftView.userInteractionEnabled = YES;
    [view addSubview:leftView];
    
    return view;
}

- (void)getWeather
{
    EYWeatherViewController *weatherView = [[EYWeatherViewController alloc] init];
    [self.navigationController pushViewController:weatherView animated:YES];
}

- (UIScrollView *)createImageView
{
    self.showImageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 9 / 16)];
    self.showImageView.pagingEnabled = YES;
    self.showImageView.bounces = NO;
    self.showImageView.showsHorizontalScrollIndicator = NO;
    self.showImageView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
    self.showImageView.delegate = self;

    //请求图片
    NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *number = [userDefaults objectForKey:@"promotion"];
    NSString *url = [NSString stringWithFormat:@"http://iphone.myzaker.com/zaker/follow_promote.php?_appid=AndroidPhone&_dev=39&_udid=860310021635752&_version=4.51&m=%@", number];
    self.requestImages = [[EYRequest alloc] initRequestWithUrl:[NSURL URLWithString:url]];
    self.requestImages.delagate = self;
    [self.requestImages startAsynchronous];
    
    return self.showImageView;
}

#pragma mark - rootBlock
- (void)analyseRootBlocks
{
    //判断是否存在customBlocks.plist文件
    NSMutableArray *blocks;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self getCustomBlocksPath]]) {
        //x存在时读取文件
        blocks = [[NSMutableArray alloc] initWithContentsOfFile:[self getCustomBlocksPath]];
    }
    else { //不存在时
        NSMutableDictionary *data;
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"rootBlocks" ofType:@"plist"];
        data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        blocks = data[@"blocksData"];
        //写入文件
        NSLog(@"第一个界面——————写入了文件");
        [blocks writeToFile:[self getCustomBlocksPath] atomically:YES];
    }
    for (NSDictionary *block in blocks) {
        EYRootBlocksModal *modal = [[EYRootBlocksModal alloc] init];
        modal.title = block[@"title"];
        modal.imgURL = block[@"pic"];
        modal.colorValue = block[@"block_color"];
        modal.apiURL = block[@"api_url"];
        [self.blocksData addObject:modal];
    }
}

#pragma mark - 获得customBlocks.plist的路径
- (NSString *)getCustomBlocksPath
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = pathArray[0];
    NSString *path = [documentsPath stringByAppendingPathComponent:@"customBlocks.plist"];
    return path;
}

- (void)setBlocksView
{
    [self analyseRootBlocks];
    
    NSInteger count = 0;
    NSInteger i;
    for (i = 0; count < self.blocksData.count; i++) { //行
        
        for (NSInteger j = 0; (j < 3) && (count < self.blocksData.count); j++) { //列
            
            EYBlockView *blockView = [[EYBlockView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3 * j , 180 + i * (self.view.frame.size.width / 3), self.view.frame.size.width / 3, self.view.frame.size.width / 3)];
            EYRootBlocksModal *modal = self.blocksData[count];
            blockView.clickURL = modal.apiURL;
            
            [blockView setViewWithTitle:modal.title image:modal.imgURL color:modal.colorValue];
            [blockView addTarget:self action:@selector(showBlock:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:blockView];
            
            count ++;
            
        }
    }
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 180 + i * (self.view.frame.size.width / 3));
}
//点击block，进入该频道
- (void)showBlock:(EYBlockView *)blockView
{
    EYChannelView *channelView = [[EYChannelView alloc] init];
    channelView.requestChannel = blockView.clickURL;
    [self presentViewController:channelView animated:YES completion:nil];
    NSLog(@"%@", blockView.clickURL);
}

- (UIScrollView *)createContentView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self createImageView];
    [self.scrollView addSubview:self.showImageView];
    [self setBlocksView];
    return self.scrollView;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationView = [self createNavigationBar];
    //显示天气
    [self.navigationView addSubview:self.showWeatherView];
    //显示导航条
    [self.view addSubview:self.navigationView];
    //显示基本信息
    [self createContentView];
    [self.view addSubview:self.scrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    //请求天气
    NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectCity = [userDefaults objectForKey:@"selectCity"];
    if (selectCity != nil) {
        NSString *path = [NSString stringWithFormat:@"http://iphone.myzaker.com/zaker/get_weather.php?city=%@", selectCity];
        NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        self.requestWeather = [[EYRequest alloc] initRequestWithUrl:url];
        self.requestWeather.delagate = self;
        [self.requestWeather startAsynchronous];
    }
    //刷新blocks
        //1.先移除blockView
    NSArray *subViews = [self.scrollView subviews];
    for (id subView in subViews) {
        if ([subView isKindOfClass:[EYBlockView class]]) {
            [subView removeFromSuperview];
        }
    }
    [self.blocksData removeAllObjects];
        //重新添加数据
    [self setBlocksView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.requestWeather cancel];
}

#pragma mark - EYRequestDelegate
- (void)didReceiveResponse:(EYRequest *)request
{
    if (request == self.requestWeather) {
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 13, 60, 18)];
        leftLable.textAlignment = NSTextAlignmentRight;
        leftLable.textColor = [UIColor whiteColor];
        leftLable.font = [UIFont fontWithName:@"FZLanTingHei-R-GBK" size:12];
        leftLable.text = @"正在获取天气";
        NSArray *subViews = self.showWeatherView.subviews;
        if (subViews.count > 0) {
            for (UIView *subView in subViews) {
                [subView removeFromSuperview];
            }
        }
        [self.showWeatherView addSubview:leftLable];
    }
}

- (void)requestDidFinish:(EYRequest *)request
{
    if (request == self.requestWeather) {
        
        NSLog(@"%@", request.responseString);
        //解析
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSString *tmax = dic[@"data"][@"datas"][@"tmax"];
        NSString *tmin = dic[@"data"][@"datas"][@"tmin"];
        NSString *temperature = [NSString stringWithFormat:@"%@/%@°", tmin, tmax];
        
        NSArray *subViews = self.showWeatherView.subviews;
        if (subViews.count > 0) {
            for (UIView *subView in subViews) {
                [subView removeFromSuperview];
            }
        }
        
        //显示温度
        UILabel *tLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 45, 18)];
        tLable.text = temperature;
        tLable.textColor = [UIColor whiteColor];
        tLable.font = [UIFont fontWithName:@"FZLanTingHei-R-GBK" size:12];
        [self.showWeatherView addSubview:tLable];
        //显示城市
        UILabel *cityLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 25, 40, 18)];
        cityLable.text = dic[@"data"][@"datas"][@"city"];
        cityLable.textAlignment = NSTextAlignmentCenter;
        cityLable.textColor = [UIColor whiteColor];
        cityLable.font = [UIFont fontWithName:@"FZLanTingHei-R-GBK" size:12];
        [self.showWeatherView addSubview:cityLable];
        //显示天气图片
        UIImageView *weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 26, 26)];
        weatherImageView.image = [UIImage imageNamed:dic[@"data"][@"datas"][@"weather_day"]];
        [self.showWeatherView addSubview:weatherImageView];
        
        
    }
    
    else if (request == self.requestImages)
    {
        //解析
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSArray *rollImages = dic[@"data"][@"list"];
        //设置滚动视图的contentSize
        self.showImageView.contentSize = CGSizeMake(self.showImageView.frame.size.width * (rollImages.count + 2), self.showImageView.frame.size.height);
        //冗余的第一张图片
        EYscrollImageView *firstImageView = [[EYscrollImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 9 / 16)];
        [firstImageView setViewWithInfo:rollImages[rollImages.count - 1]];
        [self.showImageView addSubview:firstImageView];
        //添加图片
        for (NSInteger i=0; i < rollImages.count; i++) {
            EYscrollImageView *imageView = [[EYscrollImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * (i + 1), 0, self.view.frame.size.width, self.view.frame.size.width * 9 / 16)];
            [imageView setViewWithInfo:rollImages[i]];
            [imageView addTarget:self action:@selector(showView:) forControlEvents:UIControlEventTouchUpInside];
            [self.showImageView addSubview:imageView];
        }
        //冗余的最后一张图片
        EYscrollImageView *lastImageView = [[EYscrollImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * (1 +rollImages.count), 0, self.view.frame.size.width, self.view.frame.size.width * 9 / 16)];
        [lastImageView setViewWithInfo:rollImages[0]];
        [self.showImageView addSubview:lastImageView];
        //设置分页控制器
        self.pageControl.numberOfPages = rollImages.count;
        [self.scrollView addSubview:self.pageControl];
        //设置定时器
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(roll) userInfo:nil repeats:YES];
    }
}

- (void)showView:(EYscrollImageView *)imageView
{
    NSLog(@"type:____%@,  PK:_____%@", imageView.type, imageView.apiUrl);
    if ([imageView.type isEqualToString:@"block"]) {
        EYChannelView *channelView = [[EYChannelView alloc] init];
        channelView.requestChannel = imageView.apiUrl;
        [self presentViewController:channelView animated:YES completion:nil];
    }
    else if ([imageView.type isEqualToString:@"topic"]) {
        
    }
}

- (void)requestFailed:(EYRequest *)request
{
    if (request == self.requestWeather) {
        
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 13, 60, 18)];
        leftLable.textAlignment = NSTextAlignmentRight;
        leftLable.textColor = [UIColor whiteColor];
        leftLable.font = [UIFont fontWithName:@"FZLanTingHei-R-GBK" size:12];
        leftLable.text = @"重新获取天气";
        NSArray *subViews = self.showWeatherView.subviews;
        if (subViews.count > 0) {
            for (UIView *subView in subViews) {
                [subView removeFromSuperview];
            }
        }
        [self.showWeatherView addSubview:leftLable];
        
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.showImageView) {
        NSInteger page = (scrollView.contentOffset.x -320) / 320;
        if (page == -1) {
            [self.showImageView setContentOffset:CGPointMake(320 * self.pageControl.numberOfPages, 0)];
        }
        else if (page == self.pageControl.numberOfPages)
        {
            [self.showImageView setContentOffset:CGPointMake(320, 0)];
            self.pageControl.currentPage = 0;
        }
        else
        {
            self.pageControl.currentPage = page;
        }
    }
}

- (void)roll
{
    CGPoint point = self.showImageView.contentOffset;
    point.x = point.x + 320;
    [self.showImageView setContentOffset:point];

        NSInteger page = (self.showImageView.contentOffset.x -320) / 320;
        if (page == -1) {
            [self.showImageView setContentOffset:CGPointMake(320 * self.pageControl.numberOfPages, 0)];
            self.pageControl.currentPage = self.pageControl.numberOfPages - 1;
        }
        else if (page == self.pageControl.numberOfPages)
        {
            [self.showImageView setContentOffset:CGPointMake(320, 0)];
            self.pageControl.currentPage = 0;
        }
        else
        {
            self.pageControl.currentPage = page;
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

@end
