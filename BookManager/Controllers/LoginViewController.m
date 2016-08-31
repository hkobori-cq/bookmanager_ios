//
//  LoginViewController.m
//  BookManager
//
//  Created by 小堀輝 on 2016/08/30.
//  Copyright © 2016年 hikaru kobori. All rights reserved.
//

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
    // Do any additional setup after loading the view.
    self.afNetworkingModel = [[AFNetworkingModel alloc] actionName:@"userLogin"];
    self.afNetworkingModel.userLoginDelegate = self;
    self.mailTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.mailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    return YES;
}

- (void)didUserLogin {
    [self makeAlert:@"ログインに成功しました"];
    UITabBarController *topPageViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"topPageViewController"];
    [self presentViewController:topPageViewController animated:YES completion:nil];
}

- (void)failedUserLogin {
    [self makeAlert:@"ログインに失敗しました"];
}

- (IBAction)onSingleTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)makeAlert:(NSString *)alertMessage {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
