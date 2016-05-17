//
//  WLoginViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-18.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WZLoginViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic ,weak) IBOutlet UITextField *textFieldUsername;

@property(nonatomic ,weak) IBOutlet UITextField *textFieldPassword;

- (IBAction)signUpPressed:(id)sender;

- (IBAction)signInPressed:(id)sender;

@end
