#import "AddViewController.h"
#import "AFNetworkingModel.h"
#import "Util.h"

@interface AddViewController () <AFNetworkingAddDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property(weak, nonatomic) IBOutlet UITextField *bookNameTextField;
@property(weak, nonatomic) IBOutlet UITextField *bookPriceTextField;
@property(weak, nonatomic) IBOutlet UITextField *PurchaseDateTextFiled;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic) NSDateComponents *calendarComponents;

@property(nonatomic) NSInteger currentYear;
@property(nonatomic) NSInteger currentMonth;
@property(nonatomic) NSInteger currentDay;


@property(nonatomic) NSString *receivedName;
@property(nonatomic) NSString *receivedImage;
@property(nonatomic) NSString *receivedPrice;
@property(nonatomic) NSString *receivedDate;
@property(nonatomic) NSString *receivedIdStr;

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
    self.PurchaseDateTextFiled.inputView = datePicker;
    self.PurchaseDateTextFiled.delegate = self;
    self.bookNameTextField.delegate = self;
    self.bookPriceTextField.delegate = self;
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
    self.PurchaseDateTextFiled.inputAccessoryView = pickerToolBar;
    //編集画面と追加画面でそれぞれAPI通信の初期化する
    if (self.isEditPage) {
        self.afNetworkingModel = [[AFNetworkingModel alloc] actionName:@"editBook"];
    } else {
        self.afNetworkingModel = [[AFNetworkingModel alloc] actionName:@"addBook"];
    }
    self.afNetworkingModel.addDelegate = self;
    //編集画面の場合は渡ってきたデータをテキストフィールドに表示する
    if (self.isEditPage) {
        UIImageView *receivedImage = [[UIImageView alloc] init];
        receivedImage.image = [UIImage imageNamed:self.receivedImage];
        if (receivedImage.image.size.height == 0) {
            UIImage *sampleImage = [UIImage imageNamed:@"sample.jpg"];
            UIImageView *sampleImageView = [[UIImageView alloc] initWithImage:sampleImage];
            sampleImageView.frame = CGRectMake(0, 0, 100, 100);
            [self.bookImageView addSubview:sampleImageView];
        } else {
            [self.bookImageView addSubview:receivedImage];
        }
        self.navigationItem.title = @"編集画面";
        self.bookNameTextField.text = self.receivedName;
        self.bookPriceTextField.text = self.receivedPrice;
        //Utilクラスのメソッドを使い、String型のdateを変換、表示する
        NSDate *date = [Util fromStringToDate:self.receivedDate];
        self.calendarComponents = [Util fromDateToDateComponents:date];
        [self setCurrentDate:self.calendarComponents];
        self.PurchaseDateTextFiled.text = [NSString stringWithFormat:@"%ld年%ld月%ld日", (long) self.currentYear, (long) self.currentMonth, (long) self.currentDay];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    CGSize keyboardSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
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
    self.calendarComponents = [Util fromDateToDateComponents:picker.date];
    [self setCurrentDate:self.calendarComponents];
    self.PurchaseDateTextFiled.text = [NSString stringWithFormat:@"%ld年%ld月%ld日", (long) self.currentYear, (long) self.currentMonth, (long) self.currentDay];
}


/**
 * 日付をセットするメソッド
 * @param NSDateComponents dateComponents
 */
- (void)setCurrentDate:(NSDateComponents *)dateComponents {
    self.currentYear = dateComponents.year;
    self.currentMonth = dateComponents.month;
    self.currentDay = dateComponents.day;
}


/**
 * データをデータベースに保存するボタンアクション
 */
- (IBAction)saveDataButton:(id)sender {
    if ([self.bookNameTextField.text isEqual:@""]) {
        [self makeAlertView:@"本の名前を入力してください"];
    } else if ([self.bookPriceTextField.text isEqual:@""]) {
        [self makeAlertView:@"本の価格を入力してください"];
    } else if ([self.PurchaseDateTextFiled.text isEqual:@""]) {
        [self makeAlertView:@"購入日を入力してください"];
    } else {
        NSDictionary *BookDataParam;
        if (self.isEditPage) {
            BookDataParam = @{
                    @"id" : self.receivedIdStr,
                    @"image_url" : @"hoge",
                    @"name" : [NSString stringWithFormat:@"%@", self.bookNameTextField.text],
                    @"price" : self.bookPriceTextField.text,
                    @"purchase_date" : [NSString stringWithFormat:@"%ld-%ld-%ld", (long) self.currentYear, (long) self.currentMonth, (long) self.currentDay]
            };
        } else {
            BookDataParam = @{
                    @"image_url" : @"hoge",
                    @"name" : [NSString stringWithFormat:@"%@", self.bookNameTextField.text],
                    @"price" : self.bookPriceTextField.text,
                    @"purchase_date" : [NSString stringWithFormat:@"%ld-%ld-%ld", (long) self.currentYear, (long) self.currentMonth, (long) self.currentDay]
            };
        }

        [self.afNetworkingModel startAPIConnection:BookDataParam];
    }
}

/**
 * API通信に成功した時のメソッド
 * @param NSString message (Addの時は追加完了しました Editの時は編集完了しました)
 */
- (void)succeededAddOrUpdateBookData:(NSString *)receivedMessage {
    [self makeAlertView:receivedMessage];
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
 * textFiledでReturnボタンを押した時の処理
 */
- (BOOL)textFieldShouldReturn:(UITextField *)targetTextField {
    //keyboardを隠す
    [self.bookNameTextField resignFirstResponder];
    [self.bookPriceTextField resignFirstResponder];
    return YES;
}

/**
 * pickerの上部に設置した完了ボタンを押した時の動作
 */
- (void)clickedPickerDoneButton {
    //pickerを閉じる
    [self.PurchaseDateTextFiled resignFirstResponder];
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
 * 画像が選択された時に呼ばれるデリケードメソッド
 * 選ばれた画像をimageViewに登録
 * @param NSDictionary info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    UIImage *image = (UIImage *) info[@"UIImagePickerControllerOriginalImage"];
    if (image) {
        [self.bookImageView setImage:image];
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
 * @param NSString receivedName
 * @param NSString receivedImage
 * @param NSString receivedPrice
 * @param NSString receivedDate
 * @param NSInteger received_idNum
 */
- (void)receiveEditBookData:(NSString *)receivedName :(NSString *)receivedImage :(NSString *)receivedPrice :(NSString *)receivedDate :(NSInteger *)receivedIdNum {
    self.receivedIdStr = [NSString stringWithFormat:@"%ld", (long) receivedIdNum];
    self.receivedName = receivedName;
    self.receivedImage = receivedImage;
    self.receivedPrice = receivedPrice;
    self.isEditPage = YES;
    self.receivedDate = receivedDate;
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
