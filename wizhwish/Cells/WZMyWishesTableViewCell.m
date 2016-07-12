//
//  WMyWishesTableViewCell.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-10.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WZMyWishesTableViewCell.h"

@interface WZMyWishesTableViewCell()

@property(nonatomic ,assign) NSInteger rowWidth;
@property(nonatomic ,assign) NSInteger rowHeight;


@end

@implementation WZMyWishesTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.collectionView.backgroundColor = [UIColor getLightGrayColor];
    [self.collectionView reloadData];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark UICollectionView Delegate Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WZFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_CELL_MY_WISHES forIndexPath:indexPath];
    
    if (self.collectionType == KWWishesType) {

    if (self.isWishList) {
        
        cell.profileImageView.image = [UIImage imageNamed:@"Image_Magic_Stick"];
        cell.labelName.hidden = YES;
        cell.labelCaption.center = CGPointMake(cell.labelCaption.center.x-5, cell.labelCaption.center.y-12);
    }
    else {
        
        cell.profileImageView.image = [UIImage imageNamed:@"Image_Profile-1"];
        cell.labelName.hidden = NO;
        
        cell.labelCaption.center = CGPointMake(cell.labelCaption.center.x+5, cell.labelCaption.center.y+12);
    }
    }
    
    // WFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_COLLECTION_VIEW_MY_WISHES forIndexPath:indexPath];
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.collectionType == kWPostType) {
        
        return 4;
    }
    return 3;
}
// Layout: Set cell size



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGSize returnSize;

    if (self.collectionType == KWWishesType) {
        
        self.rowWidth = 3;
        
        returnSize = CGSizeMake(collectionView.frame.size.width/3-7, collectionView.frame.size.height);
    }
    else  if (self.collectionType == KWFollowerType)
    {
        self.rowWidth = 2;
        
       returnSize =  CGSizeMake(collectionView.frame.size.width/2-7 ,collectionView.frame.size.height);
        
    }
    else {
        returnSize =  CGSizeMake(collectionView.frame.size.width/4-1.7 ,collectionView.frame.size.height);
        

    }
    return returnSize;
    
    // return CGSizeMake(collectionView.frame.size.width/3 , collectionView.frame.size.height/3-1);
    
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}


@end
