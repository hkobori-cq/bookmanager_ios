//
//  APIModel.m
//  BookManager
//
//  Created by 小堀輝 on 2016/08/29.
//  Copyright © 2016年 hikaru kobori. All rights reserved.
//

#import "APIModel.h"
#import <AFNetworking/AFNetworking.h>

@implementation APIModel

- (void)apiConnection:(NSString *)url:(NSDictionary *)param:(NSString *)typeOfAction {
    //マネージャーを生成
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if ([typeOfAction isEqual:@"getBook"]){
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    }
    if ([typeOfAction isEqual:@"addBook"]){
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    }
    //POSTをサーバーに非同期で送り、成功した時と失敗した時でdelegatedで通知
    [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.afNetworkingAPIControllerDelegate respondsToSelector:@selector(didAPIConnection:)]) {
            [self.afNetworkingAPIControllerDelegate didAPIConnection:responseObject];
        }

    }     failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.afNetworkingAPIControllerDelegate respondsToSelector:@selector(didFailure)]) {
            [self.afNetworkingAPIControllerDelegate didFailure];
        }
    }];
}

@end
