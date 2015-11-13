//
//  EYSonRoomCell.h
//  EYZAKER
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYSonRoomModal.h"

@interface EYSonRoomCell : UITableViewCell
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
//标记
@property (weak, nonatomic) IBOutlet UIButton *markButton;

- (void)setCellWithModal:(EYSonRoomModal *)modal;

@end
