//
//  EYDailyHotCellA.m
//  EYZAKER
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYDailyHotCellA.h"
#import "UIImageView+WebCache.h"

@implementation EYDailyHotCellA

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

    if (modal.imagesURL.count >= 3) {
        //显示图片
        rect = self.oneImage.frame;
        rect.origin.y = CGRectGetMaxY(self.autherNameLable.frame) + 5;
        self.oneImage.frame = rect;
        [self.oneImage sd_setImageWithURL:[NSURL URLWithString:modal.imagesURL[0]]];
        
        rect = self.twoImage.frame;
        rect.origin.y = CGRectGetMaxY(self.autherNameLable.frame) + 5;
        self.twoImage.frame = rect;
        [self.twoImage sd_setImageWithURL:[NSURL URLWithString:modal.imagesURL[1]]];

        rect = self.threeImage.frame;
        rect.origin.y = CGRectGetMaxY(self.autherNameLable.frame) + 5;
        self.threeImage.frame = rect;
        [self.threeImage sd_setImageWithURL:[NSURL URLWithString:modal.imagesURL[2]]];
        
        rect = self.line.frame;
        rect.origin.y = CGRectGetMaxY(self.oneImage.frame) + 9;
        self.line.frame = rect;
        
        //显示图片,cell复用问题
        self.oneImage.hidden = NO;
        self.twoImage.hidden = NO;
        self.threeImage.hidden = NO;
    }
    else
    {
        //不显示图片
        self.oneImage.hidden = YES;
        self.twoImage.hidden = YES;
        self.threeImage.hidden = YES;
        
        rect = self.line.frame;
        rect.origin.y = CGRectGetMaxY(self.autherNameLable.frame) + 9;
        self.line.frame = rect;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
