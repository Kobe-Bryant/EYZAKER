//
//  EYBlockView.m
//  EYZAKER
//
//  Created by mac on 14-9-28.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYBlockView.h"
#import "UIImageView+WebCache.h"
#import "UIColor+ChangeValue.h"

@implementation EYBlockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

- (void)setViewWithTitle:(NSString *)title image:(NSString *)imgURL color:(NSString *)color
{
    //self.frame.size = CGSizeMake(320/3, 320/3+10);
//    self.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height -20, self.frame.size.width, 12)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:12];
    lable.text = title;
    [self addSubview:lable];
    
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
    cachedImage = [cachedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20)];
    imageView.image = cachedImage;
    UIColor *currentColor = [UIColor colorWithHexString:color];
    imageView.tintColor = currentColor;
//    [imageView sd_setImageWithURL:[NSURL URLWithString:imgURL]];
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
