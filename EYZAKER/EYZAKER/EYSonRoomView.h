//
//  EYSonRoomView.h
//  EYZAKER
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EYSonRoomView : UIViewController
//整个sonRoom的标题
@property (nonatomic, strong)NSString *name;
//存放该分类下的所有son的数据
@property (nonatomic, strong)NSArray *roomData;

@end
