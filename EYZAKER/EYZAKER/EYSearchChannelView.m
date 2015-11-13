//
//  EYSearchChannelView.m
//  EYZAKER
//
//  Created by mac on 14-10-3.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYSearchChannelView.h"
#import "EYSonRoomModal.h"
#import "EYSonRoomCell.h"
#import "EYChannelView.h"

@interface EYSearchChannelView () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
//输入框
@property (nonatomic, strong)UITextField *textField;
//显示结果
@property (nonatomic, strong)UITableView *tableView;
//提示框
@property (nonatomic, strong)UILabel *alertLable;
//搜索结果数据源
@property (nonatomic, strong)NSMutableArray *resultData;

@end

@implementation EYSearchChannelView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.resultData = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 创建导航
- (UIImageView *)createNavigationBar
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    view.userInteractionEnabled = YES;
    view.image = [UIImage imageNamed:@"toolbar_bg"];
    
    //textfield
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 30, 260, 24)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *searchicon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 6, 12, 12)];
    searchicon.image = [UIImage imageNamed:@"SearchBarTextFieldIcon"];
    [bgView addSubview:searchicon];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(22, 4, 230, 14)];
    self.textField.placeholder = @"搜索您感兴趣的频道";
    self.textField.delegate = self;
    self.textField.font = [UIFont systemFontOfSize:12];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInputWord) name:UITextFieldTextDidChangeNotification object:nil];
    
    [bgView addSubview:self.textField];
    
    [view addSubview:bgView];

    
    //取消
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(293, 35, 14, 14)];
    leftImage.image = [UIImage imageNamed:@"push_message_close"];
    [view addSubview:leftImage];
    leftImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
    [leftImage addGestureRecognizer:tap];
    
    return view;
}
//输入内容时响应
- (void)didInputWord
{
    //先清空数据源数据
    [self.resultData removeAllObjects];
    if (!(self.textField.text.length > 0)) {
        self.tableView.hidden = YES;
        self.alertLable.hidden = YES;
        return;
    }
    NSLog(@"%@_______***", [self getRootBlocksPath]);
    //遍历， 查找， 给数据源添加数据
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:[self getRootBlocksPath]];

    NSArray *srcData = dic[@"data"][@"datas"];
    for (NSDictionary *room in srcData) {
        NSArray *sons = room[@"sons"];
        for (NSDictionary *son in sons) {
            if ([son[@"title"] rangeOfString:self.textField.text].location != NSNotFound) {
                EYSonRoomModal *sonRoomModal = [[EYSonRoomModal alloc] init];
                sonRoomModal.title = son[@"title"];
                sonRoomModal.apiURL = son[@"api_url"];
                sonRoomModal.blockInfo = son;
                [self.resultData addObject:sonRoomModal];
            }
        }
    }
    if (self.resultData.count > 0) {
        [self.tableView reloadData];
        self.tableView.hidden = NO;
        self.alertLable.hidden = YES;
    }
    else {
        self.alertLable.hidden = NO;
        self.tableView.hidden = YES;
        self.alertLable.text = [NSString stringWithFormat:@"找不到“%@”的频道", self.textField.text];
        CGRect rect = self.alertLable.frame;
        rect.size.height = [self getLableSizeWithText:self.alertLable.text];
        self.alertLable.frame = rect;

    }
}

//求lable的高度或宽度
- (CGFloat)getLableSizeWithText:(NSString *)content
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        CGRect rect = [content boundingRectWithSize:CGSizeMake(300, self.view.frame.size.height - 64) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
        return rect.size.height + 1;
    }
    else
    {
        CGSize siZe = [content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300, self.view.frame.size.height - 64)];
        return siZe.height + 1;
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

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化导航条
    [self.view addSubview:[self createNavigationBar]];
    //初始化tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 64)];
    [self.tableView registerNib:[UINib nibWithNibName:@"EYSonRoomCell" bundle:nil] forCellReuseIdentifier:@"sonRoomCell"];
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    //初始化提示框
    self.alertLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 300, 100)];
    self.alertLable.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"toolbar_bg"]];
    self.alertLable.numberOfLines = 0;
    self.alertLable.font = [UIFont systemFontOfSize:13];
    self.alertLable.hidden = YES;
    [self.view addSubview:self.alertLable];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
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
    
    EYSonRoomModal *modal = self.resultData[indexPath.row];
    EYChannelView *channelView = [[EYChannelView alloc] init];
    channelView.requestChannel = modal.apiURL;
    [self presentViewController:channelView animated:YES completion:nil];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EYSonRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sonRoomCell"];
    EYSonRoomModal *modal = self.resultData[indexPath.row];
    [cell setCellWithModal:modal];
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
