//
//  AFNetworkingModel.h
//  BookManager
//
//  Created by 小堀輝 on 2016/08/25.
//  Copyright © 2016年 hikaru kobori. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFNetworkingModel;

@protocol AFnetworkingDelegate <NSObject>
- (void)didSuccess:(NSArray *)response;
- (void)didFailure:(NSError *)error;
@end
@interface AFNetworkingModel : NSObject
@property (nonatomic, weak) id<AFnetworkingDelegate> delegate;
- (void)makeAFNetworkingRequest;
@end
