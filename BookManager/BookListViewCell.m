//
//  BookListViewCell.m
//  BookManager
//
//  Created by 小堀輝 on 2016/08/23.
//  Copyright © 2016年 hikaru kobori. All rights reserved.
//

#import "BookListViewCell.h"

@implementation BookListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.BookTitleLabel.text = @"パーフェクトPHP";
    self.BookFeeLabel.text = @"3600円 + 税";
    self.DateLabel.text = @"2014/04/03";
}

@end
