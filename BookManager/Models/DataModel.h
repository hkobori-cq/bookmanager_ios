//
//  DataModel.h
//  BookManager
//
//  Created by 小堀輝 on 2016/08/28.
//  Copyright © 2016年 hikaru kobori. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject
@property(nonatomic, strong) NSMutableDictionary *bookDataDict;
@property(nonatomic) NSMutableArray *nameArray;
@property(nonatomic) NSMutableArray *imageArray;
@property(nonatomic) NSMutableArray *priceArray;
@property(nonatomic) NSMutableArray *dateArray;
@property(nonatomic) NSMutableArray *idArray;

- (id)bookDataStore:(NSDictionary *)responseObject;
@end
