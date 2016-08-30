#import <Foundation/Foundation.h>
#import "DataModel.h"


@protocol AFNetworkingTableViewDelegate <NSObject>
- (void)didGetBookData;

- (void)failedGetData;
@end

@protocol AFNetworkingAddDelegate <NSObject>
- (void)didAddOrUpdateBookData:(NSString *)message;

- (void)failedUploadData;
@end

@protocol AFNetworkingUserRegisterDelegate <NSObject>
- (void)didUserRegister;

- (void)failedUserRegister;
@end


@interface AFNetworkingModel : NSObject
@property(strong, nonatomic) NSMutableDictionary *bookDataDictionary;
@property(strong, nonatomic) NSString *action;
@property(weak, nonatomic) id <AFNetworkingTableViewDelegate> tableDelegate;
@property(weak, nonatomic) id <AFNetworkingAddDelegate> addDelegate;
@property(weak, nonatomic) id <AFNetworkingUserRegisterDelegate> userRegisterDelegate;

- (void)startAPIConnection:(NSDictionary *)param;

- (id)actionName:(NSString *)typeOfAction;
@end
