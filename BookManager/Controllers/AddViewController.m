#import "AddViewController.h"
#import "AFNetworkingModel.h"

@interface AddViewController () <AFNetworkingAddDelegate, UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UITextField *bookNameBox;
@property(weak, nonatomic) IBOutlet UITextField *priceBox;
@property(weak, nonatomic) IBOutlet UITextField *dateBox;

@property(nonatomic) NSInteger year;
@property(nonatomic) NSInteger month;
@property(nonatomic) NSInteger day;

@property(nonatomic) NSString *name;
@property(nonatomic) NSString *image;
@property(nonatomic) NSString *price;
@property(nonatomic) NSString *date;
@property(nonatomic) NSString *idStr;

@property (assign, nonatomic) BOOL flag;

@property(strong, nonatomic) AFNetworkingModel *afNetworkingModel;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //日付入力のためのpickerを生成
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(datePickerAction:) forControlEvents:UIControlEventValueChanged];
    self.dateBox.inputView = datePicker;
    self.dateBox.delegate = self;
    self.bookNameBox.delegate = self;
    self.priceBox.delegate = self;
    //pickerに閉じるボタンをつけるためにtoolバーを設置
    UIToolbar *pickerToolBar = [[UIToolbar alloc] init];
    pickerToolBar.barStyle = UIBarStyleDefault;
    pickerToolBar.translucent = YES;
    pickerToolBar.tintColor = nil;
    [pickerToolBar sizeToFit];
    //閉じるボタン生成
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完了" style:UIBarButtonItemStyleDone target:self action:@selector(pickerDoneClicked)];
    UIBarButtonItem *spacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *array = @[spacer1, spacer2, doneButton];
    [pickerToolBar setItems:array];
    self.dateBox.inputAccessoryView = pickerToolBar;
    if (self.flag){
        self.afNetworkingModel = [[AFNetworkingModel alloc] actionName:@"editBook"];
    }else{
        self.afNetworkingModel = [[AFNetworkingModel alloc] actionName:@"addBook"];
    }
    self.afNetworkingModel.addDelegate = self;
    //編集画面の場合は渡ってきたデータをテキストフィールドに表示する
    self.bookNameBox.text = self.name;
    self.priceBox.text = self.price;
    self.dateBox.text = self.date;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * pickerで選んだ際、フォーマットを変更してtextFieldに入れるメソッド
 */
- (void)datePickerAction:(id)sender {
    UIDatePicker *picker = (UIDatePicker *) sender;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:picker.date];

    self.year = components.year;
    self.month = components.month;
    self.day = components.day;

    self.dateBox.text = [NSString stringWithFormat:@"%ld年 %ld月 %ld日", (long) self.year, (long) self.month, (long) self.month];

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/**
 * データをデータベースに保存するボタンアクション
 */
- (IBAction)saveDataButton:(id)sender {
    //AFNetworkingModelを生成
    NSDictionary *param;
    if (self.flag){
        param = @{
                @"id" : self.idStr,
                @"image_url" : @"hoge",
                @"name" : [NSString stringWithFormat:@"%@", self.bookNameBox.text],
                @"price" : self.priceBox.text,
                @"purchase_date" : [NSString stringWithFormat:@"%d-%d-%d", self.year, self.month, self.day]
        };
    }else {
        param = @{
                @"image_url" : @"hoge",
                @"name" : [NSString stringWithFormat:@"%@", self.bookNameBox.text],
                @"price" : self.priceBox.text,
                @"purchase_date" : [NSString stringWithFormat:@"%d-%d-%d", self.year, self.month, self.day]
        };
    }

    [self.afNetworkingModel startAPIConnection:param];

}

- (void)didAddOrUpdateBookData:(NSString *)message {
    NSLog(@"%@",message);
}

- (void)failedUploadData {

}

/**
 * keyboard及びpickerが出ている時別の場所をタップした時の動作
 */
- (IBAction)onSingleTap:(UITapGestureRecognizer *)sender {
    //keyboardやpickerを隠す
    [self.view endEditing:YES];
}


/**
 * textFiledでReTurnボタンを押した時の処理
 */
- (BOOL)textFieldShouldReturn:(UITextField *)targetTextField {
    //keyboardを隠す
    [self.bookNameBox resignFirstResponder];
    [self.priceBox resignFirstResponder];
    return YES;
}

/**
 * pickerの上部に設置した完了ボタンを押した時の動作
 */
- (void)pickerDoneClicked {
    //pickerを閉じる
    [self.dateBox resignFirstResponder];
}

/**
 * 画像を追加するボタンの処理
 */
- (IBAction)imageUploadButton:(id)sender {
    //ImagePickerが使えるかどうかの判定
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //ImagePickerを生成
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePickerController setAllowsEditing:YES];
        [imagePickerController setDelegate:self];
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

/**
 * 画像が選択された時に呼ばれるデリケードメソッド
 * 選ばれた画像をimageViewに登録
 * @param NSDictionary info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    UIImage *image = (UIImage *) info[@"UIImagePickerControllerOriginalImage"];
    if (image) {
        [self.imageView setImage:image];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 選択された画像がキャンセルされた時に呼ばれるデリケードメソッド
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //モーダルビューを取り除く
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)editBookData:(NSString *)name :(NSString *)image :(NSString *)price :(NSString *)date :(NSInteger *)idNum{
    self.idStr = [NSString stringWithFormat:@"%ld",(long)idNum];
    self.name = name;
    self.image = image;
    self.price = price;
    self.date = date;
    self.flag = YES;
}

- (void)addBookData {
    self.flag = NO;
}

@end
