//
//  WProfileViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-19.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "WProfileViewController.h"

@interface WProfileViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic ,assign) BOOL isBanner;

@property(nonatomic ,retain) NSArray *genderArray;

@property(nonatomic ,retain) UIPickerView *pickerView;


@property(nonatomic ,assign) BOOL isProfileUploading;

@property(nonatomic ,assign) BOOL isBannerUploading;

@end

@implementation WProfileViewController


#pragma mark - Private Methods


- (void)uploadProfileImage:(UIImage*)image {
    
    __weak typeof(self) weakSelf = self;
    
    
    
        NSString *fileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".png"];
       NSString *thumbFileName = [NSString stringWithFormat:@"%@%@",@"thumb_",fileName];
    
        UIImage *thumbImage = [UIImage resizeImage:image toResolution:80];
        NSData * imageData = [UIImage getImageCompressedData:thumbImage];
    //UIImagePNGRepresentation(thumbImage);
        
        NSString  *filePath = [RUUtility getFileURLPathforFileName:thumbFileName directoryName:@"WhizWish" withData:imageData];
        
        [[WZServiceParser sharedParser] processUploadFileAWSWithfilePath:filePath fileName:thumbFileName success:^(NSString *fileName) {
            
            NSLog(@"thumb uploaded");
            weakSelf.profileThumbnailURL = [NSString stringWithFormat:@"%@%@%@%@",k_AMAZON_S3_SERVER_URL,k_BUCKET_NAME,@"/",thumbFileName];
            
            
            weakSelf.profileImageURL = [NSString stringWithFormat:@"%@%@%@%@",k_AMAZON_S3_SERVER_URL,k_BUCKET_NAME,@"/",fileName];

            
            weakSelf.isProfileUploading = NO;
            [weakSelf processPostProfile];
            NSString *fName = thumbFileName;
            NSData * imageData = UIImagePNGRepresentation(image);
            
            NSString  *filePath = [RUUtility getFileURLPathforFileName:fName directoryName:@"WhizWish" withData:imageData];
            
            [[WZServiceParser sharedParser] processUploadFileAWSWithfilePath:filePath fileName:fileName success:^(NSString *fileName) {
                
                NSLog(@"File standard uploaded at url %@",fileName);
                
            }];
       
        }];
        

}


- (void)processPostProfile {
    
    if (!self.isProfileUploading && !self.isBannerUploading) {
     
                __weak typeof(self) weakSelf = self;
        
                [[WZServiceParser sharedParser] processProfileWithName:self.stringFullName bio:self.stringBio phoneNumber:self.stringPhone gender:self.stringGender profileImageURL:self.profileImageURL profileThumbnailURL:self.profileThumbnailURL bannerImageURL:self.bannerImageURL success:^(NSString *success) {
        
                    if ([success boolValue]) {
        
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                        if (weakSelf.isFromRegistration) {
        
                                WZHomeViewController *homeViewController = [[UIStoryboard getHomeStoryBoard] instantiateViewControllerWithIdentifier:K_SB_HOME_VIEW_CONTROLLER];
        
                                [RUUtility setMainRootController:homeViewController];
        
                        }
                        else {
        
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }
        
                    }
                } failure:^(NSError *error) {
                    
                    NSLog(@"Failure");
                }];
    }
    
    
    
}
- (void)uploadBannerImage:(UIImage*)image {
    
    __weak typeof(self) weakSelf = self;
    
    
    NSString *standardFileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".png"];
   
    NSData * imageData = [UIImage getImageCompressedData:image]; //UIImagePNGRepresentation(image);
        
        NSString  *filePath = [RUUtility getFileURLPathforFileName:standardFileName directoryName:@"WhizWish"withData:imageData];
    
        [[WZServiceParser sharedParser] processUploadFileAWSWithfilePath:filePath fileName:standardFileName success:^(NSString *fileName) {
            
            NSLog(@"File standard uploaded at url %@",fileName);
            
            weakSelf.isBannerUploading = NO;
            
            weakSelf.bannerImageURL =   [NSString stringWithFormat:@"%@%@%@%@",k_AMAZON_S3_SERVER_URL,k_BUCKET_NAME,@"/",standardFileName];
            
            
            [weakSelf processPostProfile];
            
        
        
    }];
    
    
}

