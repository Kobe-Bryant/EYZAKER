//
//  EYSonRoomModal.h
//  EYZAKER
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EYSonRoomModal : NSObject
//标题
@property (nonatomic, strong)NSString *title;
//API
@property (nonatomic, strong)NSString *apiURL;
//整个block的字典内容，用于添加的时候保存数据
@property (nonatomic, strong)NSDictionary *blockInfo;

@end
