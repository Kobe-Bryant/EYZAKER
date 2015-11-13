//
//  EYDailyHotCellB.m
//  EYZAKER
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYDailyHotCellB.h"
#import "UIImageView+WebCache.h"

@implementation EYDailyHotCellB

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setCellWithModal:(EYDailyHotModal *)modal
{
    //设置标题
    self.titleLable.text = modal.title;
    self.titleLable.numberOfLines = 0;
    
    CGRect rect = self.titleLable.frame;
    rect.size.height = modal.titleLableHight;
    self.titleLable.frame = rect;
    
    //设置来源lable和时间lable/标记图片
    self.autherNameLable.text = modal.autherName;
    
    rect = self.autherNameLable.frame;
    rect.origin.y = CGRectGetMaxY(self.titleLable.frame) + 5;
    rect.size.width = modal.autherName.length * 10;
    self.autherNameLable.frame = rect;
    
    if (modal.iconURL) {
        //显示标记图片
        self.dateLable.hidden = YES;
        self.dateLable.backgroundColor = [UIColor clearColor];
        self.iconImageView.hidden = NO;
        //设置标记图片
        rect = self.iconImageView.frame;
        rect.origin.y = CGRectGetMinY(self.autherNameLable.frame);
        rect.origin.x = CGRectGetMaxX(self.autherNameLable.frame) + 5;
        self.iconImageView.frame = rect;
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:modal.iconURL]];
    }
    else
    {
        //显示时间
        self.iconImageView.hidden = YES;
        self.dateLable.hidden = NO;
        //设置时间
        rect = self.dateLable.frame;
        rect.size.width = 50;
        rect.origin.y = CGRectGetMinY(self.autherNameLable.frame);
        rect.origin.x = CGRectGetMaxX(self.autherNameLable.frame) + 5;
        self.dateLable.frame = rect;
        
        self.dateLable.text = modal.date;
    }
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:modal.imagesURL[0]]];
    
    rect = self.line.frame;
    rect.origin.y = CGRectGetMaxY(self.image.frame) + 9;
    
    self.line.frame = rect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
