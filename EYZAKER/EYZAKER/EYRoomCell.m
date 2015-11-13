//
//  EYRoomCell.m
//  EYZAKER
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYRoomCell.h"
#import "UIImageView+WebCache.h"

@implementation EYRoomCell

- (void)awakeFromNib
{
    // Initialization code
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 54.3, 320, 0.7)];
    line.image = [UIImage imageNamed:@"line"];
    [self.contentView addSubview:line];
}

- (void)setRoomRowWithModal:(EYRoomModal *)modal
{
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:modal.picURL]];
    self.titleLable.text = modal.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
