//
//  EYscrollImageView.m
//  EYZAKER
//
//  Created by mac on 14-10-2.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYscrollImageView.h"
#import "UIImageView+WebCache.h"

@implementation EYscrollImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setViewWithInfo:(NSDictionary *)viewInfo
{
    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:viewInfo[@"promotion_img"]]];
    //标题
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, 300, 20)];
    titleLable.text = viewInfo[@"title"];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.font = [UIFont fontWithName:@"FZLanTingHei-R-GBK" size:15];
    [imageView addSubview:titleLable];
    //标记图片
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(297, 20, 23, 13)];
    [icon sd_setImageWithURL:[NSURL URLWithString:viewInfo[@"tag_info"][@"image_url"]]];
    [imageView addSubview:icon];
    //判断类型
    self.type = viewInfo[@"type"];
    if ([self.type isEqualToString:@"topic"]) {
        NSString *pk = viewInfo[@"topic"][@"pk"];
        self.apiUrl = [NSString stringWithFormat:@"http://iphone.myzaker.com/zaker/topic.php?_appid=AndroidPhone&_dev=39&_v=4.4.3&_version=4.51&app_id=9&topic_id=%@", pk];
    }
    else if ([self.type isEqualToString:@"block"]) {
        self.apiUrl = viewInfo[@"block_info"][@"api_url"];
    }
    [self addSubview:imageView];
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
