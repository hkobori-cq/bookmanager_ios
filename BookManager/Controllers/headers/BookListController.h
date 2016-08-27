#import <UIKit/UIKit.h>

@interface BookListController : UITableViewController <AFnetworkingDelegate, UITableViewDelegate, UITableViewDataSource>
@property(strong, nonatomic) NSMutableArray *idList;
@property(strong, nonatomic) NSMutableArray *urlList;
@property(strong, nonatomic) NSMutableArray *titleList;
@property(strong, nonatomic) NSMutableArray *priceList;
@property(strong, nonatomic) NSMutableArray *dateList;
@property(strong, nonatomic) UIActivityIndicatorView *indicator;

@end
