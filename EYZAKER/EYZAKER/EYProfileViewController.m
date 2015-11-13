//
//  EYProfileViewController.m
//  EYZAKER
//
//  Created by mac on 14-9-24.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYProfileViewController.h"

@interface EYProfileViewController ()

@end

@implementation EYProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"DashboardTabBarItemProfile"] tag:0];
        self.tabBarItem = tabBarItem;
        
        
        NSArray *oneSection = @[@"   好友分享", @"   我的消息", @"   推送资讯", @"   积分活动", @"   我的收藏"];
        NSArray *twoSection = @[@"   离线下载", @"   清除缓存", @"   夜间模式", @"   更多设置"];
        NSArray *threeSection = @[@"   用户反馈", @"   推荐给好友", @"   检查更新", @"   给我们好评", @"   关于我们"];
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
    lable.text = @"###";
    [view addSubview:lable];
    
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(288, 26, 32, 32)];
    leftImage.image = [UIImage imageNamed:@"addRootBlock_toolbar_next"];
    [view addSubview:leftImage];
    leftImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getWeather)];
    [leftImage addGestureRecognizer:tap];
    
    return view;
}

- (void)getWeather
{
    NSLog(@"####");
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:[self createNavigationBar]];

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
