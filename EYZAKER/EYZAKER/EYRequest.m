//
//  EYRequest.m
//  2保存网络数据
//
//  Created by mac on 14-9-12.
//  Copyright (c) 2014年 Emma. All rights reserved.
//

#import "EYRequest.h"

@interface EYRequest () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong)NSURLRequest *request;
@property (nonatomic, strong)NSMutableData *downloadData;
@property (nonatomic, strong)NSURLConnection *conn;
@end

@implementation EYRequest

- (id)initRequestWithUrl:(NSURL *)url
{
    if (self = [super init]) {
        self.request = [NSURLRequest requestWithURL:url];
        self.downloadData = [NSMutableData data];
        self.responseData = [NSMutableData data];
    }
    return self;
}
//发送请求
- (void)startAsynchronous
{
    self.conn = [NSURLConnection connectionWithRequest:self.request delegate:self];
}

- (void)cancel
{
    [self.conn cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.downloadData.length = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.downloadData appendData:data];
    if ([self.delagate respondsToSelector:@selector(didReceiveResponse:)]) {
        [self.delagate didReceiveResponse:self];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.responseData = self.downloadData;
    self.responseString = [[NSString alloc] initWithData:self.downloadData encoding:NSUTF8StringEncoding];    
    if ([self.delagate respondsToSelector:@selector(requestDidFinish:)]) {
        [self.delagate requestDidFinish:self];
    }

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self.delagate respondsToSelector:@selector(requestFailed:)]) {
        [self.delagate requestFailed:self];
    }
}


@end
