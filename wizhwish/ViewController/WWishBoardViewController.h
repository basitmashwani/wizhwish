//
//  WGiftViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-19.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

typedef enum {
    KWWishBoard = 0,
    kWWishLists
} WBoardType;

#import <UIKit/UIKit.h>

@interface WWishBoardViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic ,retain) IBOutlet UITableView *tableView;

@property(nonatomic ,assign) WBoardType currentType;

@property(nonatomic ,assign) IBOutlet UILabel *label;

@property(nonatomic ,assign) IBOutlet NSLayoutConstraint *constraint;

@end
