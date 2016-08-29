#import "AFNetworkingModel.h"
#import "BookListController.h"
#import "BookListViewCell.h"
#import "AddViewController.h"


@interface BookListController () <AFNetworkingTableViewDelegate>{
    NSMutableArray *nameContents;
    NSMutableArray *imageContents;
    NSMutableArray *priceContents;
    NSMutableArray *dateContents;
    NSMutableArray *idNumArray;
    NSString *name;
    NSString *image;
    NSString *price;
    NSString *date;
    NSInteger *id;
}

@property (nonatomic) NSInteger count;

@property (nonatomic, strong) AFNetworkingModel *afNetworkingModel;

@end

@implementation BookListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //カスタムセルを呼び出す
    [self.tableView registerNib:[UINib nibWithNibName:@"BookListViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.afNetworkingModel = [[AFNetworkingModel alloc] actionName:@"getBook"];
    self.afNetworkingModel.tableDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    NSDictionary *param = @{@"page" : @"0-10"};
    [self.afNetworkingModel startAPIConnection:param];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    //カスタムセルを生成
    BookListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.BookTitleLabel.text = [NSString stringWithFormat:@"%@",nameContents[indexPath.row]];
    cell.BookFeeLabel.text = priceContents[indexPath.row];
    if (dateContents[indexPath.row]) {
        NSMutableString *changeDateStr = [[NSMutableString alloc] initWithString:dateContents[indexPath.row]];
        [changeDateStr deleteCharactersInRange:NSMakeRange(0, 4)];
        [changeDateStr deleteCharactersInRange:NSMakeRange(changeDateStr.length-3, 3)];

        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        [fmt setDateFormat:@"dd MMM yyyy HH:mm:ss"];
        [fmt setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSDate *changeDate = [fmt dateFromString:changeDateStr];

        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger flags;
        NSDateComponents *comps;

        // 年・月・日を取得
        flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        comps = [calendar components:flags fromDate:changeDate];

        NSInteger year  = comps.year;
        NSInteger month = comps.month;
        NSInteger day   = comps.day;

        cell.DateLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日", (long)year, (long)month, (long)day];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0;
}

/**
 * AFNetworkingModelが成功したときのメソッド
 */
- (void)didGetBookData {
    nameContents = [self CheckNil:[self.afNetworkingModel.bookDataDictionary valueForKey:@"name"]];
    imageContents = [self CheckNil:[self.afNetworkingModel.bookDataDictionary valueForKey:@"image"]];
    priceContents = [self CheckNil:[self.afNetworkingModel.bookDataDictionary valueForKey:@"price"]];
    dateContents = [self CheckNil:[self.afNetworkingModel.bookDataDictionary valueForKey:@"purchase_date"]];
    idNumArray = [self CheckNil:[self.afNetworkingModel.bookDataDictionary valueForKey:@"id"]];
    self.count = nameContents.count;
    [self.tableView reloadData];
}
/**
 * AFNetworkingModelが失敗した時のメソッド
 */
- (void)failedGetData {
}

/**
 * 配列がnilになったときはnilにNoDataを入れて返す
 */
- (id)CheckNil:(NSMutableArray *)array {
    for (int i=0;i < array.count;i++){
        if ([array[i] isEqual:[NSNull null]]){
            array[i] = @"NoData";
        }
    }
    return array;
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


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    name = nameContents[indexPath.row];
    image = imageContents[indexPath.row];
    price = imageContents[indexPath.row];
    date = dateContents[indexPath.row];
    AddViewController *addViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddViewController"];
    [addViewController editBookData:name :image :price :date];
    [self.navigationController pushViewController:addViewController animated:YES];
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
