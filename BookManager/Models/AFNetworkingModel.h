#import <Foundation/Foundation.h>

@class AFNetworkingModel;

@protocol AFnetworkingDelegate <NSObject>
- (void)didSuccess:(NSArray *)response;

- (void)didFailure:(NSError *)error;

@end

@interface AFNetworkingModel : NSObject
@property(nonatomic, weak) id <AFnetworkingDelegate> delegate;


- (void)makeAFNetworkingRequest:(NSString *)url :(NSDictionary *)param;

- (void)makeAFNetworkingRequestHTML:(NSString *)url :(NSDictionary *)param;
@end
