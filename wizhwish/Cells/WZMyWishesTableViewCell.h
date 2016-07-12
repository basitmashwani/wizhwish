//
//  WMyWishesTableViewCell.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-10.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    KWWishesType = 0,
    kWPostType,
    KWFollowerType
} WCollectionType;

@interface WZMyWishesTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic ,retain) IBOutlet UICollectionView *collectionView;

@property(nonatomic ,assign) WCollectionType collectionType;

@property(nonatomic ,assign) BOOL isWishList;


@end
