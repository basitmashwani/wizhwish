//
//  WMyProfileViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-03.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KWPofileTypeSelf = 0,
    kWProfileTypeOther
} WProfileViewType;

@interface WZMyProfileViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic ,retain) IBOutlet UICollectionView *collectionViewFollower;

@property(nonatomic ,retain) IBOutlet UICollectionView *collectionViewFollowing;

@property(nonatomic ,retain) IBOutlet UICollectionView *collectionViewWishes;

@property(nonatomic ,retain) IBOutlet UICollectionView *collectionViewMyWishList;

@property(nonatomic ,retain) IBOutlet UIButton *buttonFollow;

@property(nonatomic ,retain) IBOutlet UIButton *buttonOption;

@property(nonatomic ,retain) IBOutlet UIImageView *imageViewProfile;

@property(nonatomic ,assign) WProfileViewType profileType;

- (IBAction)editPressed:(id)sender;
@end
