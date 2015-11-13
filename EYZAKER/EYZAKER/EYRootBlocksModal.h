//
//  EYRootBlocksModal.h
//  EYZAKER
//
//  Created by mac on 14-9-28.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EYRootBlocksModal : NSObject
//应用名字
@property (nonatomic, strong)NSString *title;
//图片url
@property (nonatomic, strong)NSString *imgURL;
//颜色
@property (nonatomic, strong)NSString *colorValue;
//链接
@property (nonatomic, strong)NSString *apiURL;

@end
