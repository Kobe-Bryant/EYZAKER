//
//  EYChannelView.m
//  EYZAKER
//
//  Created by mac on 14-9-30.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYChannelView.h"
#import "EYRequest.h"
#import "EYChannelPageModal.h"
#import "EYChannelPage.h"
#import "EYContentView.h"


@interface EYChannelView () <EYRequestDelegate, EYChannelPageDelegate, UIScrollViewDelegate, UIAlertViewDelegate>
//标志图片
@property (nonatomic, strong)NSString *mainImageURL;
//名字
@property (nonatomic, strong)NSString *name;
//数据源
@property (nonatomic, strong)NSMutableArray *channelData;
//缓存每页数据源
@property (nonatomic, strong)NSMutableArray *pageArray;
//频道第一个图片的随机色
@property (nonatomic, strong)UIColor *color;

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, assign)BOOL isDidRequest;

@property (nonatomic, assign)BOOL isfinishRequest;

@end

@implementation EYChannelView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.channelData = [NSMutableArray array];
        self.pageArray = [NSMutableArray array];
        self.color = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.image = [UIImage imageNamed:@"toolbar_bg"];
    [self.view addSubview:view];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    [self createRequest];
}

- (void)createRequest
{
    EYRequest *request = [[EYRequest alloc] initRequestWithUrl:[NSURL URLWithString:self.requestChannel]];
    request.delagate = self;
    NSLog(@"%@", self.requestChannel);
    [request startAsynchronous];
}

#pragma mark - EYRequestDelegate
- (void)requestDidFinish:(EYRequest *)request
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    self.mainImageURL = dic[@"data"][@"block_info"][@"pic"];
    self.name = dic[@"data"][@"block_info"][@"block_title"];
    
    NSArray *array = dic[@"data"][@"articles"];
    for (NSDictionary *article in array) {
        EYChannelPageModal *modal = [[EYChannelPageModal alloc] init];
        modal.title = article[@"title"];
        NSString *autherName = article [@"auther_name"];
        NSString *date = article[@"date"];
        if (date != nil) {
            NSRange range = {5,5};
            date = [date substringWithRange:range];
        }
        modal.autherName = [NSString stringWithFormat:@"%@  %@", autherName, date];
        modal.clickURL = article[@"weburl"];
        if ([article[@"media"] count] > 0) {
            modal.imageURL = article[@"media"][0][@"m_url"];
        }
        [self.pageArray addObject:modal];
        if (self.pageArray.count == 6) {
            NSArray *page = [NSArray arrayWithArray:self.pageArray];
            [self.channelData addObject:page];
            
            [self.pageArray removeAllObjects];
        }
    }
    self.isfinishRequest = YES;
    self.scrollView.contentSize = CGSizeMake(320 * self.channelData.count, 480);
    //加载第一页
    if (!self.isDidRequest && self.channelData.count > 0) {
        self.isDidRequest = YES;
        EYChannelPage *channelPage = [[EYChannelPage alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        channelPage.name = self.name;
        channelPage.mainImageURL = self.mainImageURL;
        channelPage.bgColor = self.color;
        channelPage.delegate = self;
        channelPage.pageData = self.channelData[0];
        [channelPage finishView];
        channelPage.currentPage = 1;
        [channelPage setPageWithPageCount:self.channelData.count];
        [self.scrollView addSubview:channelPage];
    }
    else if (self.channelData.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"暂无内容" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)requestFailed:(EYRequest *)request
{
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIScrollViewDelegate
//往左拉到最后一页时加载更多
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ((self.scrollView.contentOffset.x > (self.channelData.count - 1) * 320) && self.isfinishRequest) {
        [self createRequest];
        self.isfinishRequest = NO;
    }
}
//加载新一页
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = self.scrollView.contentOffset;
    NSInteger page = (point.x / 320);
    
    EYChannelPage *channelPage = [[EYChannelPage alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width * page, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    channelPage.name = self.name;
    channelPage.mainImageURL = self.mainImageURL;
    channelPage.bgColor = self.color;
    channelPage.delegate = self;
    channelPage.pageData = self.channelData[page];
    channelPage.currentPage = page + 1;
    [channelPage finishView];
    [channelPage setPageWithPageCount:self.channelData.count];

    [self.scrollView addSubview:channelPage];
}

#pragma mark - EYChannelPageDelegate
- (void)responseBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectedBlock:(EYPageBlock *)block
{
    EYContentView *channelView = [[EYContentView alloc] init];
    channelView.webRequestURL = block.url;
    [self presentViewController:channelView animated:YES completion:nil];
    NSLog(@"##########$$$$$$$$$$$$$$$$$$$$$&&&&&&&&&&&&&&&&&,block响应");
    NSLog(@"block    %@", block.url);
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
