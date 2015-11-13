//
//  EYTopicView.h
//  EYZAKER
//
//  Created by mac on 14-9-28.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EYTopicView : UIControl

//标题
@property (nonatomic, strong)NSString *title;
//点击的API
@property (nonatomic, strong)NSString *topicURL;
//设置control图片
- (void)setTopicImage:(NSString *)url;

@end
