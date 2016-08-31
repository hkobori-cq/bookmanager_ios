#import "AddViewController.h"
#import "AFNetworkingModel.h"

@interface AddViewController () <AFNetworkingAddDelegate, UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UITextField *bookNameBox;
@property(weak, nonatomic) IBOutlet UITextField *priceBox;
@property(weak, nonatomic) IBOutlet UITextField *dateBox;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property(nonatomic) NSInteger year;
@property(nonatomic) NSInteger month;
@property(nonatomic) NSInteger day;

@property(nonatomic) NSString *name;
@property(nonatomic) NSString *image;
@property(nonatomic) NSString *price;
@property(nonatomic) NSString *date;
@property(nonatomic) NSString *idStr;

@property(assign, nonatomic) BOOL flag;
@property(nonatomic) NSDate *changeDate;

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
    if (self.flag) {
        self.afNetworkingModel = [[AFNetworkingModel alloc] actionName:@"editBook"];
    } else {
        self.afNetworkingModel = [[AFNetworkingModel alloc] actionName:@"addBook"];
    }
    self.afNetworkingModel.addDelegate = self;
    //編集画面の場合は渡ってきたデータをテキストフィールドに表示する
    if (self.flag) {
        self.bookNameBox.text = self.name;
        self.priceBox.text = self.price;
        self.dateBox.text = [self changeDateFormatFromString:self.date];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * キーボードが出てきたときのデリケードメソッド
 */
- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGPoint scrollPoint = CGPointMake(0.0f, keyboardSize.height / 2);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
}

/**
 * キーボードが隠れたときのデリケードメソッド
 */
- (void)keyboardWasHidden:(NSNotification *)notification {
    [self.scrollView setContentOffset:CGPointMake(0.0f, 80.0f) animated:YES];
}

/**
 * pickerで選んだ際、フォーマットを変更してtextFieldに入れるメソッド
 */
- (void)datePickerAction:(id)sender {
    UIDatePicker *picker = (UIDatePicker *) sender;
    self.changeDate = picker.date;
    [self changeDateFormat:self.changeDate];
    self.dateBox.text = [NSString stringWithFormat:@"%ld年 %ld月 %ld日", (long) self.year, (long) self.month, (long) self.date];
}

/**
 * pickerの日付の型を変更するメソッド
 * @param NSDate date
 */
- (void)changeDateFormat:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];

    self.year = components.year;
    self.month = components.month;
    self.day = components.day;
}

/**
 * tableViewから持ってきた(String型)データを変換するメソッド
 * @param NSString date
 */
- (id)changeDateFormatFromString:(NSString *)date {
    NSMutableString *string = [[NSMutableString alloc] initWithString:date];
    [string deleteCharactersInRange:NSMakeRange(0, 4)];
    [string deleteCharactersInRange:NSMakeRange(string.length - 3, 3)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *changeDate = [formatter dateFromString:string];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:flags fromDate:changeDate];

    NSInteger year = components.year;
    NSInteger month = components.month;
    NSInteger day = components.day;

    return [NSString stringWithFormat:@"%ld年%ld月%ld日", (long) year, (long) month, (long) day];
}

/**
 * データをデータベースに保存するボタンアクション
 */
- (IBAction)saveDataButton:(id)sender {
    if ([self.bookNameBox.text isEqual:@""]) {
        [self makeAlert:@"本の名前を入力してください"];
    } else if ([self.priceBox.text isEqual:@""]) {
        [self makeAlert:@"本の価格を入力してください"];
    } else if ([self.dateBox.text isEqual:@""]) {
        [self makeAlert:@"購入日を入力してください"];
    } else {
        NSDictionary *param;
        if (self.flag) {
            param = @{
                    @"id" : self.idStr,
                    @"image_url" : @"hoge",
                    @"name" : [NSString stringWithFormat:@"%@", self.bookNameBox.text],
                    @"price" : self.priceBox.text,
                    @"purchase_date" : [NSString stringWithFormat:@"%d-%d-%d", self.year, self.month, self.day]
            };
        } else {
            param = @{
                    @"image_url" : @"hoge",
                    @"name" : [NSString stringWithFormat:@"%@", self.bookNameBox.text],
                    @"price" : self.priceBox.text,
                    @"purchase_date" : [NSString stringWithFormat:@"%d-%d-%d", self.year, self.month, self.day]
            };
        }

        [self.afNetworkingModel startAPIConnection:param];
    }
}

/**
 * API通信に成功した時のメソッド
 * @param NSString message (Addの時は追加完了しました Editの時は編集完了しました)
 */
- (void)didAddOrUpdateBookData:(NSString *)message {
    [self makeAlert:message];
}

- (void)failedUploadData {
    if (self.flag) {
        [self makeAlert:@"書籍編集に失敗しました"];
    } else {
        [self makeAlert:@"書籍追加に失敗しました"];
    }
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

/**
 * 戻るボタンを押した時のメソッド
 */
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * tableViewからデータを受け取るためのデリケードメソッド
 * @param NSString name
 * @param NSString image
 * @param NSString price
 * @param NSString date
 * @param NSInteger idNum
 */
- (void)editBookData:(NSString *)name :(NSString *)image :(NSString *)price :(NSString *)date :(NSInteger *)idNum {
    self.idStr = [NSString stringWithFormat:@"%ld", (long) idNum];
    self.name = name;
    self.image = image;
    self.price = price;
    self.flag = YES;
    self.date = date;
}

/**
 * 書籍追加のときのメソッド
 */
- (void)addBookData {
    self.flag = NO;
}

/**
 * 警告表示のメソッド
 * @param NSString alertMessage
 */
- (void)makeAlert:(NSString *)alertMessage {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

@end
