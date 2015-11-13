//
//  EYChannelPageModal.h
//  EYZAKER
//
//  Created by mac on 14-9-30.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EYChannelPageModal : NSObject
//文章标题
@property (nonatomic, strong)NSString *title;
//来源
@property (nonatomic, strong)NSString *autherName;
//链接
@property (nonatomic, strong)NSString *clickURL;
//图片
@property (nonatomic, strong)NSString *imageURL;

@end
