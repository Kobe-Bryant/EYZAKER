//
//  EYTopicRowView.h
//  EYZAKER
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EYTopicRowView : UIControl
//
////标题
//@property (strong, nonatomic) UILabel *titleLable;
////子标题
//@property (strong, nonatomic) UILabel *stitleLable;
////图片
//@property (strong, nonatomic) UIImageView *mainImageView;
//API
@property (strong, nonatomic) NSString *clickURL;

- (void)setRowViewWithDictionary:(NSDictionary *)best;

@end
