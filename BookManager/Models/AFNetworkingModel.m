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

- (void)startAPIConnection:(NSDictionary *)received_param {

    if (self.apiModel == nil) {
        self.apiModel = [APIModel alloc];
    }
    self.apiModel.afNetworkingAPIControllerDelegate = self;
    if ([self.action isEqual:@"getBook"]) {
        [self.apiModel apiConnection:@"http://app.com/book/get" :received_param :self.action];
    } else if ([self.action isEqual:@"addBook"]) {
        [self.apiModel apiConnection:@"http://app.com/book/regist" :received_param :self.action];
    } else if ([self.action isEqual:@"editBook"]) {
        [self.apiModel apiConnection:@"http://app.com/book/update" :received_param :self.action];
    } else if ([self.action isEqual:@"userRegister"]) {
        [self.apiModel apiConnection:@"http://app.com/account/register" :received_param :self.action];
    } else if ([self.action isEqual:@"userLogin"]) {
        [self.apiModel apiConnection:@"http://app.com/account/login" :received_param :self.action];
    }
}

- (void)didAPIConnection:(NSDictionary *)response {
    self.dataModel = [[DataModel alloc] init];
    if ([self.action isEqual:@"getBook"]) {
        self.bookDataDictionary = [self.dataModel bookDataStore:response];
        if ([self.tableDelegate respondsToSelector:@selector(didGetBookData)]) {
            [self.tableDelegate didGetBookData];
        }
    } else if ([self.action isEqual:@"addBook"]) {
        if ([self.addDelegate respondsToSelector:@selector(didAddOrUpdateBookData:)]) {
            [self.addDelegate didAddOrUpdateBookData:@"書籍登録完了"];
        }
    } else if ([self.action isEqual:@"editBook"]) {
        if ([self.addDelegate respondsToSelector:@selector(didAddOrUpdateBookData:)]) {
            [self.addDelegate didAddOrUpdateBookData:@"書籍編集完了"];
        }
    } else if ([self.action isEqual:@"userRegister"]) {
        if ([self.userRegisterDelegate respondsToSelector:@selector(succeededUserRegister)]) {
            [self.userRegisterDelegate succeededUserRegister];
        }
    } else if ([self.action isEqual:@"userLogin"]) {
        if ([self.userLoginDelegate respondsToSelector:@selector(didUserLogin)]) {
            [self.userLoginDelegate didUserLogin];
        }
    }
}

- (void)didFailure {
    if ([self.action isEqual:@"getBook"]) {
        if ([self.tableDelegate respondsToSelector:@selector(failedGetData)]) {
            [self.tableDelegate failedGetData];
        }
    } else if ([self.action isEqual:@"addBook"]) {
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
