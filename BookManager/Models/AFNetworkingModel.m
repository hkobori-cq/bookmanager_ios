#import "AFNetworkingModel.h"
#import "APIModel.h"


@interface AFNetworkingModel () <AFNetworkingAPIController>
@property(strong, nonatomic) APIModel *apiModel;
@property(strong, nonatomic) DataModel *dataModel;
@end

@implementation AFNetworkingModel

- (id)actionName:(NSString *)typeOfAction {
    if (self == [super init]) {
        self.action = typeOfAction;
    }
    return self;
}

- (void)startAPIConnection:(NSDictionary *)receivedParam {
    NSLog(@"%@", self.action);
    NSLog(@"%@", receivedParam);
    if (self.apiModel == nil) {
        self.apiModel = [APIModel alloc];
    }
    self.apiModel.afNetworkingAPIControllerDelegate = self;
    if ([self.action isEqual:@"getBook"]) {
        [self.apiModel apiConnection:@"http://app.com/book/get" :receivedParam :self.action];
    } else if ([self.action isEqual:@"addBook"]) {
        [self.apiModel apiConnection:@"http://app.com/book/regist" :receivedParam :self.action];
    } else if ([self.action isEqual:@"editBook"]) {
        [self.apiModel apiConnection:@"http://app.com/book/update" :receivedParam :self.action];
    } else if ([self.action isEqual:@"userRegister"]) {
        [self.apiModel apiConnection:@"http://app.com/account/register" :receivedParam :self.action];
    } else if ([self.action isEqual:@"userLogin"]) {
        [self.apiModel apiConnection:@"http://app.com/account/login" :receivedParam :self.action];
    }
}

- (void)didAPIConnection:(NSDictionary *)response {
    NSLog(@"%@", self.action);
    NSLog(@"%@", response);
    self.dataModel = [[DataModel alloc] init];
    if ([self.action isEqual:@"getBook"]) {
        self.bookDataDictionary = [self.dataModel bookDataStore:response];
        if ([self.tableDelegate respondsToSelector:@selector(succeededGetBookData)]) {
            [self.tableDelegate succeededGetBookData];
        }
    } else if ([self.action isEqual:@"addBook"]) {
        if ([self.addDelegate respondsToSelector:@selector(succeededAddOrUpdateBookData:)]) {
            [self.addDelegate succeededAddOrUpdateBookData:@"書籍登録完了"];
        }
    } else if ([self.action isEqual:@"editBook"]) {
        if ([self.addDelegate respondsToSelector:@selector(succeededAddOrUpdateBookData:)]) {
            [self.addDelegate succeededAddOrUpdateBookData:@"書籍編集完了"];
        }
    } else if ([self.action isEqual:@"userRegister"]) {
        if ([self.userRegisterDelegate respondsToSelector:@selector(succeededUserRegister)]) {
            [self.userRegisterDelegate succeededUserRegister];
        }
    } else if ([self.action isEqual:@"userLogin"]) {
        if ([self.userLoginDelegate respondsToSelector:@selector(succeededUserLogin)]) {
            [self.userLoginDelegate succeededUserLogin];
        }
    }
}

- (void)didFailure {
    if ([self.action isEqual:@"addBook"]) {
        if ([self.addDelegate respondsToSelector:@selector(failedUploadData)]) {
            [self.addDelegate failedUploadData];
        }
    } else if ([self.action isEqual:@"editBook"]) {
        if ([self.addDelegate respondsToSelector:@selector(failedUploadData)]) {
            [self.addDelegate failedUploadData];
        }
    } else if ([self.action isEqual:@"userRegister"]) {
        if ([self.userRegisterDelegate respondsToSelector:@selector(failedUserRegister)]) {
            [self.userRegisterDelegate failedUserRegister];
        }
    } else if ([self.action isEqual:@"userLogin"]) {
        if ([self.userLoginDelegate respondsToSelector:@selector(failedUserLogin)]) {
            [self.userLoginDelegate failedUserLogin];
        }
    }
}

@end
