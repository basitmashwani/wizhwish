//
//  WCommentsViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-19.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCommentsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic ,retain) IBOutlet UITableView *tableView;

@end
