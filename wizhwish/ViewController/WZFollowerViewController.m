//
//  WFollowerViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-03.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

@interface WZFollowerViewController ()

@property(nonatomic ,assign) BOOL isEdit;

@property(nonatomic ,assign) BOOL isGroup;

@property(nonatomic ,retain) NSMutableArray *checkedArray;

@property(nonatomic ,retain) NSMutableArray *array;

@end

@implementation WZFollowerViewController

#pragma mark Private Methods

- (void)showSearBarWithColor:(UIColor*)color {
   
    JKSearchBar *searchBarCode = [[JKSearchBar alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 35)];
    //   searchBarCode.inputView = picker;
    searchBarCode.iconAlign = JKSearchBarIconAlignCenter;
    searchBarCode.placeholder = @"Search";
    searchBarCode.placeholderColor = [UIColor darkGrayColor];
    searchBarCode.layer.cornerRadius = searchBarCode.frame.size.height/2;
    searchBarCode.backgroundColor = color;
    searchBarCode._textField.borderStyle = UITextBorderStyleNone;
    
    searchBarCode._textField.backgroundColor = [UIColor getLightGrayColor];
    //searchBarCode.inputAccessoryView =view;
    //searchBarCode.inputView = picker;
   // [searchBarCode.cancelButton setTitle:@"X" forState:UIControlStateNormal];
    self.tableView.tableHeaderView = searchBarCode;
    //[self.view addSubview:searchBarCode];

}

- (void)updateUIforGroup:(WZProfileTableViewCell*)cell {
   
    UIButton *button = cell.buttonFollow;
    
    [button setTitle:@"Chat" forState:UIControlStateNormal];
    
}
- (void)checkPressed:(id)sender {
    
    UIButton *buttonCheckbox = (UIButton*)sender;
    
    
    if ([self.checkedArray containsObject:[NSNumber numberWithInteger:buttonCheckbox.tag]]) {
        
        buttonCheckbox.selected = NO;
        [self.checkedArray removeObject:[NSNumber numberWithInteger:buttonCheckbox.tag]];
        
    }
    else {
        
        buttonCheckbox.selected = YES;
        
        [self.checkedArray addObject:[NSNumber numberWithInteger:buttonCheckbox.tag]];
    }
}
- (void)resetViews {
    self.buttonCreate.hidden = YES;
    // self.navigationItem.rightBarButtonItem = nil;
    self.viewAddGroup.hidden = YES;
    self.viewCreateList.hidden = NO;
    self.isEdit = NO;
    [self.tableView reloadData];
}

- (void)setTextToButton:(UIButton*)button withTitle:(NSString*)title {
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
   //  UIImage *image = [UIImage imageNamed:@"Image_Follow_Bg"];
    //[button setBackgroundImage:image forState:UIControlStateNormal];
    
    
}

- (void)backButtonPressed {
    
    if (self.isEdit&&self.profileType != kWProfileGroup) {
        
        [self resetViews];
     
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark Life Cycle Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self =  [super initWithCoder:aDecoder];
    if (self) {
        
        self.checkedArray = [[NSMutableArray alloc] init];
        self.array = [[NSMutableArray alloc] init];
    }
    
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self showSearBarWithColor:[UIColor getLightGrayColor]];

    
    [self showNavigationBar:YES];
    
    self.buttonCreate.hidden = YES;
//NSLog(@"profile type %d",self.profileType);
    
    
  
    
    if (self.profileType == kWProfileFollowing) {
        
        [self.navigationItem setTitle:@"Following"];
        
        
        
    }
    
    else if(self.profileType == KWProfileFollower) {
        
        [self.navigationItem setTitle:@"Followers"];
        
        [[WZServiceParser sharedParser] processGetFollowerWithLimit:self.array.count success:^(NSDictionary *dict) {
            
            self.array = [dict valueForKey:@"data"];
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
        }];
    }
    else if(self.profileType == kWProfileAlerts|| self.profileType == kWProfileGifts) {
        
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        
        
        if (self.profileType == kWProfileGifts) {
            
            [self.navigationItem setTitle:@"Gifts"];
        }
        else {
        
            [self.navigationItem setTitle:@"Alerts"];
        }
        
        
        [self.viewCreateList setHidden:YES];
        
        [self.viewAddGroup setHidden:YES];
        
        self.tableViewTopConstraint.constant = -60;
      
    }
    else if(self.profileType == kWProfileGroup) {

        
        [self.navigationItem setTitle:@"Chat"];
        [self.texFieldName setPlaceholder:@"Enter Group Name"];
        self.isEdit = YES;
        self.isGroup = YES;
        [self createListPressed:self];

    }
    
   // self.tableView.estimatedRowHeight = 85;
 //   self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [RUUtility setBackButtonForController:self withSelector:@selector(backButtonPressed)];
    
    if (self.profileType == kWProfileGroup) {
      
        [self.texFieldName setTextFieldPlaceHolderColor:[UIColor navigationBarColor]];

    } else {
    [self.texFieldName setTextFieldPlaceHolderColor:[UIColor blackColor]];
    
    }
    [self didTappedView:self.view];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextfield Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField endEditing:YES];
    return YES;
}


#pragma mark Private Methods

- (void)createPressed {
    
    [self.texFieldName endEditing:YES];
    if (self.profileType == kWProfileGroup) {
    
        [self.viewAddGroup setHidden:YES];
        self.tableViewTopConstraint.constant = -50;
        self.isGroup = NO;
        self.buttonCreate.hidden = YES;
        //self.navigationItem.rightBarButtonItem = nil;

        [self.tableView reloadData];
        

    }
    else {
    
    [self resetViews];
   
    }
}

