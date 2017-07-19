//
//  LoginViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-25.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "LoginViewController.h"


@implementation LoginViewController

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
    [self.mView.layer addSublayer:layer];
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
    [RUUtility setUpNavigationBar:self.navigationController];
    [self didTappedView:self.view];
    [self.textFieldUsername setTextFieldPlaceHolderColor:[UIColor whiteColor]];
    [self.textFieldPassword setTextFieldPlaceHolderColor:[UIColor whiteColor]];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.textFieldUsername) {
        
        [self.textFieldPassword becomeFirstResponder];
        return NO;
        
    }
    [self.textFieldPassword resignFirstResponder];
    
    return YES;
    
}

#pragma mark Public Methods

- (void)signUpPressed:(id)sender {
    
    WZRegistrationViewController *registrationVC = [self.storyboard instantiateViewControllerWithIdentifier:K_SB_REGISTER_VIEW_CONTROLLER];
    [self.navigationController pushViewController:registrationVC animated:YES];
    
}

- (void)signInPressed:(id)sender {
    
    if (![NSString validateStringForEmail:self.textFieldUsername.text]) {
        
        [OLGhostAlertView showAlertAtBottomWithTitle:@"Error" message:@"Please enter valid email address"];
    }
   
    else if (self.textFieldPassword.text.length >8) {
        
        [OLGhostAlertView showAlertAtBottomWithTitle:@"Error" message:@"Password must be 8 characters long"];
        
    }   else {
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [[WZServiceParser sharedParser] processLoginUserWithEmail:self.textFieldUsername.text password:self.textFieldPassword.text success:^(NSString *response) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:response forKey:k_ACCESS_TOKEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        WZHomeViewController *homeViewController = [[UIStoryboard getHomeStoryBoard] instantiateViewControllerWithIdentifier:K_SB_HOME_VIEW_CONTROLLER];
        
        [RUUtility setMainRootController:homeViewController];
    } failure:^(NSError *error) {
        
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [OLGhostAlertView showAlertAtBottomWithTitle:@"Error" message:error.localizedDescription];
    }];
    
   ;
    
    //[self.navigationController pushViewController:homeViewController animated:YES];
}
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
