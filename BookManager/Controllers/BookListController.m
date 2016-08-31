#import "AFNetworkingModel.h"
#import "BookListController.h"
#import "BookListViewCell.h"
#import "AddViewController.h"


@interface BookListController () <AFNetworkingTableViewDelegate> {
    NSMutableArray *nameContents;
    NSMutableArray *imageContents;
    NSMutableArray *priceContents;
    NSMutableArray *dateContents;
    NSMutableArray *idNumArray;
    NSString *name;
    NSString *image;
    NSString *price;
    NSString *date;
    NSInteger *idNum;
}

@property(nonatomic) NSInteger count;

@property(nonatomic, strong) AFNetworkingModel *afNetworkingModel;

@property(nonatomic) NSInteger currentPage;
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
    //初めに10コのデータを用意しておく
    NSDictionary *param = @{@"page" : @"0-10"};
    [self.afNetworkingModel startAPIConnection:param];
}


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
    cell.BookTitleLabel.text = [NSString stringWithFormat:@"%@", nameContents[(NSUInteger) indexPath.row]];
    cell.BookFeeLabel.text = priceContents[(NSUInteger) indexPath.row];
    UIImageView *cellImage = [[UIImageView alloc] init];
    cellImage.image = [UIImage imageNamed:imageContents[(NSUInteger) indexPath.row]];
    if (cellImage.image.size.height == 0) {
        UIImage *sampleImage = [UIImage imageNamed:@"sample.jpg"];
        UIImageView *sampleImageView = [[UIImageView alloc] initWithImage:sampleImage];
        sampleImageView.frame = CGRectMake(0, 0, 100, 100);
        [cell.BookImageView addSubview:sampleImageView];
    } else {
        [cell.BookImageView addSubview:cellImage];
    }
    //日付の書式を変更する
    if (dateContents[(NSUInteger) indexPath.row]) {
        NSMutableString *changeDateStr = [[NSMutableString alloc] initWithString:dateContents[(NSUInteger) indexPath.row]];
        [changeDateStr deleteCharactersInRange:NSMakeRange(0, 4)];
        [changeDateStr deleteCharactersInRange:NSMakeRange(changeDateStr.length - 3, 3)];

        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        [fmt setDateFormat:@"dd MMM yyyy HH:mm:ss"];
        [fmt setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSDate *changeDate = [fmt dateFromString:changeDateStr];

        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger flags;
        NSDateComponents *comps;

        // 年・月・日を取得
        flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        comps = [calendar components:flags fromDate:changeDate];

        NSInteger year = comps.year;
        NSInteger month = comps.month;
        NSInteger day = comps.day;

        cell.DateLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日", (long) year, (long) month, (long) day];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BookListViewCell rowHeight];
}

/**
 * AFNetworkingModelが成功したときのメソッド
 * データを配列に入れる
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
    for (NSUInteger i = 0; i < array.count; i++) {
        if ([array[i] isEqual:[NSNull null]]) {
            array[i] = @"NoData";
        }
    }
    return array;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/**
 * tableViewのセルをクリックしたときのメソッド
 * データを編集画面に送り、navigation移動する
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    idNum = [idNumArray[indexPath.row] integerValue];
    name = nameContents[(NSUInteger) indexPath.row];
    image = imageContents[(NSUInteger) indexPath.row];
    price = priceContents[(NSUInteger) indexPath.row];
    date = dateContents[(NSUInteger) indexPath.row];
    AddViewController *addViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddViewController"];
    [addViewController editBookData:name :image :price :date :idNum];
    [self.navigationController pushViewController:addViewController animated:YES];
}

/**
 * 書籍追加のボタンを押したときの動作
 */
- (IBAction)moveAddViewControllerButton:(id)sender {
    AddViewController *addViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddViewController"];
    [addViewController addBookData];
    UINavigationController *addNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNavigationController"];
    [self presentViewController:addNavigationController animated:YES completion:nil];
}

/**
 * スクロールしたときに呼び出されるメソッド
 * AFNetworkingで通信を行う
 */
- (void)readMoreData {
    self.currentPage++;
    NSString *currentPageNumber = [NSString stringWithFormat:@"0-%d", self.currentPage * 5, self.currentPage * 5 + 5];
    NSLog(@"%@", currentPageNumber);
    [self.afNetworkingModel startAPIConnection:@{@"page" : currentPageNumber}];
}

/**
 * tableViewがスクロールしたときに呼ばれるデリケードメソッド
 * スクロールするごとにreadMoreDataが呼ばれ、データを非同期に持ってくる
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) {
        if (self.count + 1 > self.currentPage * 5) {
            [self performSelector:@selector(readMoreData)];
        }
    }
}

@end
