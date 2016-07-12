//
//  WFollowerViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-03.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "JKSearchBar.h"

typedef enum {
    KWProfileFollower = 0,
    kWProfileFollowing,
    kWProfileAlerts,
    kWProfileGifts,
    kWProfileGroup

} WProfileType;

@interface WZFollowerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property(nonatomic ,assign) WProfileType profileType;

@property(nonatomic ,retain) IBOutlet UIView *viewAddGroup;

@property(nonatomic ,retain) IBOutlet UIView *viewCreateList;

@property(nonatomic ,retain) IBOutlet UITextField *texFieldName;

@property(nonatomic ,retain) IBOutlet UIButton *buttonProfile;

@property(nonatomic ,retain) IBOutlet UITableView *tableView;

@property(nonatomic ,retain) IBOutlet UIButton *buttonCreate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchTopConstraint;


- (IBAction)createListPressed:(id)sender;

- (IBAction)cameraPressed:(id)sender;

@end
