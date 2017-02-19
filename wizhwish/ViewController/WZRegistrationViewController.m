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


#pragma mark Life Cycle Methods

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

    WProfileViewController *profileViewController = [[UIStoryboard getProfileStoryBoard] instantiateViewControllerWithIdentifier:@"K_SB_PROFILE_VC"];
 //WZHomeViewController *homeViewController = [[UIStoryboard getHomeStoryBoard] instantiateViewControllerWithIdentifier:K_SB_HOME_VIEW_CONTROLLER];
    
    
    [RUUtility setMainRootController:profileViewController];
    //[self.navigationController pushViewController:homeViewController animated:YES];
    
 //   [self performSegueWithIdentifier:K_SEGUE_HOME sender:self];
}


@end
