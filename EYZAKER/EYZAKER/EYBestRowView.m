//
//  EYBestRowView.m
//  EYZAKER
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYBestRowView.h"
#import "UIImageView+WebCache.h"
#import "UIColor+ChangeValue.h"

@implementation EYBestRowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
