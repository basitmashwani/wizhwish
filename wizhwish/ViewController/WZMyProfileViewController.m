//
//  WMyProfileViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-03.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WZMyProfileViewController.h"
#import "WZFollowerViewController.h"

@interface WZMyProfileViewController ()

@end


@implementation WZMyProfileViewController


#pragma mark Private Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.collectionViewWishes.backgroundColor = [UIColor whiteColor];
    
    self.collectionViewMyWishList.backgroundColor = [UIColor whiteColor];
    
    self.collectionViewFollowing.backgroundColor = [UIColor whiteColor];
    
    self.collectionViewFollower.backgroundColor = [UIColor whiteColor];
    
    [self.imageViewProfile setRoundCornersAsCircle];
    
    if(self.profileType == KWPofileTypeSelf) {
        
        self.buttonFollow.hidden = YES;
        
        self.buttonOption.hidden = YES;
    }
    
    [self.navigationItem setTitle:@"Username"];
    
    [RUUtility setBackButtonForController:self withSelector:@selector(backPressed)];
    
    // Do any additional setup after loading the view.
    
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
    
    return 4;
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
    
    return CGSizeMake(collectionView.frame.size.width/2 , collectionView.frame.size.height/2-1);
    
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
