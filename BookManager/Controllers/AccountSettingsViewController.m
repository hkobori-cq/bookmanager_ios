#import "AccountSettingsViewController.h"
#import "AFNetworkingModel.h"

@interface AccountSettingsViewController () <UITextFieldDelegate,AFNetworkingUserRegisterDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mailBox;
@property (weak, nonatomic) IBOutlet UITextField *passwordBox;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmBox;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) AFNetworkingModel *afnetowkingModel;
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
    self.afnetowkingModel = [[AFNetworkingModel alloc] actionName:@"userRegister"];
    self.afnetowkingModel.userRegisterDelegate = self;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.mailBox resignFirstResponder];
    [self.passwordBox resignFirstResponder];
    [self.passwordConfirmBox resignFirstResponder];
    return YES;
}

- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info  = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGPoint scrollPoint = CGPointMake(0.0f, keyboardSize.height/3);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
}

- (void)keyboardWasHidden:(NSNotification *)notification {
    [self.scrollView setContentOffset:CGPointMake(0.0f, 80.0f) animated:YES];
}

- (void)didUserRegister {
    NSLog(@"成功している");
}

- (void)failedUserRegister {
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
 * SettingsViewControllerに戻るボタン
 */
- (IBAction)returnButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * データベースに保存
 */
- (IBAction)saveButton:(id)sender {
    NSDictionary *param;
    param = @{
            @"mail_address" : self.mailBox,
            @"password" : self.passwordBox
    };
    [self.afnetowkingModel startAPIConnection:param];
}

@end
