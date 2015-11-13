//
//  EYDailyHotModal.h
//  EYZAKER
//
//  Created by mac on 14-9-26.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EYDailyHotModal : NSObject
//文章标题
@property (nonatomic, strong)NSString *title;
//来源
@property (nonatomic, strong)NSString *autherName;
//标记小图片
@property (nonatomic, strong)NSString *iconURL;
//时间
@property (nonatomic, strong)NSString *date;
//链接
@property (nonatomic, strong)NSString *clickURL;
//图片地址
@property (nonatomic, strong)NSMutableArray *imagesURL;

//标题的高度
@property (nonatomic, assign)CGFloat titleLableHight;
//是否显示一张图片
@property (nonatomic, assign)BOOL showOneImage;

@property (nonatomic, assign)BOOL noneImage;

@end
