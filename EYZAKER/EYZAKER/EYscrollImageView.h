//
//  EYscrollImageView.h
//  EYZAKER
//
//  Created by mac on 14-10-2.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EYscrollImageView : UIControl
//类型
@property (nonatomic, strong)NSString *type;
//API接口
@property (nonatomic, strong)NSString *apiUrl;
//将请求到的整个字典给这个UIControl，在这个control内解析
- (void)setViewWithInfo:(NSDictionary *)viewInfo;

@end
