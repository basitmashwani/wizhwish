//
//  WMyDailiesViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-06-17.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "WMyDailiesViewController.h"

@interface WMyDailiesViewController ()

@end

@implementation WMyDailiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionView Delegate Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WZFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_PEOPLE_COLLECTION_CELL forIndexPath:indexPath];
  
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 12;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(collectionView.frame.size.width/3.05 , collectionView.frame.size.height/2.5);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Sedas");
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
