//
//  EYTopicView.m
//  EYZAKER
//
//  Created by mac on 14-9-28.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYTopicView.h"
#import "UIImageView+WebCache.h"

@implementation EYTopicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTopicImage:(NSString *)url
{
    UIImageView *topicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    topicImageView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [self addSubview:topicImageView];
    [topicImageView sd_setImageWithURL:[NSURL URLWithString:url]];
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
