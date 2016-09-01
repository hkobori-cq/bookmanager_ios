#import "AddViewController.h"
#import "AFNetworkingModel.h"

@interface AddViewController () <AFNetworkingAddDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UITextField *bookNameBox;
@property(weak, nonatomic) IBOutlet UITextField *priceBox;
@property(weak, nonatomic) IBOutlet UITextField *dateBox;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property(nonatomic) NSInteger current_year;
@property(nonatomic) NSInteger current_month;
@property(nonatomic) NSInteger current_day;

@property(nonatomic) NSString *received_name;
@property(nonatomic) NSString *received_image;
@property(nonatomic) NSString *received_price;
@property(nonatomic) NSString *received_date;
@property(nonatomic) NSString *received_idStr;

@property(assign, nonatomic) BOOL isEditPage;

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
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完了" style:UIBarButtonItemStyleDone target:self action:@selector(clickedPickerDoneButton)];
    UIBarButtonItem *spacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *array = @[spacer1, spacer2, doneButton];
    [pickerToolBar setItems:array];
    self.dateBox.inputAccessoryView = pickerToolBar;
    //編集画面と追加画面でそれぞれAPI通信の初期化する
    if (self.isEditPage) {
        self.afNetworkingModel = [[AFNetworkingModel alloc] actionName:@"editBook"];
    } else {
        self.afNetworkingModel = [[AFNetworkingModel alloc] actionName:@"addBook"];
    }
    self.afNetworkingModel.addDelegate = self;
    //編集画面の場合は渡ってきたデータをテキストフィールドに表示する
    if (self.isEditPage) {
        self.bookNameBox.text = self.received_name;
        self.priceBox.text = self.received_price;
        self.dateBox.text = [self changeDateFormatFromString:self.received_date];
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
 * キーボードが出てきたときのデリケードメソッド(自動生成)
 */
- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGPoint scrollPoint = CGPointMake(0.0f, keyboardSize.height / 2);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
}

/**
 * キーボードが隠れたときのデリケードメソッド(自動生成)
 */
- (void)keyboardWasHidden:(NSNotification *)notification {
    [self.scrollView setContentOffset:CGPointMake(0.0f, 80.0f) animated:YES];
}

/**
 * pickerで選んだ際、フォーマットを変更してtextFieldに入れるメソッド
 */
- (void)datePickerAction:(id)sender {
    UIDatePicker *picker = (UIDatePicker *) sender;
    [self changeDateFormatFromDate:picker.date];
    self.dateBox.text = [NSString stringWithFormat:@"%ld年%ld月%ld日", (long) self.current_year, (long) self.current_month, (long) self.current_day];
}


/**
 * pickerの日付の型を変更するメソッド
 * @param NSDate date
 */
- (void)changeDateFormatFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *calendar_components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];

    self.current_year = calendar_components.year;
    self.current_month = calendar_components.month;
    self.current_day = calendar_components.day;
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
    NSDateComponents *calendar_components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:changeDate];

    self.current_year = calendar_components.year;
    self.current_month = calendar_components.month;
    self.current_day = calendar_components.day;

    return [NSString stringWithFormat:@"%ld年%ld月%ld日", (long) self.current_year, (long) self.current_month, (long) self.current_day];
}

/**
 * データをデータベースに保存するボタンアクション
 */
- (IBAction)saveDataButton:(id)sender {
    if ([self.bookNameBox.text isEqual:@""]) {
        [self makeAlertView:@"本の名前を入力してください"];
    } else if ([self.priceBox.text isEqual:@""]) {
        [self makeAlertView:@"本の価格を入力してください"];
    } else if ([self.dateBox.text isEqual:@""]) {
        [self makeAlertView:@"購入日を入力してください"];
    } else {
        NSDictionary *BookDataParam;
        if (self.isEditPage) {
            BookDataParam = @{
                    @"id" : self.received_idStr,
                    @"image_url" : @"hoge",
                    @"name" : [NSString stringWithFormat:@"%@", self.bookNameBox.text],
                    @"price" : self.priceBox.text,
                    @"purchase_date" : [NSString stringWithFormat:@"%ld-%ld-%ld", (long) self.current_year, (long) self.current_month, (long) self.current_day]
            };
        } else {
            BookDataParam = @{
                    @"image_url" : @"hoge",
                    @"name" : [NSString stringWithFormat:@"%@", self.bookNameBox.text],
                    @"price" : self.priceBox.text,
                    @"purchase_date" : [NSString stringWithFormat:@"%ld-%ld-%ld", (long) self.current_year, (long) self.current_month, (long) self.current_day]
            };
        }

        [self.afNetworkingModel startAPIConnection:BookDataParam];
    }
}

/**
 * API通信に成功した時のメソッド
 * @param NSString message (Addの時は追加完了しました Editの時は編集完了しました)
 */
- (void)succeededAddOrUpdateBookData:(NSString *)received_message {
    [self makeAlertView:received_message];
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)failedUploadData {
    if (self.isEditPage) {
        [self makeAlertView:@"書籍編集に失敗しました"];
    } else {
        [self makeAlertView:@"書籍追加に失敗しました"];
    }
}

/**
 * 画面をタップしたときの動作
 */
- (IBAction)onSingleTap:(UITapGestureRecognizer *)sender {
    //keyboardやpickerを隠す
    [self.view endEditing:YES];
}


/**
 * textFiledでReturnボタンを押した時の処理(自動生成)
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
- (void)clickedPickerDoneButton {
    //pickerを閉じる
    [self.dateBox resignFirstResponder];
}

/**
 * 画像を追加するボタンの処理
 */
- (IBAction)clickedImageUploadButton:(id)sender {
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
 * 画像が選択された時に呼ばれるデリケードメソッド(自動生成)
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
 * 選択された画像がキャンセルされた時に呼ばれるデリケードメソッド(自動生成)
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
 * @param NSString received_name
 * @param NSString received_image
 * @param NSString received_price
 * @param NSString received_date
 * @param NSInteger received_idNum
 */
- (void)editBookData:(NSString *)received_name :(NSString *)received_image :(NSString *)received_price :(NSString *)received_date :(NSInteger *)received_idNum {
    self.received_idStr = [NSString stringWithFormat:@"%ld", (long) received_idNum];
    self.received_name = received_name;
    self.received_image = received_image;
    self.received_price = received_price;
    self.isEditPage = YES;
    self.received_date = received_date;
}

/**
 * 書籍追加のときのメソッド
 */
- (void)addBookData {
    self.isEditPage = NO;
}

/**
 * 警告表示のメソッド
 * @param NSString alertMessage
 */
- (void)makeAlertView:(NSString *)alertMessage {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

@end
