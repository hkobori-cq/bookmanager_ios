//
//  BookListViewCell.m
//  BookManager
//
//  Created by 小堀輝 on 2016/08/23.
//  Copyright © 2016年 hikaru kobori. All rights reserved.
//

#import <objc/runtime.h>
#import "BookListViewCell.h"
static char kCurrentIndexPathKey;
@implementation BookListViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSIndexPath *)currentIndexPath {
    return objc_getAssociatedObject(self,&kCurrentIndexPathKey);
}

- (void)setCurrentIndexPath:(NSIndexPath *)currentIndexPath {
    objc_setAssociatedObject(self,&kCurrentIndexPathKey,currentIndexPath,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end


//cell.BookTitleLabel.text = [array[0] objectForKey:@"name"];
//cell.DateLabel.text = [array[0] objectForKey:@"purchase_date"];
//NSInteger num = [array[0] objectForKey:@"price"];
//cell.BookFeeLabel.text = [NSString stringWithFormat:@"%@",num];