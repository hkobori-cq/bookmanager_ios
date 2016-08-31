#import <Foundation/Foundation.h>

@protocol AFNetworkingAPIController <NSObject>
- (void)didAPIConnection:(NSDictionary *)response;

- (void)didFailure;
@end

@interface APIModel : NSObject
@property(weak, nonatomic) id <AFNetworkingAPIController> afNetworkingAPIControllerDelegate;

- (void)apiConnection:(NSString *)url :(NSDictionary *)param :(NSString *)typeOfAction;

@end
