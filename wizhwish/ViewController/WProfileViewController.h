//
//  WProfileViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-19.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WProfile.h"

@interface WProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic ,retain) IBOutlet UITableView *tableView;

@property(nonatomic ,retain) IBOutlet UIButton *bannerButton;

@property(nonatomic ,retain) IBOutlet UIButton *profileButton;

@property(nonatomic ,retain) IBOutlet UIImageView *bannerImage;

@property(nonatomic ,retain) IBOutlet UIImageView *profileImage;

@property(nonatomic ,retain) UIImage *profileImg;

@property(nonatomic ,retain) UIImage *bannerImg;

@property(nonatomic ,assign) BOOL isFromRegistration;

@property(nonatomic ,retain) WProfile *profile;

- (IBAction)bannerPressed:(id)sender;

- (IBAction)profilePressed:(id)sender;
@end

