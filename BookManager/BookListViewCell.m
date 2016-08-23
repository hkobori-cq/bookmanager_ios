//
//  BookListViewCell.m
//  BookManager
//
//  Created by 小堀輝 on 2016/08/23.
//  Copyright © 2016年 hikaru kobori. All rights reserved.
//

#import "BookListViewCell.h"
#import <AFNetworking/AFNetworking.h>
@implementation BookListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://qiita.com/api/v1/users/anneau" parameters:nil progress:nil success:^(NSURLSessionTask *task,id responseObject){
        NSLog(@"%@",responseObject);
        self.BookTitleLabel.text = [responseObject objectForKey:@"name"];
//        self.BookImageView.image = [responseObject objectForKey:@"profile_image_url"];
        self.BookFeeLabel.text = [responseObject objectForKey:@"github"];
        self.DateLabel.text = [responseObject objectForKey:@"url"];
    } failure:^(NSURLSessionTask *operation,NSError *error) {
       NSLog(@"Error: %@",error);
    }];
}

@end
