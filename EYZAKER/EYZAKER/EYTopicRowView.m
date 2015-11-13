//
//  EYTopicRowView.m
//  EYZAKER
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYTopicRowView.h"
#import "UIColor+ChangeValue.h"
#import "UIImageView+WebCache.h"

@implementation EYTopicRowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
//        self.mainImageView.clipsToBounds = YES;
//        self.mainImageView.layer.cornerRadius = 30;
//        self.mainImageView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:0.3];
//        [self addSubview:self.mainImageView];
//        
//        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 14, 230, 20)];
//        self.titleLable.font = [UIFont systemFontOfSize:14];
//        [self addSubview:self.titleLable];
//        
//        self.stitleLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 34, 230, 20)];
//        self.stitleLable.font = [UIFont systemFontOfSize:12];
//        self.stitleLable.textColor = [UIColor darkGrayColor];
//        [self addSubview:self.stitleLable];
//        
//        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 69.3, 320, 0.7)];
//        line.image = [UIImage imageNamed:@"line"];
//        [self addSubview:line];
    }
    return self;
}

- (void)setRowViewWithDictionary:(NSDictionary *)best
{
    //图片
    UIColor *bgcolor = [UIColor colorWithHexString:best[@"block_info"][@"block_color"]];
    UIImageView *mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
    mainImageView.clipsToBounds = YES;
    mainImageView.layer.cornerRadius = 29;
    mainImageView.backgroundColor = [UIColor whiteColor];
    mainImageView.layer.borderWidth = 1;
    mainImageView.layer.borderColor = bgcolor.CGColor;
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:best[@"block_info"][@"pic"]];
    cachedImage = [cachedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    mainImageView.image = cachedImage;
    mainImageView.tintColor = bgcolor;
    [self addSubview:mainImageView];
    //标题
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 14, 230, 20)];
    titleLable.font = [UIFont systemFontOfSize:14];
    titleLable.text = best[@"block_info"][@"title"];
    [self addSubview:titleLable];
    //子标题
    UILabel *stitleLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 34, 230, 20)];
    stitleLable.font = [UIFont systemFontOfSize:12];
    stitleLable.textColor = [UIColor darkGrayColor];
    stitleLable.text = best[@"block_info"][@"stitle"];
    [self addSubview:stitleLable];
    
    self.clickURL = best[@"block_info"][@"api_url"];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 69.3, 320, 0.7)];
    line.image = [UIImage imageNamed:@"line"];
    [self addSubview:line];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
