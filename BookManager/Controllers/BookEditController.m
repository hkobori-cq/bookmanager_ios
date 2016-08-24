//
//  BookEditController.m
//  BookManager
//
//  Created by 小堀輝 on 2016/08/22.
//  Copyright © 2016年 hikaru kobori. All rights reserved.
//

#import "BookEditController.h"

@interface BookEditController ()
@property (weak, nonatomic) IBOutlet UILabel *rowNumber;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet UITextField *bookNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bookFeeTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;

@end

@implementation BookEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    self.rowNumber.text = [ud valueForKey:@"num"];
    self.bookNameTextField.text = [ud valueForKey:@"num"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
