//
//  WHomeViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-20.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZHomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic ,retain) IBOutlet UICollectionView *collectionView;

@property(nonatomic ,retain) IBOutlet UITableView *tableView;

@property(nonatomic ,retain) IBOutlet UIButton *buttonTopScroll;


- (IBAction)scrollTopPressed:(id)sender;
@end
