#import <objc/runtime.h>
#import "BookListViewCell.h"


@implementation BookListViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (CGFloat)rowHeight {
    return 150.0f;
}

@end