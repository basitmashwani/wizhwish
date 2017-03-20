//
//  WRegistrationViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-20.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WZRegistrationViewController.h"
@implementation WZRegistrationViewController

#pragma mark Private Methods
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *playerItem = [notification object];
    [playerItem seekToTime:kCMTimeZero];
}

#pragma mark Life Cycle Methods


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Background" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AVPlayer *player = [[AVPlayer alloc] initWithURL:url];
    AVPlayerLayer *layer = [[AVPlayerLayer alloc] init];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.player = player;
    layer.frame = self.view.frame;
      [self.mImageView.layer addSublayer:layer];
    // [self.view bringSubviewToFront:self.textFieldPassword];
    //[self.view bringSubviewToFront:self.textFieldUsername];
    // [self.view.layer insertSublayer:layer below:self.ima.layer];
    
    
    [player play];
    
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[player currentItem]];
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self didTappedView:self.view];
    [self.textFieldPassword setTextFieldPlaceHolderColor:[UIColor whiteColor]];
    [self.textFieldRePassword setTextFieldPlaceHolderColor:[UIColor whiteColor]];
    [self.textFieldEmail setTextFieldPlaceHolderColor:[UIColor whiteColor]];
    [self.textFieldUserName setTextFieldPlaceHolderColor:[UIColor whiteColor]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.textFieldEmail) {
        
        [self.textFieldUserName becomeFirstResponder];
       
        return NO;
        
    } else if(textField == self.textFieldUserName) {
        
        [self.textFieldPassword becomeFirstResponder];
        
        return NO;

    } else if(textField == self.textFieldPassword) {
       
        [self.textFieldRePassword becomeFirstResponder];
        
        return NO;
    }
    
    [textField resignFirstResponder];
    
    return YES;
    
}


#pragma mark Public Methods

- (void)signInPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)registerPressed:(id)sender {

   // WProfileViewController *profileViewController = [[UIStoryboard getProfileStoryBoard] instantiateViewControllerWithIdentifier:@"K_SB_PROFILE_VC"];
 //    [RUUtility setMainRootController:profileViewController];
    
    if (![NSString validateStringForEmail:self.textFieldEmail.text]) {
        
        [OLGhostAlertView showAlertAtBottomWithTitle:@"Error" message:@"Please enter valid email address"];
    }
    else if (self.textFieldUserName.text.length <6) {
        
        [OLGhostAlertView showAlertAtBottomWithTitle:@"Error" message:@"Username must be 6 characters long"];

    }
    else if (self.textFieldPassword.text.length <8) {
        
        [OLGhostAlertView showAlertAtBottomWithTitle:@"Error" message:@"Password must be 8 characters long"];

    }
    else if (![self.textFieldPassword.text isEqualToString:self.textFieldRePassword.text]) {
        
        [OLGhostAlertView showAlertAtBottomWithTitle:@"Error" message:@"Password and re-Password does not match"];

    }
    else {
    
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak typeof(self) weakSelf = self;
    [[WZServiceParser sharedParser] processRegisterUserWithEmail:self.textFieldEmail.text userName:self.textFieldUserName.text password:self.textFieldPassword.text success:^(NSString *response) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSLog(@"Success %@",response);
        if ([response isEqualToString:@"success"]) {
            
            [[WZServiceParser sharedParser] processLoginUserWithEmail:weakSelf.textFieldEmail.text password:weakSelf.textFieldPassword.text success:^(NSString *response) {
                
                [[NSUserDefaults standardUserDefaults] setObject:response forKey:k_ACCESS_TOKEN];
                [[NSUserDefaults standardUserDefaults] synchronize];
                WProfileViewController *profileViewController = [[UIStoryboard getProfileStoryBoard] instantiateViewControllerWithIdentifier:@"K_SB_PROFILE_VC"];
                [RUUtility setMainRootController:profileViewController];
            } failure:^(NSError *error) {
                
            }];
            
            
        }

    } failure:^(NSError *error) {
       
        NSLog(@"Error %@",error.localizedDescription);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [OLGhostAlertView showAlertAtBottomWithTitle:@"Error" message:@"Unable to process request"];

        
        


    }];
    
    }
}

@end
