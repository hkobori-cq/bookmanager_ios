#import <Foundation/Foundation.h>

@interface DataModel : NSObject
@property(nonatomic, strong) NSMutableDictionary *bookDataDict;
@property(nonatomic) NSMutableArray *nameArray;
@property(nonatomic) NSMutableArray *imageArray;
@property(nonatomic) NSMutableArray *priceArray;
@property(nonatomic) NSMutableArray *dateArray;
@property(nonatomic) NSMutableArray *idArray;

- (id)bookDataStore:(NSDictionary *)responseObject;
@end