#pragma Mark TableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.profileType == kWProfileGroup) {
        
        return 80;
    }
    else if (self.profileType == kWProfileGifts || self.profileType == kWProfileAlerts) {
        
        return 85;
    }
    else {
        
        return  85;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WZProfileTableViewCell *profileCell = [tableView dequeueReusableCellWithIdentifier:K_FOLLOWER_CELL];
    
    
    if (self.profileType == kWProfileFollowing || self.profileType == KWProfileFollower) {
        
        NSDictionary *postDict = [self.array objectAtIndex:indexPath.row];

        
        NSString *fullName = [postDict objectForKey:@"userDisplayName"];
        
        NSString *urlPath = [postDict objectForKey:@"userProfileImage"];
        profileCell.labelUserName.text = fullName;
        
        profileCell.labelName.hidden = YES;
        
        if (![NSString isStringNull:urlPath]) {
      
            [profileCell.imageViewProfile setImageWithURL:[NSURL URLWithString:urlPath]];
        }
        [profileCell.labelUserName setTextColor:[UIColor blackColor]];
        
        [profileCell.imageViewPost setHidden:YES];
        
        profileCell.buttonCheckbox.selected = NO;
        
        profileCell.buttonCheckbox.tag = indexPath.row;
        
        if ([self.checkedArray containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
            
            profileCell.buttonCheckbox.selected = YES;
        }
        else {
            profileCell.buttonCheckbox.selected = NO;
        }
        
        if (indexPath.row == 3 && self.profileType == KWProfileFollower) {
            
            
            [self setTextToButton:profileCell.buttonFollow withTitle:@"Follow"];
            
        }
        if (self.isEdit) {
            
            [profileCell.buttonFollow fadeOutWithCompletion:nil];
            
            [profileCell.buttonCheckbox fadeInWithCompletion:nil];
            
            [profileCell.buttonCheckbox addTarget:self action:@selector(checkPressed:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            
            [profileCell.buttonFollow fadeInWithCompletion:nil];
            
            [profileCell.buttonCheckbox fadeOutWithCompletion:nil];
            
        }
        
    }
    else  if (self.profileType == kWProfileAlerts || self.profileType == kWProfileGifts) {
        
        [profileCell.imageViewPost setHidden:NO];
        
        [profileCell.buttonFollow setHidden:YES];
        
       
        if (self.profileType == kWProfileGifts) {

    
            if (indexPath.row <2) {
                
                
                profileCell.backgroundColor = [UIColor whiteColor];
                profileCell.labelName.text = @"Pending since 3 days";

            }
            else {
                
                profileCell.backgroundColor = [UIColor getLightGrayColor];
                profileCell.labelName.text = @"Your gift received 10 days ago";

            }
        }
        else {
        
            profileCell.labelName.text = @"Liked your Photo";
        }
        
        if (indexPath.row == 3 && self.profileType == kWProfileAlerts) {
            
            [profileCell.buttonFollow setHidden:NO];
            
            profileCell.buttonFollow.frame = CGRectMake(profileCell.buttonFollow.frame.origin.x, profileCell.buttonFollow.frame.origin.y, profileCell.buttonFollow.frame.size.width-30, profileCell.buttonFollow.frame.size.height);
            
            [self setTextToButton:profileCell.buttonFollow withTitle:@"Follow"];
            
            [profileCell.imageViewPost setHidden:YES];
            
            
        }
        //
    }
    else if(self.profileType == kWProfileGroup) {
        
        [profileCell.buttonFollow setHidden:YES];
        
        [profileCell.imageViewPost setHidden:YES];
        
        [profileCell.buttonCheckbox fadeInWithCompletion:nil];
        
        [profileCell.buttonCheckbox addTarget:self action:@selector(checkPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        profileCell.buttonCheckbox.tag = indexPath.row;
        
        if ([self.checkedArray containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
            
            profileCell.buttonCheckbox.selected = YES;
        }
        else {
            profileCell.buttonCheckbox.selected = NO;
        }
        
        if (!self.isGroup) {
            profileCell.buttonFollow.alpha = 1.0;
            [profileCell.buttonFollow setHidden:NO];
            [profileCell.buttonCheckbox setHidden:YES];
            [self updateUIforGroup:profileCell];
        }

    }
    return profileCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (self.profileType == kWProfileGifts || self.profileType == kWProfileAlerts) {
        
        return 8;
    }
    else
    return self.array.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WZMyProfileViewController *profileViewController = [[UIStoryboard getHomeStoryBoard] instantiateViewControllerWithIdentifier:K_SB_PROFILE_VIEW_CONTROLLER];
    profileViewController.profileType = kWProfileTypeOther;
    
    [self.navigationController pushViewController:profileViewController animated:YES];
    
}



#pragma mark Custom SearchBar Delegate Methods

#pragma mark Public Methods

- (void)createListPressed:(id)sender {
    
    [self.viewAddGroup setHidden:NO];
    [self.viewCreateList setHidden:YES];
    self.buttonCreate.hidden = NO;
    [self.buttonCreate addTarget:self action:@selector(createPressed) forControlEvents:UIControlEventTouchUpInside];
    // self.navigationItem.rightBarButtonItem = [RUUtility getBarButtonWithTitle:@"Create" forViewController:self selector:@selector(createPressed)];
    self.isEdit = YES;
    [self.tableView reloadData];
    
    
}

- (void)cameraPressed:(id)sender {
    
    [self.texFieldName resignFirstResponder];
    
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
    
    ;
}

#pragma mark UIImagePickerView Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // AND no doing some other kind of assignment
    
    [self.buttonProfile.imageView setRoundCornersAsCircle];
    
    [self.buttonProfile setImage:image forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
