//
//  APIModel.h
//  BookManager
//
//  Created by 小堀輝 on 2016/08/29.
//  Copyright © 2016年 hikaru kobori. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFNetworkingAPIController <NSObject>
- (void)didAPIConnection:(NSDictionary *)response;

- (void)didFailure;
@end

@interface APIModel : NSObject
@property(weak, nonatomic) id <AFNetworkingAPIController> afNetworkingAPIControllerDelegate;

- (void)apiConnection:(NSString *)url :(NSDictionary *)param :(NSString *)typeOfAction;

@end
