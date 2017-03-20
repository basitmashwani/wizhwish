//
//  WHomeViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-20.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NJKScrollFullScreen/NJKScrollFullScreen.h>


@interface WZHomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NJKScrollFullscreenDelegate >

@property(nonatomic ,retain) IBOutlet UICollectionView *collectionView;

@property(nonatomic ,retain) IBOutlet UITableView *tableView;

@property(nonatomic ,retain) IBOutlet UIButton *buttonTopScroll;

@property(nonatomic ,retain) IBOutlet NSLayoutConstraint *topConstant;



- (IBAction)scrollTopPressed:(id)sender;

- (IBAction)showPostView:(id)sender;

- (IBAction)commentPressed:(id)sender;

@end
