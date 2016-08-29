#import "AFNetworkingModel.h"
#import "APIModel.h"


@interface AFNetworkingModel () <AFNetworkingAPIController>
@property (strong, nonatomic) APIModel *apiModel;
@property (strong, nonatomic) DataModel *dataModel;
@end
@implementation AFNetworkingModel

- (id)actionName:(NSString *)typeOfAction {
    if (self == [super init]){
        self.action = typeOfAction;
    }
    return self;
}
- (void)startAPIConnection:(NSDictionary *)param{
    if (self.apiModel == nil){
        self.apiModel = [APIModel alloc];
    }
    self.apiModel.afNetworkingAPIControllerDelegate = self;
    if ([self.action isEqual:@"getBook"]) {
        [self.apiModel apiConnection:@"http://app.com/book/get":param:self.action];
    }
}

- (void)didAPIConnection:(NSDictionary *)response {
    self.dataModel = [[DataModel alloc] init];
    if ([self.action isEqual:@"getBook"]){
        self.bookDataDictionary = [self.dataModel bookDataStore:response];
        if ([self.tableDelegate respondsToSelector:@selector(didGetBookData)]) {
            [self.tableDelegate didGetBookData];
        }
    }
}

- (void)didFailure {
    if ([self.action isEqual:@"bookGet"]){
        if ([self.tableDelegate respondsToSelector:@selector(failedGetData)]){
            [self.tableDelegate failedGetData];
        }
    }
}

@end
