//
//  WPostTopTableViewCell.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-30.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZPostTopTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic ,retain) IBOutlet UICollectionView *collectionView;

@property(nonatomic ,retain) IBOutlet UIButton *buttonNotification;

@property(nonatomic ,retain) IBOutlet UIButton *buttonInMail;

@property(nonatomic ,retain) IBOutlet UIButton *buttonGift;


@end
