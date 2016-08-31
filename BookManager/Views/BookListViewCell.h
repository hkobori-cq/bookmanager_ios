#import <UIKit/UIKit.h>

@interface BookListViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UIImageView *BookImageView;
@property(weak, nonatomic) IBOutlet UILabel *BookTitleLabel;
@property(weak, nonatomic) IBOutlet UILabel *BookFeeLabel;
@property(weak, nonatomic) IBOutlet UILabel *DateLabel;
@property(weak, nonatomic) IBOutlet UIView *nextLabel;

+ (CGFloat)rowHeight;
@end
