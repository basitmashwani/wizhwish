//
//  WRegistrationViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-20.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface WZRegistrationViewController : UIViewController

@property(nonatomic ,retain) IBOutlet UITextField *textFieldUserName;

@property(nonatomic ,retain) IBOutlet UITextField *textFieldEmail;

@property(nonatomic ,retain) IBOutlet UITextField *textFieldPassword;

@property(nonatomic ,retain) IBOutlet UITextField *textFieldRePassword;

@property(nonatomic ,retain) IBOutlet UIImageView *mImageView;


- (IBAction)signInPressed:(id)sender;
- (IBAction)registerPressed:(id)sender;

@end
