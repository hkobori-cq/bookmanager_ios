#import "BookEditController.h"

@interface BookEditController ()
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UIButton *addImageButton;
@property(weak, nonatomic) IBOutlet UITextField *bookNameTextField;
@property(weak, nonatomic) IBOutlet UITextField *bookFeeTextField;
@property(weak, nonatomic) IBOutlet UITextField *dateTextField;

@end

@implementation BookEditController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 画像を取り替えるのためのボタンアクション
 */
- (IBAction)addImageButton:(id)sender {
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
