//
//  BookListController.h
//  BookManager
//
//  Created by 小堀輝 on 2016/08/22.
//  Copyright © 2016年 hikaru kobori. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookListController : UITableViewController
@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) NSMutableArray *titleList;
@property (strong, nonatomic) NSMutableArray *priceList;
@property (strong, nonatomic) NSMutableArray *dateList;

@end
