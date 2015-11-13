//
//  EYRoomCell.h
//  EYZAKER
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYRoomModal.h"

@interface EYRoomCell : UITableViewCell
// 图片
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

- (void)setRoomRowWithModal:(EYRoomModal *)modal;

@end
