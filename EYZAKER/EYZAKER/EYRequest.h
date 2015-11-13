//
//  EYRequest.h
//  2保存网络数据
//
//  Created by mac on 14-9-12.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EYRequestDelegate;

@interface EYRequest : NSObject

@property (nonatomic, assign)id<EYRequestDelegate> delagate;

@property (nonatomic, strong)NSString *responseString;

@property (nonatomic, strong)NSData *responseData;

@property (nonatomic, assign)NSInteger tag;

//初始化
- (id)initRequestWithUrl:(NSURL *)url;
//发送请求
- (void)startAsynchronous;
//取消请求
- (void)cancel;


@end

@protocol EYRequestDelegate <NSObject>

@optional
- (void)didReceiveResponse:(EYRequest *)request;
//请求完成的回调
- (void)requestDidFinish:(EYRequest *)request;
//请求失败的回调
- (void)requestFailed:(EYRequest *)request;

@end