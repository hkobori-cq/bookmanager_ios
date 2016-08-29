//
//  DataModel.m
//  BookManager
//
//  Created by 小堀輝 on 2016/08/28.
//  Copyright © 2016年 hikaru kobori. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (id)init {
    if (self = [super init]) {
        self.nameArray = [NSMutableArray array];
        self.imageArray = [NSMutableArray array];
        self.priceArray = [NSMutableArray array];
        self.dateArray  = [NSMutableArray array];
        self.idArray    = [NSMutableArray array];
        self.bookDataDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)bookDataStore:(NSDictionary *)responseObject {
    NSDictionary *dictionary = [responseObject valueForKey:@"result"];
    for (NSDictionary *data in dictionary){
        NSString *image = [data valueForKey:@"image_url"];
        NSString *name = [data valueForKey:@"name"];
        NSString *price = [[data valueForKey:@"price"] stringValue];
        NSString *date = [data valueForKey:@"purchase_date"];
        NSString *idNumber = [data valueForKey:@"id"];

        [self.nameArray addObject:name];
        [self.priceArray addObject:price];
        [self.imageArray addObject:image];
        [self.dateArray addObject:date];
        [self.idArray addObject:idNumber];
    }
    NSLog(@"%@",self.nameArray);

    NSMutableDictionary *bookDictionary = [NSMutableDictionary dictionary];
    [bookDictionary setObject:self.nameArray forKey:@"name"];
    [bookDictionary setObject:self.imageArray forKey:@"image"];
    [bookDictionary setObject:self.priceArray forKey:@"price"];
    [bookDictionary setObject:self.dateArray  forKey:@"purchase_date"];
    [bookDictionary setObject:self.idArray    forKey:@"id"];

    return bookDictionary;

}

@end
