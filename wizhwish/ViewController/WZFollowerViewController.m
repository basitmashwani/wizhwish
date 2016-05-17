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
@end

@implementation WZFollowerViewController

#pragma mark Private Methods

- (void)updateUIforGroup:(WZProfileTableViewCell*)cell {
   
    UIButton *button = cell.buttonFollow;
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"Chat" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor navigationBarColor] forState:UIControlStateNormal];
    [button setBackgroundImage:nil forState:UIControlStateNormal];
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
    self.navigationItem.rightBarButtonItem = nil;
    self.viewAddGroup.hidden = YES;
    self.viewCreateList.hidden = NO;
    self.isEdit = NO;
    [self.tableView reloadData];
}

- (void)setTextToButton:(UIButton*)button withTitle:(NSString*)title {
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
     UIImage *image = [UIImage imageNamed:@"Image_Follow_Bg"];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    
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
    }
    
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//NSLog(@"profile type %d",self.profileType);
    
    if (self.profileType == kWProfileFollowing) {
        
        [self.navigationItem setTitle:@"Following"];
    }
    else if(self.profileType == KWProfileFollower) {
        
        [self.navigationItem setTitle:@"Followers"];
    }
    else if(self.profileType == kWProfileAlerts|| self.profileType == kWProfileGifts) {
        
        if (self.profileType == kWProfileGifts) {
            
            [self.navigationItem setTitle:@"Gifts"];
        }
        else {
        
            [self.navigationItem setTitle:@"Alerts"];
        }
        
        [self.texFieldSearch setHidden:YES];
        
        [self.viewCreateList setHidden:YES];
        
        [self.viewAddGroup setHidden:YES];
        
        self.tableViewTopConstraint.constant = -90;
      
    }
    else if(self.profileType == kWProfileGroup) {
 
        [self.navigationItem setTitle:@"Chat"];
        [self.texFieldName setPlaceholder:@"Enter group name"];
        self.isEdit = YES;
        self.isGroup = YES;
        [self.texFieldSearch setHidden:NO];
        [self createListPressed:self];

    }
    
    [RUUtility setBackButtonForController:self withSelector:@selector(backButtonPressed)];
    
    [self.texFieldName setTextFieldPlaceHolderColor:[UIColor blackColor]];
    
    
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
        self.searchTopConstraint.constant = -40;
        self.isGroup = NO;
        self.navigationItem.rightBarButtonItem = nil;

        [self.tableView reloadData];
        

    }
    else {
    
    [self resetViews];
   
    }
}

#pragma Mark TableViewDelegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WZProfileTableViewCell *profileCell = [tableView dequeueReusableCellWithIdentifier:K_FOLLOWER_CELL];
    
    if (self.profileType == kWProfileFollowing || self.profileType == KWProfileFollower) {
        
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

            profileCell.labelName.text = @"Pending since 3 days";
    
            
        }
        else {
        
            profileCell.labelName.text = @"Liked your Photo";
        }
        
        if (indexPath.row == 3 && self.profileType == kWProfileAlerts) {
            
            [profileCell.buttonFollow setHidden:NO];
            
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
    
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WZMyProfileViewController *profileViewController = [[UIStoryboard getHomeStoryBoard] instantiateViewControllerWithIdentifier:K_SB_PROFILE_VIEW_CONTROLLER];
    profileViewController.profileType = kWProfileTypeOther;
    
    [self.navigationController pushViewController:profileViewController animated:YES];
    
}

#pragma mark Public Methods

- (void)createListPressed:(id)sender {
    
    [self.viewAddGroup setHidden:NO];
    [self.viewCreateList setHidden:YES];
    self.navigationItem.rightBarButtonItem = [RUUtility getBarButtonWithTitle:@"Create" forViewController:self selector:@selector(createPressed)];
    self.isEdit = YES;
    [self.tableView reloadData];
    
    
}

- (void)cameraPressed:(id)sender {
    
    
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
