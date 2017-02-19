//
//  WGiftViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-19.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WGiftViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,JKSearchBarDelegate>

@property(nonatomic ,retain) IBOutlet UIButton *giftButton;

@property(nonatomic ,retain) IBOutlet UIButton *privateButton;

@property(nonatomic ,retain) IBOutlet UIImageView *imageBg;

@property(nonatomic ,retain) IBOutlet JKSearchBar *searchBar;

@property(nonatomic ,retain) IBOutlet UICollectionView *collectionView;

@property(nonatomic ,retain) IBOutlet UILabel *firstLabel;

@property(nonatomic ,retain) IBOutlet UILabel *secondLabel;


- (IBAction)giftPressed:(id)sender;

- (IBAction)privatePressed:(id)sender;



@end
