//
//  EYDailyHotCellB.h
//  EYZAKER
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYDailyHotModal.h"

@interface EYDailyHotCellB : UITableViewCell

//文章标题
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
//来源
@property (weak, nonatomic) IBOutlet UILabel *autherNameLable;
//标记小图片
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//时间
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
//图片地址
@property (weak, nonatomic) IBOutlet UIImageView *image;


@property (weak, nonatomic) IBOutlet UIImageView *line;

- (void)setCellWithModal:(EYDailyHotModal *)modal;

@end
