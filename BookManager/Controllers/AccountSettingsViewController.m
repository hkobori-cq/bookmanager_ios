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

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
 * キーボードが出てきたときのデリケードメソッド
 */
- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
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
- (void)succeededUserRegister {
    [self showAlertView:@"成功しました"];
}

/**
 * ユーザー登録が失敗したときのデリケードメソッド
 */
- (void)failedUserRegister {
    [self showAlertView:@"失敗しました"];
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
- (IBAction)didSaveDataButtonTapped:(id)sender {
    if ([self.mailBox.text isEqual:@""]) {
        [self showAlertView:@"メールアドレスを入力してください"];
    } else if ([self.passwordBox.text isEqual:@""]) {
        [self showAlertView:@"パスワードを入力してください"];
    } else if (self.passwordBox.text != self.passwordConfirmBox.text) {
        [self showAlertView:@"パスワードが一致しません"];
    } else {
        NSDictionary *UserDataParam;
        UserDataParam = @{
                @"mail_address" : [NSString stringWithFormat:@"%@",self.mailBox.text],
                @"password" : [NSString stringWithFormat:@"%@",self.passwordBox.text]
        };
        [self.afNetworkingModel startAPIConnection:UserDataParam];
    }
}

/**
 * Alert表示のメソッド
 * @param NSString alertMessage
 */
- (void)showAlertView:(NSString *)alertMessage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([alertMessage isEqual:@"成功しました"]){
            [self tappedAlertOkButton];
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 * API通信が成功したときのAlertViewでOKボタンをクリックしたときのメソッド
 */
- (void)tappedAlertOkButton {
    UITabBarController *topPageViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"topPageViewController"];
    [self presentViewController:topPageViewController animated:YES completion:nil];
}
@end
