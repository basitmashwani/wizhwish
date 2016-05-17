//
//  WLoginViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-18.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WZLoginViewController.h"


@implementation WZLoginViewController

#pragma mark Private Methods



#pragma mark Life Cycle Methods

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
    
    return UIStatusBarStyleLightContent;
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
    
    WZHomeViewController *homeViewController = [[UIStoryboard getHomeStoryBoard] instantiateViewControllerWithIdentifier:K_SB_HOME_VIEW_CONTROLLER];
    
    [RUUtility setMainRootController:homeViewController];
    
    //[self.navigationController pushViewController:homeViewController animated:YES];
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
