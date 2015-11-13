//
//  EYExploreViewController.m
//  EYZAKER
//
//  Created by mac on 14-9-24.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYExploreViewController.h"
#import "EYRequest.h"
#import "UIImageView+WebCache.h"
#import "EYTopicView.h"
#import "EYShowTopicView.h"
#import "EYBestRowView.h"
#import "EYRoomModal.h"
#import "EYSonRoomModal.h"
#import "EYRoomCell.h"
#import "EYSonRoomView.h"
#import "EYChannelView.h"
#import "EYSearchChannelView.h"
#import "UIColor+ChangeValue.h"

#define pictureItemURL @"http://iphone.myzaker.com/zaker/find_promotion.php?_appid=AndroidPhone&m=1411844400"

#define bestURL @"http://iphone.myzaker.com/zaker/find.php?_appid=AndroidPhone&m=1411869601"

#define roomURL @"http://iphone.myzaker.com/zaker/apps_v3.php?_appid=AndroidPhone&m=1411438405"

@interface EYExploreViewController () <EYRequestDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
//分栏
@property (nonatomic, strong)UIButton *bestBtn;
@property (nonatomic, strong)UIButton *roomBtn;
//整个scrollview
@property (nonatomic, strong)UIScrollView *scrollView;
//精品scrollview
@property (nonatomic, strong)UIScrollView *bestView;
//内容库tableview
@property (nonatomic, strong)UITableView *roomView;
//请求图片项目的内容
@property (nonatomic, strong)EYRequest *requestPictrueItem;
//请求精选
@property (nonatomic, strong)EYRequest *requestBestItem;
//请求内容库
@property (nonatomic, strong)EYRequest *requestRoom;
//标记Y坐标
@property (nonatomic, assign)CGPoint flagPoint;
//内容库数据源
@property (nonatomic, strong)NSMutableArray *roomData;

@end

@implementation EYExploreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"DashboardTabBarItemExplore"] tag:0];
        self.tabBarItem = tabBarItem;
        
        self.roomData = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 创建导航
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
    lable.text = @"发现";
    [view addSubview:lable];
    
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(288, 26, 32, 32)];
    leftImage.image = [UIImage imageNamed:@"ExploreSearchButton"];
    [view addSubview:leftImage];
    leftImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchChannel)];
    [leftImage addGestureRecognizer:tap];
    
    return view;
}

- (void)searchChannel
{
    EYSearchChannelView *searchChannelView = [[EYSearchChannelView alloc] init];
    [self.navigationController pushViewController:searchChannelView animated:YES];
}

#pragma mark - 创建分栏
- (void)createButton
{
    
    self.bestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bestBtn.frame = CGRectMake(0, 64, self.view.frame.size.width / 2, 30);
    self.bestBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.bestBtn setTitle:@"精选" forState:UIControlStateNormal];
    [self.bestBtn setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"toolbar_bg"]] forState:UIControlStateSelected];
    [self.bestBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.bestBtn.selected = YES;
    [self.bestBtn addTarget:self action:@selector(changeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bestBtn];
    
    self.roomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.roomBtn.frame = CGRectMake(self.view.frame.size.width / 2, 64, self.view.frame.size.width/2, 30);
    self.roomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.roomBtn setTitle:@"内容库" forState:UIControlStateNormal];
    [self.roomBtn setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"toolbar_bg"]] forState:UIControlStateSelected];
    [self.roomBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.roomBtn addTarget:self action:@selector(changeSelect:) forControlEvents:UIControlEventTouchUpInside];
    self.roomBtn.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [self.view addSubview:self.roomBtn];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 94, 320, 1)];
    line.image = [UIImage imageNamed:@"line"];
    [self.view addSubview:line];
    
}

- (void)changeSelect:(UIButton *)sender
{
    self.bestBtn.selected = NO;
    self.roomBtn.selected = NO;
    self.bestBtn.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    self.roomBtn.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    sender.selected = YES;
    sender.backgroundColor = [UIColor whiteColor];
    
    if (sender == self.bestBtn) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
        [UIView commitAnimations];
    }
    else if (sender == self.roomBtn) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [self.scrollView setContentOffset:CGPointMake(320, 0)];
        [UIView commitAnimations];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:[self createNavigationBar]];
    [self createButton];
    [self createScrollView];
    
}
#pragma mark - 整个scrollview
- (void)createScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, self.view.frame.size.height - 95 - 49)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    
    self.flagPoint = CGPointMake(0, 0);
    
    [self createBestView];
    [self createRoomView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollView.contentOffset.x == 0) {
        self.bestBtn.selected = YES;
        self.roomBtn.selected = NO;
        self.bestBtn.backgroundColor = [UIColor whiteColor];
        self.roomBtn.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }
    else if (self.scrollView.contentOffset.x == 320) {
        self.roomBtn.selected = YES;
        self.bestBtn.selected = NO;
        self.roomBtn.backgroundColor = [UIColor whiteColor];
        self.bestBtn.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];

    }
}


