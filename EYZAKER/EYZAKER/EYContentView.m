//
//  EYContentView.m
//  EYZAKER
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYContentView.h"

@interface EYContentView () <UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *webView;

@property (nonatomic, assign)BOOL isfirst;

@end

@implementation EYContentView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", self.webRequestURL);
    // Do any additional setup after loading the view.
    UIImageView *statusView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusView.userInteractionEnabled = YES;
    statusView.image = [UIImage imageNamed:@"toolbar_bg"];
    [self.view addSubview:statusView];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, 320, self.view.frame.size.height - 20 - 44)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.webRequestURL]];
    [self.webView loadRequest:request];
    
    UIView *tool = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, 320, 44)];
    tool.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    //返回按钮
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 6, 32, 32);
    [back setImage:[UIImage imageNamed:@"circle_icon_quit"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [tool addSubview:back];
    //分享按钮
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(72, 6, 32, 32);
    [share setImage:[UIImage imageNamed:@"common_icon_share"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [tool addSubview:share];
    //留言按钮
    UIButton *comment = [UIButton buttonWithType:UIButtonTypeCustom];
    comment.frame = CGRectMake(144, 6, 32, 32);
    [comment setImage:[UIImage imageNamed:@"common_icon_comment_s"] forState:UIControlStateNormal];
    [comment addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [tool addSubview:comment];
    //评论按钮
    UIButton *pencil = [UIButton buttonWithType:UIButtonTypeCustom];
    pencil.frame = CGRectMake(216, 6, 32, 32);
    [pencil setImage:[UIImage imageNamed:@"common_icon_pencil_square"] forState:UIControlStateNormal];
    [pencil addTarget:self action:@selector(pencilAction) forControlEvents:UIControlEventTouchUpInside];
    [tool addSubview:pencil];
    //更多按钮
    UIButton *setting = [UIButton buttonWithType:UIButtonTypeCustom];
    setting.frame = CGRectMake(288, 6, 32, 32);
    [setting setImage:[UIImage imageNamed:@"common_icon_setting"] forState:UIControlStateNormal];
    [setting addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    [tool addSubview:setting];

    [self.view addSubview:tool];
}
//返回按钮
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//分享按钮
- (void)shareAction
{
    NSLog(@"点击了");
}
//留言按钮
- (void)commentAction
{
    NSLog(@"点击了");
}
//评论按钮
- (void)pencilAction
{
    NSLog(@"点击了");
}
//更多按钮
- (void)settingAction
{
    NSLog(@"点击了");
}


#pragma mark - 
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //设置字体
//    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust = '80%'";
//    [self.webView stringByEvaluatingJavaScriptFromString:str];
    //获得webView中的scrollView
    NSArray *array = [NSArray arrayWithArray:[self.webView subviews]];
    UIScrollView *scrollView = (UIScrollView *)array[0];
    
    NSLog(@"frame%@", NSStringFromCGSize(self.webView.scrollView.contentSize));
    //编辑scrollView
    if (!self.isfirst) {
        self.isfirst = YES;
        [scrollView setContentInset:UIEdgeInsetsMake(-60, 0, 0, 0)];
        scrollView.bounces = NO;
        return;
    }
    
    UIView *icon = [[UIView alloc] initWithFrame:CGRectMake(0, scrollView.contentSize.height, 320, 100)];
    icon.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:icon];
    scrollView.contentSize = CGSizeMake(320, CGRectGetMaxY(icon.frame));
    //点赞
    UIButton *like = [UIButton buttonWithType:UIButtonTypeCustom];
    like.backgroundColor = [UIColor whiteColor];
    like.frame = CGRectMake(123, 13, 74, 74);
    [like setImage:[UIImage imageNamed:@"ArticleLikeButtonOn"] forState:UIControlStateNormal];
    [like setImage:[UIImage imageNamed:@"ArticleLikeButtonHighlight"] forState:UIControlStateHighlighted];
    [like setImage:[UIImage imageNamed:@"ArticleLikeButtonOff"] forState:UIControlStateSelected];
    [like addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    [icon addSubview:like];

}

- (void)likeAction:(UIButton *)sender
{
    NSArray *array = [NSArray arrayWithArray:[self.webView subviews]];
    UIScrollView *scrollView = (UIScrollView *)array[0];
    CGFloat hight = scrollView.contentSize.height;
    sender.selected = !sender.selected;
    UIImageView *numImage = [[UIImageView alloc] initWithFrame:CGRectMake(139, hight - 50, 42, 23)];
    if (sender.selected) {
        numImage.image = [UIImage imageNamed:@"ArticleLikePlusOne"];
    } else {
        numImage.image = [UIImage imageNamed:@"ArticleLikeMinusOne"];
    }
    [scrollView addSubview:numImage];
    [UIView animateWithDuration:1 animations:^{
        numImage.frame = CGRectMake(139, hight - 100, 42, 23);
        numImage.alpha = 0;
    } completion:^(BOOL finished) {
        [numImage removeFromSuperview];
    }];
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
