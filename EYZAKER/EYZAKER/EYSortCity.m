//
//  EYSortCity.m
//  EYZAKER
//
//  Created by mac on 14-9-25.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYSortCity.h"

@implementation EYSortCity

+ (NSArray *)sortCity
{
    //读文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city_list" ofType:@"json"];
    NSData *contentData = [NSData dataWithContentsOfFile:path];
    
    NSMutableArray *names = [NSMutableArray array];
    //解析
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingMutableContainers error:nil];
    //获取热门城市
    NSArray *hotCity = dic[@"data"][@"hot_cities"];
    NSMutableArray *hotCityName = [NSMutableArray array];
    for (NSDictionary *city in hotCity) {
        NSString *name = city[@"name"];
        [hotCityName addObject:name];
    }
    [names addObject:hotCityName];
    //获取各个城市并分类
    NSArray *citys = dic[@"data"][@"cities"];
    for (NSInteger i = 0; i < 26; i ++) {
        NSMutableArray *cityName = [NSMutableArray array];
        for (NSDictionary *city in citys) {
            NSString *letter = city[@"letter"];
            unichar first = [letter characterAtIndex:0];
            if (first == (i + 97)) {
                NSString *name = city[@"name"];
                [cityName addObject:name];
            }
        }
        [names addObject:cityName];
    }
    return names;
}

+ (NSArray *)selectCityWithOption:(NSString *)selectString
{
    if (selectString.length == 0) {
        return [self sortCity];
    }
    //读文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city_list" ofType:@"json"];
    NSData *contentData = [NSData dataWithContentsOfFile:path];
    
    NSMutableArray *names = [NSMutableArray array];
    //解析
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingMutableContainers error:nil];
    //添加第一个为空数组
    NSMutableArray *hotCityName = [NSMutableArray array];
    [names addObject:hotCityName];
    
    //获取各个城市并分类
    NSArray *citys = dic[@"data"][@"cities"];
    for (NSInteger i = 0; i < 26; i ++) {
        NSMutableArray *cityName = [NSMutableArray array];
        for (NSDictionary *city in citys) {
            NSString *letter = city[@"letter"];
            NSString *name = city[@"name"];
            unichar first = [letter characterAtIndex:0];
            if (first == (i + 97) && [name rangeOfString:selectString].location != NSNotFound) {
                [cityName addObject:name];
            }
        }
        [names addObject:cityName];
    }
    return names;
}

+ (void)writeCityWithString:(NSString *)content
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city_list" ofType:@"json"];
    //[content writeToFile:<#(NSString *)#> atomically:<#(BOOL)#> encoding:<#(NSStringEncoding)#> error:]
}







@end
