//
//  EYCityCell.h
//  EYZAKER
//
//  Created by mac on 14-9-25.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EYCityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityNameLable;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

- (void)fillCellWithName:(NSString *)name;
- (void)selected:(BOOL)n;

@end
