//
//  WMyProfileViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-03.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WZMyProfileViewController.h"
#import "WZFollowerViewController.h"
#import <UIImageView+AFNetworking.h>

@interface WZMyProfileViewController ()

@property(nonatomic ,retain) WProfile *profile;

@end


@implementation WZMyProfileViewController


#pragma mark Private Methods

- (void)followingPressed:(id)sender {

   
}


- (void)followerPressed:(id)sender {
    
    WZFollowerViewController *followingController = [[UIStoryboard getProfileStoryBoard] instantiateViewControllerWithIdentifier:K_SB_FOLLOWER_VIEW_CONROLLER];
    followingController.profileType = KWProfileFollower;
    
    [self.navigationController pushViewController:followingController animated:YES];
}
- (void)followButtonPressed:(id)sender {
    
    NSLog(@"Follwing user %@",self.stringName);
    if(self.profileType == KWProfileTypeFollow) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        __weak typeof(self) weakSelf = self;
        [[WZServiceParser sharedParser] processFollowUser:self.userName success:^(NSDictionary *dict) {
            
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            
            [weakSelf.buttonFollow setTitle:@"Following" forState:UIControlStateNormal];
            [weakSelf.buttonFollow setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [weakSelf.buttonFollow setBackgroundImage:[UIImage imageNamed:@"Image_Button_bg"] forState:UIControlStateNormal];
            
        } failure:^(NSError *error) {
           
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [OLGhostAlertView showAlertAtCenterWithTitle:@"Message" message:@"Unable to proceed request"];

        }];

        
}
    else if(self.profileType == KWPofileTypeSelf) {
        
        WProfileViewController *profileViewController = [[UIStoryboard getProfileStoryBoard] instantiateViewControllerWithIdentifier:k_SB_PROFILE_EDIT_VC];
        profileViewController.isFromRegistration = NO;
        profileViewController.profile = self.profile;
        profileViewController.profileImg = self.imageViewProfile.image;
        profileViewController.bannerImg = self.bannerImageView.image;
        [self.navigationController pushViewController:profileViewController animated:YES];
    }
    

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
        NSString *profileURL = nil;
    
     if(self.profileType == KWPofileTypeSelf) {
        
         profileURL = @"/users/myProfile";
       
     }
    
    else {
        
        profileURL = [NSString stringWithFormat:@"%@%@",@"/users/userProfile?j_username=",self.userName];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [[WZServiceParser sharedParser] processGetProfileFor:profileURL success:^(NSDictionary *dict) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSLog(@"Dictionary %@",dict);
        
        weakSelf.profile = [[WProfile alloc] init];
        
        weakSelf.profileName.text = [dict valueForKey:@"name"];
        
        weakSelf.profile.fullName = [dict valueForKey:@"name"];
        
        weakSelf.profile.bio = [dict valueForKey:@"bio"];
        
        if ([weakSelf.profile.bio isEqual:[NSNull null]]) {
     
             weakSelf.profileBio.text = @"";
       
        }
        else {
       //
            weakSelf.profileBio.text = weakSelf.profile.bio;
        
        }
        
        
        weakSelf.profile.phoneNumber = [dict valueForKey:@"phone"];
        
        weakSelf.profile.bannerURL = [dict valueForKey:@"bannerImageUrl"];
        
        weakSelf.profile.profileURL = [dict valueForKey:@"standardImageUrl"];
        
        weakSelf.profile.profileThumbURL = [dict valueForKey:@"thumbnailImageUrl"];
        
        weakSelf.profile.gender = [dict valueForKey:@"gender"];
        

        NSString *urlPath = [dict valueForKey:@"standardImageUrl"];
        
        if (![urlPath isEqual:[NSNull null]]) {
        NSURL *url = [NSURL URLWithString:urlPath];
        
        [weakSelf.imageViewProfile setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Image_Profile-1"]];
        //weakSelf.bio
        }
        
        NSString *bannerUrlPath = [dict valueForKey:@"bannerImageUrl"];
        
        if (![bannerUrlPath isEqual:[NSNull null]]) {
            NSURL *url = [NSURL URLWithString:bannerUrlPath];
            
            [weakSelf.bannerImageView setImageWithURL:url];
        }
        
    } failure:^(NSError *error) {
       
        NSLog(@"unable to get ");
    }];
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self showNavigationBar:YES];
    
    self.collectionViewWishes.backgroundColor = [UIColor blackColor];
    
    self.collectionViewMyWishList.backgroundColor = [UIColor blackColor];
    
    self.collectionViewFollowing.backgroundColor = [UIColor blackColor];
    
    self.collectionViewFollower.backgroundColor = [UIColor blackColor];
    
    self.collectionViewWishes.layer.borderWidth=1.0f;
    self.collectionViewWishes.layer.borderColor=[UIColor blackColor].CGColor;
   
    self.collectionViewMyWishList.layer.borderWidth=1.0f;
    self.collectionViewMyWishList.layer.borderColor=[UIColor blackColor].CGColor;
   
    self.collectionViewFollower.layer.borderWidth=1.0f;
    self.collectionViewFollower.layer.borderColor=[UIColor blackColor].CGColor;
   
    self.collectionViewFollowing.layer.borderWidth=1.0f;
    self.collectionViewFollowing.layer.borderColor=[UIColor blackColor].CGColor;
    
    [self.imageViewProfile setRoundCornersAsCircle];
    
    if(self.profileType == KWPofileTypeSelf) {
        
      //  self.buttonFollow.hidden = YES;
        
       // self.buttonOption.hidden = YES;
        
        
        [self.buttonFollow setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.buttonFollow setTitle:@"Edit" forState:UIControlStateNormal];
        
        [self.buttonFollow setBackgroundImage:[UIImage imageNamed:@"Image_Edit_button"] forState:UIControlStateNormal];
    }
    else if(self.profileType == kWProfileTypeOther) {
        
        //  self.buttonFollow.hidden = YES;
        
        // self.buttonOption.hidden = YES;
        
        
        [self.buttonFollow setTitle:@"Following" forState:UIControlStateNormal];
        [self.buttonFollow setTitleColor:[UIColor getLightGrayColor] forState:UIControlStateNormal];
        [self.buttonFollow setBackgroundImage:[UIImage imageNamed:@"Image_Button_bg"] forState:UIControlStateNormal];
    }
    
    else {
    
        //follow
        
        [self.buttonFollow setTitle:@"Follow" forState:UIControlStateNormal];
        [self.buttonFollow setTitleColor:[UIColor navigationBarColor] forState:UIControlStateNormal];
        [self.buttonFollow setBackgroundImage:[UIImage imageNamed:@"Image_Follow"] forState:UIControlStateNormal];
         self.profileName.text = self.stringName;

    }
    
    [self.buttonFollow addTarget:self action:@selector(followButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationItem setTitle:@"Username"];
    
    [RUUtility setBackButtonForController:self withSelector:@selector(backPressed)];
    
    // Do any additional setup after loading the view.
 
    
    self.followingLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *followerGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(followingPressed:)];
    [self.followingLabel addGestureRecognizer:followerGesture];
    
    
    self.followerLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *followingGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(followerPressed:)];
    [self.followerLabel addGestureRecognizer:followingGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}


