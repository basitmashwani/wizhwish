//
//  LoginViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-25.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController :  UIViewController<UITextFieldDelegate>

@property(nonatomic ,weak) IBOutlet UITextField *textFieldUsername;

@property(nonatomic ,weak) IBOutlet UITextField *textFieldPassword;


@property (weak, nonatomic) IBOutlet UIImageView *mView;


- (IBAction)signUpPressed:(id)sender;

- (IBAction)signInPressed:(id)sender;

@end

