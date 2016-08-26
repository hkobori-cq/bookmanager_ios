//
//  AddViewController.m
//  BookManager
//
//  Created by 小堀輝 on 2016/08/23.
//  Copyright © 2016年 hikaru kobori. All rights reserved.
//

#import "AddViewController.h"
#import "AFNetworkingModel.h"

@interface AddViewController ()<AFnetworkingDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *bookNameBox;
@property (weak, nonatomic) IBOutlet UITextField *priceBox;
@property (weak, nonatomic) IBOutlet UITextField *dateBox;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    self.dateBox.inputView = datePicker;
    self.dateBox.delegate = self;
    self.bookNameBox.delegate = self;
    self.priceBox.delegate = self;
    UIToolbar *pickerToolBar = [[UIToolbar alloc] init];
    pickerToolBar.barStyle = UIBarStyleDefault;
    pickerToolBar.translucent = YES;
    pickerToolBar.tintColor = nil;
    [pickerToolBar sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完了" style:UIBarButtonItemStyleDone target:self action:@selector(pickerDoneClicked)];
    UIBarButtonItem *spacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *array = @[spacer1,spacer2,doneButton];
    [pickerToolBar setItems:array];
    self.dateBox.inputAccessoryView = pickerToolBar;
}

- (void)viewWillAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSuccess:(NSArray *)response {
    NSLog(@"success");
}

- (void)didFailure:(NSError *)error {
    NSLog(@"error");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)addImageButton:(id)sender {
}
- (IBAction)saveDataButton:(id)sender {
    AFNetworkingModel *afNetworkingModel = [[AFNetworkingModel alloc] init];
    NSString *url = @"http://app.com/book/regist";
    NSDictionary *param;
    param = @{
            @"image_url":@"hoge",
            @"name":self.bookNameBox.text,
            @"price":self.priceBox.text,
            @"purchase_date":self.dateBox.text
    };
    NSLog(@"%@",param);
    [afNetworkingModel makeAFNetworkingRequest:url:param];
    afNetworkingModel.delegate = self;
}
- (IBAction)onSingleTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)updateTextField:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd";
    UIDatePicker *picker = (UIDatePicker *)sender;
    self.dateBox.text = [dateFormatter stringFromDate:picker.date];

}

- (BOOL)textFieldShouldReturn:(UITextField *)targetTextField {
    [self.bookNameBox resignFirstResponder];
    [self.priceBox resignFirstResponder];
    return YES;
}

- (void)pickerDoneClicked {
    [self.dateBox resignFirstResponder];
}
- (IBAction)imageUploadButton:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePickerController setAllowsEditing:YES];
        [imagePickerController setDelegate:self];
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    if (image){
        [self.imageView setImage:image];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
