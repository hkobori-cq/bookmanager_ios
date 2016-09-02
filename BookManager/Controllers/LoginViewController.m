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
        [self showAlertView:@"メールアドレスを入力してください"];
    } else if ([self.passwordTextField.text isEqual:@""]) {
        [self showAlertView:@"パスワードを入力してください"];
    } else {
        NSDictionary *LoginDataParam;
        LoginDataParam = @{
                @"mail_address" : [NSString stringWithFormat:@"%@",self.mailTextField.text],
                @"password" : [NSString stringWithFormat:@"%@",self.passwordTextField.text]
        };
        [self.afNetworkingModel startAPIConnection:LoginDataParam];
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
- (void)succeededUserLogin {
    [self showAlertView:@"ログインに成功しました"];
}

/**
 * ログインが失敗したときのデリケードメソッド
 */
- (void)failedUserLogin {
    [self showAlertView:@"ログインに失敗しました"];
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
- (void)showAlertView:(NSString *)alertMessage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([alertMessage isEqual:@"ログインに成功しました"]){
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
