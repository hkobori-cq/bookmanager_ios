//
//  BookListViewCell.h
//  BookManager
//
//  Created by 小堀輝 on 2016/08/23.
//  Copyright © 2016年 hikaru kobori. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *BookImageView;
@property (weak, nonatomic) IBOutlet UILabel *BookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *BookFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
@property (weak, nonatomic) IBOutlet UIView *nextLabel;

@end