#pragma mark - 精品
- (void)createBestView
{
    self.bestView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    self.bestView.bounces = NO;
    [self.scrollView addSubview:self.bestView];
    
    //请求图片项目的内容
    self.requestPictrueItem = [[EYRequest alloc] initRequestWithUrl:[NSURL URLWithString:pictureItemURL]];
    self.requestPictrueItem.delagate = self;
    [self.requestPictrueItem startAsynchronous];
    //当请求完图片内容时在请求精选的内容，以保持页面有序
//    //请求精选
//    self.requestBestItem = [[EYRequest alloc] initRequestWithUrl:[NSURL URLWithString:bestURL]];
//    self.requestBestItem.delagate = self;
//    [self.requestBestItem startAsynchronous];

    
}

#pragma mark - 内容库
- (void)createRoomView
{
    self.roomView = [[UITableView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    self.roomView.bounces = NO;
    [self.roomView registerNib:[UINib nibWithNibName:@"EYRoomCell" bundle:nil] forCellReuseIdentifier:@"roomCell"];
    self.roomView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.roomView.delegate = self;
    self.roomView.dataSource = self;
    
    //判断是否存在文件rootBlocks.plist，存在则直接读取，给内容库添加内容；没有则先请求数据，再给内容库添加内容
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self getRootBlocksPath]]) {
        //已经存在，读取文件
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:[self getRootBlocksPath]];
        //给内容库添加数据
        [self setRoomWithDictionary:dic];
        NSLog(@"读取文件");
    }
    else {
        //不存在则请求数据
        self.requestRoom = [[EYRequest alloc] initRequestWithUrl:[NSURL URLWithString:roomURL]];
        self.requestRoom.delagate = self;
        [self.requestRoom startAsynchronous];
        NSLog(@"请求数据");
    }
}

#pragma mark - 获得rootBlocks.plist的路径
- (NSString *)getRootBlocksPath
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = pathArray[0];
    NSString *path = [documentsPath stringByAppendingPathComponent:@"rootBlocks.plist"];
    return path;
}

