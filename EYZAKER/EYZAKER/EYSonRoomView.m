//
//  EYSonRoomView.m
//  EYZAKER
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYSonRoomView.h"
#import "EYSonRoomCell.h"
#import "EYSonRoomModal.h"
#import "EYChannelView.h"
#import "EYSearchChannelView.h"

@interface EYSonRoomView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation EYSonRoomView

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
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 26, 32, 32)];
    backImage.image = [UIImage imageNamed:@"addRootBlock_toolbar_return"];
    [view addSubview:backImage];
    backImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [backImage addGestureRecognizer:tap];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(32, 20, 150, 44)];
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont fontWithName:@"FZLanTingHei-DB-GBK" size:15];
    lable.text = self.name;
    [view addSubview:lable];
    
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(288, 26, 32, 32)];
    leftImage.image = [UIImage imageNamed:@"ExploreSearchButton"];
    [view addSubview:leftImage];
    leftImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchChannel)];
    [leftImage addGestureRecognizer:tap1];
    
    return view;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchChannel
{
    EYSearchChannelView *searchChannelView = [[EYSearchChannelView alloc] init];
    [self.navigationController pushViewController:searchChannelView animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:[self createNavigationBar]];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 64)];
    tableView.bounces = NO;
    [tableView registerNib:[UINib nibWithNibName:@"EYSonRoomCell" bundle:nil] forCellReuseIdentifier:@"sonRoomCell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消cell选中之后有高亮状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EYSonRoomModal *modal = self.roomData[indexPath.row];
    EYChannelView *channelView = [[EYChannelView alloc] init];
    channelView.requestChannel = modal.apiURL;
    [self presentViewController:channelView animated:YES completion:nil];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.roomData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EYSonRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sonRoomCell"];
    EYSonRoomModal *modal = self.roomData[indexPath.row];
    [cell setCellWithModal:modal];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
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