#pragma mark UICollectionView Delegate Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WZFriendCollectionViewCell *cell;
    if (collectionView == self.collectionViewWishes) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_COLLECTION_VIEW_MY_WISHES forIndexPath:indexPath];
    }
    else if(collectionView == self.collectionViewMyWishList) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_COLLECTION_VIEW_WISHLIST forIndexPath:indexPath];
    }
    else if(collectionView == self.collectionViewFollower) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_COLLECTION_VIEW_FOLLOWER forIndexPath:indexPath];
    }
    else if(collectionView == self.collectionViewFollowing) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_COLLECTION_VIEW_FOLLOWING forIndexPath:indexPath];
    }
    // WFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_COLLECTION_VIEW_MY_WISHES forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:@"Image_Profile-1"];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 15;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *viewController = nil;
    
    if (collectionView == self.collectionViewFollowing||collectionView == self.collectionViewFollower) {
        WZFollowerViewController *followerViewController = [[UIStoryboard getProfileStoryBoard] instantiateViewControllerWithIdentifier:K_SB_FOLLOWER_VIEW_CONROLLER];
        
        if (collectionView == self.collectionViewFollower) {
            
            followerViewController.profileType = KWProfileFollower;
            
        } else {
            followerViewController.profileType = kWProfileFollowing;
        }
        viewController = followerViewController;
        
    } else if(collectionView == self.collectionViewWishes) {
        
        
        //open wishes screen
        WZMyWishesViewController *myWishesViewController = [[UIStoryboard getProfileStoryBoard] instantiateViewControllerWithIdentifier:K_SB_MYWISHES_VIEW_CONROLLER];
        
        myWishesViewController.wishType = KWMyWishes;
        
        viewController = myWishesViewController;
        
    }
    else if(collectionView == self.collectionViewMyWishList) {
        
        WZMyWishesViewController *myWishesViewController = [[UIStoryboard getProfileStoryBoard] instantiateViewControllerWithIdentifier:K_SB_MYWISHES_VIEW_CONROLLER];
        
        myWishesViewController.wishType = kWWishList;
        
        viewController = myWishesViewController;
        
        
    }
    [self.navigationController pushViewController:viewController animated:YES];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(collectionView.frame.size.width/3 , collectionView.frame.size.height/4 );
    
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}


#pragma mark Public Methods 

- (void)editPressed:(id)sender {
    
}





/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