#pragma mark - EYRequestDelegate
- (void)requestDidFinish:(EYRequest *)request
{
    if (request == self.requestPictrueItem) {  //请求图片项目的内容
        //解析
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSArray *list = dic[@"data"][@"list"];
        
        for (NSArray *array in list) {
            
            NSDictionary *topic = array[0];
            
            if ([topic[@"type"] isEqualToString:@"block_topic"]) {
                //block_topic
                //布局
                EYTopicView *largeImageView = [[EYTopicView alloc] initWithFrame:CGRectMake(5, self.flagPoint.y + 5, 310, 60)];
                self.flagPoint = CGPointMake(0, CGRectGetMaxY(largeImageView.frame));
                largeImageView.tag = 1;
                largeImageView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
                [self.bestView addSubview:largeImageView];
                //赋值
                largeImageView.title = topic[@"title"];
                largeImageView.topicURL = topic[@"block_topic"][@"api_url"];
                [largeImageView setTopicImage:topic[@"promotion_img"]];
                [largeImageView addTarget:self action:@selector(showTopic:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            else if ([topic[@"type"] isEqualToString:@"block"]) {
                //block
                //布局
                EYTopicView *smallImageViewA = [[EYTopicView alloc] initWithFrame:CGRectMake(5, self.flagPoint.y + 5, 150.5, 60)];
                smallImageViewA.tag = 2;
                smallImageViewA.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
                [self.bestView addSubview:smallImageViewA];
                //赋值
                smallImageViewA.title = topic[@"title"];
                smallImageViewA.topicURL = topic[@"block_info"][@"api_url"];
                [smallImageViewA setTopicImage:topic[@"promotion_img"]];
                [smallImageViewA addTarget:self action:@selector(showTopic:) forControlEvents:UIControlEventTouchUpInside];
                
                topic = array[1];
                //布局
                EYTopicView *smallImageViewB = [[EYTopicView alloc] initWithFrame:CGRectMake(160.5, self.flagPoint.y + 5, 150.5, 60)];
                smallImageViewA.tag = 3;
                smallImageViewB.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
                [self.bestView addSubview:smallImageViewB];
                //赋值
                smallImageViewB.title = topic[@"title"];
                smallImageViewB.topicURL = topic[@"block_info"][@"api_url"];
                [smallImageViewB setTopicImage:topic[@"promotion_img"]];
                [smallImageViewB addTarget:self action:@selector(showTopic:) forControlEvents:UIControlEventTouchUpInside];
                self.flagPoint = CGPointMake(0, self.flagPoint.y + 65);
                
                //请求精选
                self.requestBestItem = [[EYRequest alloc] initRequestWithUrl:[NSURL URLWithString:bestURL]];
                self.requestBestItem.delagate = self;
                [self.requestBestItem startAsynchronous];

            }
        }
        
    }
    
    else if (request == self.requestBestItem) {  //精选
        //解析
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.flagPoint.y + 5, 320, 20)];
        lable.text = @"   精选";
        lable.textColor = [UIColor darkGrayColor];
        lable.font = [UIFont systemFontOfSize:12];
        lable.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        [self.bestView addSubview:lable];
        
        self.flagPoint = CGPointMake(0, CGRectGetMaxY(lable.frame));
        
        NSArray *list = dic[@"data"][@"list"];
        for (NSDictionary *best in list) {
            EYBestRowView *rowView = [[EYBestRowView alloc] initWithFrame:CGRectMake(0, self.flagPoint.y, 320, 70)];
            self.flagPoint = CGPointMake(0, CGRectGetMaxY(rowView.frame));
            [rowView setRowViewWithDictionary:best];
            [rowView addTarget:self action:@selector(showBest:) forControlEvents:UIControlEventTouchUpInside];
            [self.bestView addSubview:rowView];
        }
        self.bestView.contentSize = CGSizeMake(320, self.flagPoint.y);
    }
    
    else if (request == self.requestRoom) { //内容库
        //解析
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        [self setRoomWithDictionary:dic];
        //将请求到的数据保存到plist文件中，下次启动程序可以直接读取
        [dic writeToFile:[self getRootBlocksPath] atomically:YES];
    }
}

#pragma mark - 给roomData数据源添加数据，再刷新roomView，将roomView添加到视图中
- (void)setRoomWithDictionary:(NSDictionary *)dic
{
    NSArray *rooms = dic[@"data"][@"datas"];
    for (NSDictionary *room in rooms) {
        EYRoomModal *roomModal = [[EYRoomModal alloc] init];
        roomModal.title = room[@"title"];
        roomModal.picURL = room[@"list_icon"];
        
        NSArray *sons = room[@"sons"];
        for (NSDictionary *son in sons) {
            EYSonRoomModal *sonRoomModal = [[EYSonRoomModal alloc] init];
            sonRoomModal.title = son[@"title"];
            sonRoomModal.apiURL = son[@"api_url"];
            sonRoomModal.blockInfo = son;
            [roomModal.sonRoomData addObject:sonRoomModal];
        }
        
        [self.roomData addObject:roomModal];
    }
    [self.roomView reloadData];
    [self.scrollView addSubview:self.roomView];
}

- (void)requestFailed:(EYRequest *)request
{
    
    
}

- (void)showTopic:(EYTopicView *)topicView
{
    if (topicView.tag == 1) {
        EYShowTopicView *showTopicView = [[EYShowTopicView alloc] init];
        showTopicView.name = topicView.title;
        showTopicView.topicURL = topicView.topicURL;
        [self presentViewController:showTopicView animated:YES completion:nil];
    }
    else if (topicView.tag != 1) {
        EYChannelView *channelView = [[EYChannelView alloc] init];
        channelView.requestChannel = topicView.topicURL;
        [self presentViewController:channelView animated:YES completion:nil];
    }
    NSLog(@"###topic####   %@ ___%@", topicView.title,  topicView.topicURL);
}

- (void)showBest:(EYBestRowView *)rowView
{
    EYChannelView *channelView = [[EYChannelView alloc] init];
    channelView.requestChannel = rowView.clickURL;
    [self presentViewController:channelView animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消cell选中之后有高亮状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EYRoomModal *roomMadal = self.roomData[indexPath.row];
    EYSonRoomView *sonRoomView = [[EYSonRoomView alloc] init];
    sonRoomView.name = roomMadal.title;
    sonRoomView.roomData = roomMadal.sonRoomData;
    [self.navigationController pushViewController:sonRoomView animated:YES];
    
}

#pragma mark - UITableViewDataSource
//返回段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.roomData.count;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EYRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"roomCell"];
    EYRoomModal *roomModal = self.roomData[indexPath.row];
    [cell setRoomRowWithModal:roomModal];
    return cell;
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
