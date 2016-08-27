#import "AFNetworkingModel.h"
#import <AFNetworking/AFNetworking.h>

@implementation AFNetworkingModel
/**
 * BookListControllerで使うAFNetworkingのPOSTメソッド
 * @param NSString url
 * @param NSDictionary param
 */
- (void)makeAFNetworkingRequest:(NSString *)url :(NSDictionary *)param {
    //マネージャーを生成
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //レスポンスのコンテンツタイプをjsonに設定
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //POSTをサーバーに非同期で送り、成功した時と失敗した時でdelegatedで通知
    [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //結果をresultをキーにしてAPIArrayに格納
        NSArray *APIArray = [responseObject objectForKey:@"result"];

        if ([self.delegate respondsToSelector:@selector(didSuccess:)]) {
            [self.delegate didSuccess:APIArray];
        }

    }     failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(didFailure:)]) {
            [self.delegate didFailure:error];
        }
    }];
}

/**
 * AddViewControllerで使うAFNetworkingのPOSTメソッド
 * @param NSString url
 * @param NSDictionary param
 */
- (void)makeAFNetworkingRequestHTML:(NSString *)url :(NSDictionary *)param {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //レスポンスのコンテンツタイプをhtmlに設定
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSLog(@"%@%@", url, param);
    [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *APIArray = [responseObject objectForKey:@"result"];
        NSLog(@"%@", APIArray);
        if ([self.delegate respondsToSelector:@selector(didSuccess:)]) {
            [self.delegate didSuccess:APIArray];
        }

    }     failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(didFailure:)]) {
            [self.delegate didFailure:error];
        }
    }];
}
@end
