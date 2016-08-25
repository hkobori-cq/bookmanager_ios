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
        //    NSArray *APIArray = response;
//    NSMutableArray *IDArray = [NSMutableArray array];
//
//    for (NSUInteger i = 0; i < APIArray.count; i++) {
//        [IDArray addObject:[APIArray[i] objectForKey:@"id"]];
//        [self.ImageArray addObject:[APIArray[i] objectForKey:@"image_url"]];
//        [self.TitleArray addObject:[APIArray[i] objectForKey:@"name"]];
//        [self.PriceArray addObject:[APIArray[i] objectForKey:@"price"]];
//        [self.DateArray addObject:[APIArray[i] objectForKey:@"purchase_date"]];
//    }


    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(didFailure:)]){
            [self.delegate didFailure:error];
        }
    }];
}
@end
