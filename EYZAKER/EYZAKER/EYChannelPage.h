//
//  EYChannelPage.h
//  EYZAKER
//
//  Created by mac on 14-9-30.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYPageBlock.h"

@protocol EYChannelPageDelegate;




@interface EYChannelPage : UIView

@property (nonatomic, strong)NSString *mainImageURL;

@property (nonatomic, strong)NSString *name;

@property (nonatomic, assign)id<EYChannelPageDelegate>delegate;

@property (nonatomic, strong)NSArray *pageData;

@property (nonatomic, strong)UIColor *bgColor;

@property (nonatomic, assign)NSInteger currentPage;

- (void)setPageWithPageCount:(NSInteger)count;

- (void)finishView;

@end


@protocol EYChannelPageDelegate <NSObject>

@optional
//返回按钮的回调函数
- (void)responseBack;
//点击block响应的回调函数
- (void)didSelectedBlock:(EYPageBlock *)block;

@end