- (UITextField*)getCellTextFieldForIndex:(NSInteger)index inSection:(NSInteger)section {
    
    WEditProfileTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:section]];
    return cell.textField;

}
- (void)donePressed:(id)sender {
    
    if (self.stringFullName.length == 0) {
        
        [OLGhostAlertView showAlertAtTopWithTitle:@"Message" message:@"Please enter your full name"];
    }
   
    else if (self.stringPhone.length == 0) {
        
        [OLGhostAlertView showAlertAtTopWithTitle:@"Message" message:@"Please enter phone number"];
        
    }
    
    else {
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //First upload images
        
        if (!self.isProfileUploading && !self.isBannerUploading) {
            
            [self processPostProfile];
        }
        
        else {
        
            if (self.isProfileUploading) {
            
            [self uploadProfileImage:self.profileImg];
            
        }
        
        if (self.isBannerUploading) {
            
            [self uploadBannerImage:self.bannerImg];
            
        }
        
        }
        

    }
}

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Profile Setup"];
    
    self.navigationItem.rightBarButtonItem = [RUUtility getBarButtonWithTitle:@"Done" forViewController:self selector:@selector(donePressed:)];
    
    self.genderArray = [[NSArray alloc] initWithObjects:@"Male",@"Female", nil];
    [self didTappedView:self.tableView];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 216, 320, 216)];
    
    self.pickerView.delegate = self;
   
    [self.profileImage setRoundCornersAsCircle];
    
    self.profileImage.image = self.profileImg;
    
    // Do any additional setup after loading the view.
    
   }

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WEditProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Edit_Profile"];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.textField.placeholder = @"Name";
            cell.imageView.image = [UIImage imageNamed:@"Image_Profile_Icon"];
            cell.textField.text = self.stringFullName;
            //self.stringFullName = cell.textField.text;
            

        }
        else if (indexPath.row == 1 ) {
            
            cell.textField.placeholder = @"Bio";
            cell.imageView.image = [UIImage imageNamed:@"Image_Bio"];
            if ([NSString isStringNull:self.stringBio]) {
                
                cell.textField.text = @"";
            }
            else {
                cell.textField.text = self.stringBio;
            }
            //self.stringBio = cell.textField.text;


        }
    }
    else {
     
            if (indexPath.row == 0 ) {
            
            cell.textField.placeholder = @"Phone";
            
            cell.imageView.image = [UIImage imageNamed:@"Image_Phone"];
            
            cell.textField.text = self.stringPhone;
            
            cell.textField.keyboardType = UIKeyboardTypePhonePad;

            
        }
        
        else if (indexPath.row == 1 ) {
            
            cell.textField.placeholder = @"Gender";
            
            cell.imageView.image = [UIImage imageNamed:@"Image_Gender"];
            
            cell.textField.inputView = self.pickerView;
            
            cell.textField.text = self.stringGender;;

            
        }

    }
    
    [cell.textField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }
    else {
    return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return  @"";
    }
    else {
        return @"Syed;";
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,0,tableView.bounds.size.width,25)];
    sectionLabel.backgroundColor = [UIColor clearColor];
    //  sectionLabel.shadowColor = [UIColor blackColor];
    sectionLabel.shadowOffset = CGSizeMake(0,2);
    sectionLabel.textColor = [UIColor blackColor]; //here you can change the text color of header.
    //  sectionLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSizeForHeaders];
    //  sectionLabel.font = [UIFont boldSystemFontOfSize:12];
    
    if (section == 0) {
        sectionLabel.text =  @"";
    }
    else {
        sectionLabel.text = @"Private Information";
        
    }
    [headerView addSubview:sectionLabel];
    return headerView;
}

#pragma mark - Textfield Delegate Methods

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.genderArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.genderArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    [self getCellTextFieldForIndex:1 inSection:1].text = self.genderArray[row];
    
    self.stringGender = self.genderArray[row];
   
    [[self getCellTextFieldForIndex:1 inSection:1] resignFirstResponder];
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    self.pickerView.hidden = NO;

    return NO;
}




#pragma mark - Public Methods

- (void)textFieldDidChange:(id)sender {
    
    UITextField *textField = (UITextField*)sender;
    
    
  if ([textField.placeholder isEqualToString:@"Name"]) {
            
            self.stringFullName = textField.text;
            
        }
  else  if ([textField.placeholder isEqualToString:@"Bio"]) {
        
        self.stringBio = textField.text;
        
    }
   
  else if ([textField.placeholder isEqualToString:@"Phone"]) {
        
        self.stringPhone = textField.text;
        
    }
    
   else if ([textField.placeholder isEqualToString:@"Gender"]) {
        
        self.stringGender = textField.text;
        
    }
    
}

- (void)bannerPressed:(id)sender {
    
    self.isBanner = YES;
    __weak typeof(self) weakSelf = self;
    
    __block UIImagePickerController *pickerController = nil;
    
    [RUUtility openMediaActionSheetFor:self cameraOption:^{
        
        pickerController = [RUUtility getImagePickerFor:KMediaCamera];
        
        pickerController.delegate = weakSelf;
        
        [weakSelf presentViewController:pickerController animated:YES completion:nil];
        
    } libraryOption:^{
        
        pickerController = [RUUtility getImagePickerFor:KMediaLibrary];
        
        pickerController.delegate = weakSelf;
        
        [weakSelf presentViewController:pickerController animated:YES completion:nil];
        
    }];
    
    
}

#pragma mark UIImagePickerView Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
   image =  [image fixOrientation];
    // AND no doing some other kind of assignment
    
    if (self.isBanner) {
        
        self.bannerImage.image = image;
        
        self.bannerImg = image;
        
        self.isBannerUploading = YES;
    }
    else {

        self.profileImage.image = image;
        
        self.profileImg = image;
        
        self.isProfileUploading = YES;
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];


}

- (void)profilePressed:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    
    __block UIImagePickerController *pickerController = nil;
    
    [RUUtility openMediaActionSheetFor:self cameraOption:^{
        
        pickerController = [RUUtility getImagePickerFor:KMediaCamera];
        
        pickerController.delegate = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{

        [weakSelf presentViewController:pickerController animated:YES completion:nil];
        });
        
    } libraryOption:^{
        
        pickerController = [RUUtility getImagePickerFor:KMediaLibrary];
        
        pickerController.delegate = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{

        [weakSelf presentViewController:pickerController animated:YES completion:nil];
        
        });
    }];
    
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

