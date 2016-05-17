//
//  WPostsViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-12.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WZPostsViewController.h"

@implementation WZPostsViewController

#pragma mark Public Methods


#pragma mark Life Cycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];

    [RUUtility setBackButtonForController:self withSelector:@selector(backPressed)];
    
    [self.navigationItem setTitle:@"Discover"];
    
    [self didTappedView:self.view];


}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark Private Methods


#pragma mark UITableView Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    WZMyWishesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:K_CELL_POST];
    cell.collectionType =  kWPostType;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}
#pragma mark CollectionView Delegate Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WZFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_PEOPLE_COLLECTION_CELL forIndexPath:indexPath];
    [cell.buttonPeople setRoundCornersAsCircle];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
}

//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    return CGSizeMake(collectionView.frame.size.width/2 , collectionView.frame.size.height/2-1);
//    
//}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(2,2,2,2);  // top, left, bottom, right
}


@end
