#import "APIModel.h"
#import <AFNetworking/AFNetworking.h>

@implementation APIModel

- (void)apiConnection:(NSString *)url :(NSDictionary *)param :(NSString *)typeOfAction {
    //マネージャーを生成
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if ([typeOfAction isEqual:@"getBook"]) {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    }
    if ([typeOfAction isEqual:@"addBook"] || [typeOfAction isEqual:@"editBook"] || [typeOfAction isEqual:@"userRegister"] || [typeOfAction isEqual:@"userLogin"]) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    }
    //POSTをサーバーに非同期で送り、成功した時と失敗した時でdelegatedで通知
    [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.afNetworkingAPIControllerDelegate respondsToSelector:@selector(didAPIConnection:)]) {
            [self.afNetworkingAPIControllerDelegate didAPIConnection:responseObject];
        }

    }     failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        if ([self.afNetworkingAPIControllerDelegate respondsToSelector:@selector(didFailure)]) {
            [self.afNetworkingAPIControllerDelegate didFailure];
        }
    }];
}

@end
