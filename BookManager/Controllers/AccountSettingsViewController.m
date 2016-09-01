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
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.mailBox.delegate = self;
    self.passwordBox.delegate = self;
    self.passwordConfirmBox.delegate = self;
    self.afNetworkingModel = [[AFNetworkingModel alloc] actionName:@"userRegister"];
    self.afNetworkingModel.userRegisterDelegate = self;
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
 * 画面をシングルタップしたときの動作
 */
- (IBAction)onSingleTap:(UITapGestureRecognizer *)sender {
    //keyboardが出ているときは非表示にする
    [self.view endEditing:YES];
}

/**
 * キーボードのリターンキーを押したときのデリケードメソッド(自動生成)
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.mailBox resignFirstResponder];
    [self.passwordBox resignFirstResponder];
    [self.passwordConfirmBox resignFirstResponder];
    return YES;
}

/**
 * キーボードが出てきたときのデリケードメソッド(自動生成)
 */
- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGPoint scrollPoint = CGPointMake(0.0f, keyboardSize.height / 3);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
}

/**
 * キーボードが隠れたときのデリケードメソッド(自動生成)
 */
- (void)keyboardWasHidden:(NSNotification *)notification {
    [self.scrollView setContentOffset:CGPointMake(0.0f, 80.0f) animated:YES];
}

/**
 * ユーザー登録が成功したときのデリケードメソッド
 */
- (void)succeededUserRegister {
    [self makeAlertView:@"成功しました"];
    UITabBarController *topPageViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"topPageViewController"];
    [self presentViewController:topPageViewController animated:YES completion:nil];
}

/**
 * ユーザー登録が失敗したときのデリケードメソッド
 */
- (void)failedUserRegister {
    [self makeAlertView:@"失敗しました"];
}

/**
 * SettingsViewControllerに戻るボタン
 */
- (IBAction)returnButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * データベースにユーザー情報を保存
 */
- (IBAction)saveDataButton:(id)sender {
    if ([self.mailBox.text isEqual:@""]) {
        [self makeAlertView:@"メールアドレスを入力してください"];
    } else if ([self.passwordBox.text isEqual:@""]) {
        [self makeAlertView:@"パスワードを入力してください"];
    } else if (self.passwordBox.text != self.passwordConfirmBox.text) {
        [self makeAlertView:@"パスワードが一致しません"];
    } else {
        NSDictionary *UserDataParam;
        UserDataParam = @{
                @"mail_address" : self.mailBox.text,
                @"password" : self.passwordBox.text
        };
        [self.afNetworkingModel startAPIConnection:UserDataParam];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/**
 * Alert表示のメソッド
 * @param NSString alertMessage
 */
- (void)makeAlertView:(NSString *)alertMessage {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}
@end
