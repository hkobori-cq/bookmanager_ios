#import <UIKit/UIKit.h>

@interface AddViewController : UIViewController

- (void)addBookData;

- (void)receiveEditBookData:(NSString *)name :(NSString *)image :(NSString *)price :(NSString *)date :(NSInteger *)idNum;
@end
