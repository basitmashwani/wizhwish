//
//  WWizhViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-12.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kWWhizWishMode = 0,
    kWWhizBoardMode,
    KWWhizListMode,
    kWWhizGift,
} WhizMode;

@interface WWizhViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic ,retain) IBOutlet UIButton *buttonGift;

@property(nonatomic ,retain) IBOutlet UIButton *whizListButton;

@property(nonatomic ,retain) IBOutlet UIButton *whizWishButton;

@property(nonatomic ,retain) IBOutlet UIButton *whizBoardButton;

@property(nonatomic ,retain) NSMutableArray *imgArray;

@property(nonatomic ,retain) IBOutlet UISwitch *privateSwitch;

@property(nonatomic ,retain) IBOutlet UILabel *privateLabel;

@property(nonatomic ,retain) IBOutlet UIImageView *privateImage;

@property(nonatomic ,retain) IBOutlet UISearchBar *searchBar;

@property(nonatomic ,retain) IBOutlet UITextField *captionTextField;

@property(nonatomic ,retain) IBOutlet UITextField *tagUsersTextField;

@property(nonatomic ,retain) IBOutlet UITextField *locationTextField;

@property(nonatomic ,retain) IBOutlet UITextField *hashTagTextField;

@property(nonatomic ,retain) IBOutlet UITextField *websiteTextField;

@property(nonatomic ,retain) IBOutlet UICollectionView *collectionView;

@property(nonatomic ,retain) IBOutlet UIView *collectionViewContainer;

@property(nonatomic ,retain) IBOutlet UILabel *titleLabel;

@property(nonatomic ,retain) IBOutlet UIButton *buttonURL;

@property(nonatomic ,retain) IBOutlet UIView *giftView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewConstraint;

@property(nonatomic ,retain) IBOutlet UIImageView *publicIcon;

@property(nonatomic ,retain) IBOutlet UIImageView *giftIcon;

@property(nonatomic ,retain) IBOutlet UIImageView *thankYouIcon;

@property(nonatomic ,retain) IBOutlet UIImageView *publicImage;

@property(nonatomic ,retain) IBOutlet UIImageView *giftImage;

@property(nonatomic ,retain) IBOutlet UIImageView *thankYouImage;

@property(nonatomic ,retain) IBOutlet UIButton *publicButton;

@property(nonatomic ,retain) IBOutlet UIButton *giftButton;

@property(nonatomic ,retain) IBOutlet UIButton *ThankYouButton;






@property(nonatomic ,assign) WhizMode currentMode;

@property(nonatomic ,assign) BOOL showWhiz;

- (IBAction)whizWishPressed:(id)sender;

- (IBAction)giftPressed:(id)sender;

- (IBAction)whizBoardPressed:(id)sender;

- (IBAction)whizListPressed:(id)sender;

- (IBAction)privateSwitchChanged:(id)sender;

- (IBAction)publicButtonPressed:(id)sender;

- (IBAction)giftButtonPressed:(id)sender;

- (IBAction)thankYouButtonPressed:(id)sender;

@end
