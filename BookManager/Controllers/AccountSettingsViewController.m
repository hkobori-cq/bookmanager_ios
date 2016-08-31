#import "AccountSettingsViewController.h"
#import "AFNetworkingModel.h"

@interface AccountSettingsViewController () <UITextFieldDelegate, AFNetworkingUserRegisterDelegate>
@property(weak, nonatomic) IBOutlet UITextField *mailBox;
@property(weak, nonatomic) IBOutlet UITextField *passwordBox;
@property(weak, nonatomic) IBOutlet UITextField *passwordConfirmBox;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(strong, nonatomic) AFNetworkingModel *afNetworkingModel;
@end

@implementation AccountSettingsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.mailBox.delegate = self;
    self.passwordBox.delegate = self;
    self.passwordConfirmBox.delegate = self;
    self.afNetworkingModel = [[AFNetworkingModel alloc] actionName:@"userRegister"];
    self.afNetworkingModel.userRegisterDelegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * keyboardが出ているとき別の場所をタップしたときの動作
 */
- (IBAction)onSingleTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

/**
 * キーボードのリターンキーを押したときのデリケードメソッド
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.mailBox resignFirstResponder];
    [self.passwordBox resignFirstResponder];
    [self.passwordConfirmBox resignFirstResponder];
    return YES;
}

/**
 * キーボードが出てきたときのデリケードメソッド
 */
- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGPoint scrollPoint = CGPointMake(0.0f, keyboardSize.height / 3);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
}

/**
 * キーボードが隠れたときのデリケードメソッド
 */
- (void)keyboardWasHidden:(NSNotification *)notification {
    [self.scrollView setContentOffset:CGPointMake(0.0f, 80.0f) animated:YES];
}

/**
 * ユーザー登録が成功したときのデリケードメソッド
 */
- (void)didUserRegister {
    [self makeAlert:@"成功しました"];
    UITabBarController *topPageViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"topPageViewController"];
    [self presentViewController:topPageViewController animated:YES completion:nil];
}

/**
 * ユーザー登録が失敗したときのデリケードメソッド
 */
- (void)failedUserRegister {
    [self makeAlert:@"失敗しました"];
}

/**
 * SettingsViewControllerに戻るボタン
 */
- (IBAction)returnButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * データベースに保存
 */
- (IBAction)saveButton:(id)sender {
    if ([self.mailBox.text isEqual:@""]) {
        [self makeAlert:@"メールアドレスを入力してください"];
    } else if ([self.passwordBox.text isEqual:@""]) {
        [self makeAlert:@"パスワードを入力してください"];
    } else if (self.passwordBox.text != self.passwordConfirmBox.text) {
        [self makeAlert:@"パスワードが一致しません"];
    } else {
        NSDictionary *param;
        param = @{
                @"mail_address" : self.mailBox.text,
                @"password" : self.passwordBox.text
        };
        [self.afNetworkingModel startAPIConnection:param];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/**
 * Alert表示のメソッド
 * @param NSString alertMessage
 */
- (void)makeAlert:(NSString *)alertMessage {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}
@end
