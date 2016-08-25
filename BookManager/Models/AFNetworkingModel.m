//
//  AFNetworkingModel.m
//  BookManager
//
//  Created by 小堀輝 on 2016/08/25.
//  Copyright © 2016年 hikaru kobori. All rights reserved.
//

#import "AFNetworkingModel.h"
#import <AFNetworking/AFNetworking.h>
@implementation AFNetworkingModel



- (void)makeAFNetworkingRequest
{
    NSString *url = @"http://app.com/book/get";
    NSDictionary *param = @{@"page":@"0-3"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"application/json"];
    [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *APIArray = [responseObject objectForKey:@"result"];
        if ([self.delegate respondsToSelector:@selector(didSuccess:)]){
            [self.delegate didSuccess:APIArray];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(didFailure:)]){
            [self.delegate didFailure:error];
        }
    }];
}
@end
