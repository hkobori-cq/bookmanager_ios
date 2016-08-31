#import "LoginViewController.h"
#import "AFNetworkingModel.h"

@interface LoginViewController () <UITextFieldDelegate, AFNetworkingUserLoginDelegate>
@property(weak, nonatomic) IBOutlet UITextField *mailTextField;
@property(weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property(strong, nonatomic) AFNetworkingModel *afNetworkingModel;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.afNetworkingModel = [[AFNetworkingModel alloc] actionName:@"userLogin"];
    self.afNetworkingModel.userLoginDelegate = self;
    self.mailTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loginButton:(id)sender {
    if ([self.mailTextField.text isEqual:@""]) {
        [self makeAlert:@"メールアドレスを入力してください"];
    } else if ([self.passwordTextField.text isEqual:@""]) {
        [self makeAlert:@"パスワードを入力してください"];
    } else {
        NSDictionary *param;
        param = @{
                @"mail_address" : self.mailTextField.text,
                @"password" : self.passwordTextField.text
        };
        [self.afNetworkingModel startAPIConnection:param];
    }
}

/**
 * キーボードのリターンキーを押したときのデリケードメソッド
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.mailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    return YES;
}

/**
 * ログインが成功したときのデリケードメソッド
 */
- (void)didUserLogin {
    [self makeAlert:@"ログインに成功しました"];
    UITabBarController *topPageViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"topPageViewController"];
    [self presentViewController:topPageViewController animated:YES completion:nil];
}

/**
 * ログインが失敗したときのデリケードメソッド
 */
- (void)failedUserLogin {
    [self makeAlert:@"ログインに失敗しました"];
}

/**
 * ディスプレイを触ったときのメソッド
 */
- (IBAction)onSingleTap:(UITapGestureRecognizer *)sender {
    //キーボードが表示されているときは閉じる
    [self.view endEditing:YES];
}

/**
 * 警告表示のためのメソッド
 * @param NSString alertMessage
 */
- (void)makeAlert:(NSString *)alertMessage {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

@end
