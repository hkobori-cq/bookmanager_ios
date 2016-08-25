//
//  BookListController.m
//  BookManager
//
//  Created by 小堀輝 on 2016/08/22.
//  Copyright © 2016年 hikaru kobori. All rights reserved.
//
#import "AFNetworkingModel.h"
#import "BookListController.h"
#import "BookListViewCell.h"


@interface BookListController () <UITableViewDataSource, UITableViewDelegate,AFnetworkingDelegate>{
}
@end

@implementation BookListController

- (void)viewDidLoad {
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BookListViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.


}

- (void)viewWillAppear:(BOOL)animated {
    AFNetworkingModel *afNetworkingModel = [[AFNetworkingModel alloc] init];
    [afNetworkingModel makeAFNetworkingRequest];
    afNetworkingModel.delegate = self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.BookTitleLabel.text = self.titleList[(NSUInteger)indexPath.row];
    cell.BookFeeLabel.text = [NSString stringWithFormat:@"%d",self.priceList[(NSUInteger)indexPath.row]];
    cell.BookImageView.image = [UIImage imageNamed:@"sample.jpg"];
    cell.DateLabel.text = self.dateList[(NSUInteger)indexPath.row];
    NSString *time = self.dateList[(NSUInteger)indexPath.row];
    NSDateFormatter *Date = [[NSDateFormatter alloc] init];
    [Date setDateFormat:@"EEE, dd MM yyy HH:mm:ss Z"];
    [Date setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"JP"]];
    NSDate *date = [Date dateFromString:time];
    NSDateFormatter *output_format = [[NSDateFormatter alloc] init];
    [output_format setDateFormat:@"yyyy/MM/dd"];;
    cell.DateLabel.text = [output_format stringFromDate:date];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0;
}

- (void)didSuccess:(NSArray *)response {
    NSArray *APIArray = response;
    NSMutableArray *IDArray = [NSMutableArray array];
    NSMutableArray *ImageArray = [NSMutableArray array];
    NSMutableArray *TitleArray = [NSMutableArray array];
    NSMutableArray *PriceArray = [NSMutableArray array];
    NSMutableArray *DateArray = [NSMutableArray array];

    for (NSUInteger i = 0; i < APIArray.count; i++) {
        [IDArray addObject:[APIArray[i] objectForKey:@"id"]];
        [ImageArray addObject:[APIArray[i] objectForKey:@"image_url"]];
        [TitleArray addObject:[APIArray[i] objectForKey:@"name"]];
        [PriceArray addObject:[APIArray[i] objectForKey:@"price"]];
        [DateArray addObject:[APIArray[i] objectForKey:@"purchase_date"]];
    }
    self.titleList = TitleArray;
    self.priceList = PriceArray;
    self.dateList = DateArray;
    [self.tableView reloadData];
}

- (void)didFailure:(NSError *)error {
    NSLog(@"error");
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:[NSString stringWithFormat:@"%d",indexPath.row] forKey:@"num"];
    [self performSegueWithIdentifier:@"rowNumber" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
