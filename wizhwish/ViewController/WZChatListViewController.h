//
//  WZChatListViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-15.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
   KWTypeFollower = 0,
    kWTypeContact
    
} WViewType;
@interface WZChatListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic ,retain) IBOutlet UITableView *tableView;

@property(nonatomic ,assign)  WViewType viewType;

@end
