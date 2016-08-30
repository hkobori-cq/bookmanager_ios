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

- (void)startAPIConnection:(NSDictionary *)param {

    if (self.apiModel == nil) {
        self.apiModel = [APIModel alloc];
    }
    self.apiModel.afNetworkingAPIControllerDelegate = self;
    if ([self.action isEqual:@"getBook"]) {
        [self.apiModel apiConnection:@"http://app.com/book/get" :param :self.action];
    } else if ([self.action isEqual:@"addBook"]) {
        [self.apiModel apiConnection:@"http://app.com/book/regist" :param :self.action];
    } else if ([self.action isEqual:@"editBook"]){
        [self.apiModel apiConnection:@"http://app.com/book/update" :param :self.action];
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
    } else if ([self.action isEqual:@"editBook"]){
        if ([self.addDelegate respondsToSelector:@selector(didAddOrUpdateBookData:)]){
            [self.addDelegate didAddOrUpdateBookData:@"書籍編集完了"];
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
    } else if ([self.action isEqual:@"editBook"]){
        if ([self.addDelegate respondsToSelector:@selector(failedUploadData)]){
            [self.addDelegate failedUploadData];
        }
    }
}

@end
