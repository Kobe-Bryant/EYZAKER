//
//  EYCityCell.m
//  EYZAKER
//
//  Created by mac on 14-9-25.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYCityCell.h"

@implementation EYCityCell

- (void)awakeFromNib
{
    // Initialization code
    self.cityNameLable.font = [UIFont fontWithName:@"FZLanTingHei-R-GBK" size:13];
    self.selectImageView.hidden = YES;
}

- (void)fillCellWithName:(NSString *)name
{
    self.cityNameLable.text = name;
}

- (void)selected:(BOOL)n
{
    if (n == YES) {
        self.selectImageView.hidden = NO;
    }
    else
    {
        self.selectImageView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
