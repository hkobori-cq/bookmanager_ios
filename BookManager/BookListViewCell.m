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
    NSString *url = @"http://app.com/book/get";

    NSDictionary *param = [[NSDictionary alloc]init];
    param = @{@"page":@"0-10"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",nil];
    [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = [responseObject objectForKey:@"result"];
        NSLog(@"%@",array);
        self.BookTitleLabel.text = [array[1] objectForKey:@"name"];
        self.DateLabel.text = [array[1] objectForKey:@"purchase_date"];
        NSInteger num = [array[1] objectForKey:@"price"];
        self.BookFeeLabel.text = [NSString stringWithFormat:@"%@",num];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

@end
