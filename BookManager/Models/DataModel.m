#import "DataModel.h"

@implementation DataModel

- (id)init {
    if (self = [super init]) {
        self.nameArray = [NSMutableArray array];
        self.imageArray = [NSMutableArray array];
        self.priceArray = [NSMutableArray array];
        self.dateArray = [NSMutableArray array];
        self.idArray = [NSMutableArray array];
        self.bookDataDict = [NSMutableDictionary dictionary];
    }
    return self;
}

/**
 * データを保存するためのメソッド
 */
- (id)bookDataStore:(NSDictionary *)responseObject {
    NSDictionary *dictionary = [responseObject valueForKey:@"result"];
    for (NSDictionary *data in dictionary) {
        NSString *image = [data valueForKey:@"image_url"];
        NSString *name = [data valueForKey:@"name"];
        NSString *price = [[data valueForKey:@"price"] stringValue];
        NSString *date = [data valueForKey:@"purchase_date"];
        NSString *idNumber = [data valueForKey:@"id"];

        [self.nameArray addObject:name];
        [self.priceArray addObject:price];
        [self.imageArray addObject:image];
        [self.dateArray addObject:date];
        [self.idArray addObject:idNumber];
    }

    NSMutableDictionary *bookDictionary = [NSMutableDictionary dictionary];
    bookDictionary[@"name"] = self.nameArray;
    bookDictionary[@"image"] = self.imageArray;
    bookDictionary[@"price"] = self.priceArray;
    bookDictionary[@"purchase_date"] = self.dateArray;
    bookDictionary[@"id"] = self.idArray;

    return bookDictionary;

}

@end
