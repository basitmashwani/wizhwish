//
//  WPostsViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-12.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZPostsViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,weak) IBOutlet UICollectionView *collectionView;

@property(nonatomic ,weak) IBOutlet UITableView *tableView;


@property(nonatomic ,weak) IBOutlet UIView *headerView;
@end
