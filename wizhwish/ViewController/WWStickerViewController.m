//
//  WWStickerViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-08-18.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "WWStickerViewController.h"

@interface WWStickerViewController ()

@end

@implementation WWStickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [RUUtility setBackButtonForController:self withSelector:@selector(closePressed)];
    NSLog(@"width %f height %f",self.view.frame.size.width,self.view.frame.size.height);
    
    [self.collectionView reloadData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)closePressed {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UICollectionView Delegate Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WZFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sticker_cell" forIndexPath:indexPath];
    
    
    NSString *stickerName = [NSString stringWithFormat:@"%@%d%@",@"stickers",indexPath.row+1,@".png"];
    cell.imageView.image = [UIImage imageNamed:stickerName];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 30;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(collectionView.frame.size.width/3.1 , collectionView.frame.size.height/3);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *stickerName = [NSString stringWithFormat:@"%@%d%@",@"stickers",indexPath.row+1,@".png"];
    UIImage *image = [UIImage imageNamed:stickerName];
    
    if ([self.delegate respondsToSelector:@selector(StickerViewController:didStickerSelected:)]) {
        
        [self.delegate StickerViewController:self didStickerSelected:image];
    }

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
   return UIEdgeInsetsMake(3, 3, 3, 3);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 2;
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
