//
//  EYSortCity.h
//  EYZAKER
//
//  Created by mac on 14-9-25.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EYSortCity : NSObject
//获得城市的数据
+ (NSArray *)sortCity;
//查找城市
+ (NSArray *)selectCityWithOption:(NSString *)selectString;

+ (void)writeCityWithString:(NSString *)content;

@end
