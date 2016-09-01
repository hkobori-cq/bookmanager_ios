#import <Foundation/Foundation.h>
#import "DataModel.h"


@protocol AFNetworkingTableViewDelegate <NSObject>
- (void)succeededGetBookData;

- (void)failedGetData;
@end

@protocol AFNetworkingAddDelegate <NSObject>
- (void)succeededAddOrUpdateBookData:(NSString *)received_message;

- (void)failedUploadData;
@end

@protocol AFNetworkingUserRegisterDelegate <NSObject>
- (void)succeededUserRegister;

- (void)failedUserRegister;
@end

@protocol AFNetworkingUserLoginDelegate <NSObject>
- (void)succeededUserLogin;

- (void)failedUserLogin;
@end


@interface AFNetworkingModel : NSObject
@property(strong, nonatomic) NSMutableDictionary *bookDataDictionary;
@property(strong, nonatomic) NSString *action;
@property(weak, nonatomic) id <AFNetworkingTableViewDelegate> tableDelegate;
@property(weak, nonatomic) id <AFNetworkingAddDelegate> addDelegate;
@property(weak, nonatomic) id <AFNetworkingUserRegisterDelegate> userRegisterDelegate;
@property(weak, nonatomic) id <AFNetworkingUserLoginDelegate> userLoginDelegate;

- (void)startAPIConnection:(NSDictionary *)param;

- (id)actionName:(NSString *)typeOfAction;
@end
