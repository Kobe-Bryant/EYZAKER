//
//  EYShowTopicView.m
//  EYZAKER
//
//  Created by mac on 14-9-28.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYShowTopicView.h"
#import "EYRequest.h"
#import "UIImageView+WebCache.h"
#import "EYTopicRowView.h"
#import "EYChannelView.h"

@interface EYShowTopicView () <EYRequestDelegate>
//标记Y坐标
@property (nonatomic, assign)CGPoint flagPoint;

@property (nonatomic, strong)UIScrollView *scrollView;

@end

@implementation EYShowTopicView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 240, 44)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont fontWithName:@"FZLanTingHei-R-GBK" size:15];
    lable.text = self.name;
    [view addSubview:lable];
    
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 26, 32, 32)];
    leftImage.image = [UIImage imageNamed:@"addRootBlock_toolbar_return"];
    [view addSubview:leftImage];
    leftImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [leftImage addGestureRecognizer:tap];
    
    return view;
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:[self createNavigationBar]];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 64)];
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    
    EYRequest *request = [[EYRequest alloc] initRequestWithUrl:[NSURL URLWithString:self.topicURL]];
    request.delagate = self;
    [request startAsynchronous];
    
}

- (void)requestDidFinish:(EYRequest *)request
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    
    //顶部图片
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 310, 60)];
    [topImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"data"][@"head"][@"img"]]];
    self.flagPoint = CGPointMake(0, CGRectGetMaxY(topImageView.frame) + 5);
    [self.scrollView addSubview:topImageView];
    //布局
    NSArray *list = dic[@"data"][@"list"];
    for (NSDictionary *topic in list) {
        
        EYTopicRowView *rowView = [[EYTopicRowView alloc] initWithFrame:CGRectMake(0, self.flagPoint.y, 320, 70)];
        self.flagPoint = CGPointMake(0, CGRectGetMaxY(rowView.frame));
//        rowView.titleLable.text = topic[@"title"];
//        rowView.stitleLable.text = topic[@"stitle"];
//        [rowView.mainImageView sd_setImageWithURL:[NSURL URLWithString:topic[@"large_pic"]]];
//        rowView.clickURL = topic[@"api_url"];
#warning 取值不一样， 待明天修改
        [rowView setRowViewWithDictionary:topic];
        [rowView addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:rowView];
        
    }
    self.scrollView.contentSize = CGSizeMake(320, self.flagPoint.y);
}

- (void)showDetail:(EYTopicRowView *)rowView
{
    EYChannelView *channelView = [[EYChannelView alloc] init];
    channelView.requestChannel = rowView.clickURL;
    [self presentViewController:channelView animated:YES completion:nil];

}

- (void)requestFailed:(EYRequest *)request
{
    
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
