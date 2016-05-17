//
//  WMyWishesViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-08.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMyWishesViewController.h"
typedef enum {
    KWMyWishes = 0,
    kWWishList
} WWishType;


@interface WZMyWishesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,weak) IBOutlet HMSegmentedControl *segmentControl;

@property(nonatomic ,assign) WWishType wishType;

@property(nonatomic ,weak) IBOutlet UITableView *tableView;

@property(nonatomic ,weak) IBOutlet UIButton *buttonPost;

@property(nonatomic ,weak) IBOutlet UIButton *buttonMyWishes;

- (IBAction)postPressed:(id)sender;

- (IBAction)myWishesPressed:(id)sender;

@end
