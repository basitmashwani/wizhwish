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
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark UICollectionView Delegate Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WZFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_CELL_MY_WISHES forIndexPath:indexPath];
    
    
    // WFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_COLLECTION_VIEW_MY_WISHES forIndexPath:indexPath];
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 16;
}
// Layout: Set cell size



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.collectionType == KWWishesType) {
        
        self.rowWidth = 2;
    }
    else {
        self.rowWidth = 4;
        
    }
    if (IS_IPHONE_5) {
       // return CGSizeMake(collectionView.frame.size.width/2 , 155);
        //170;
         return CGSizeMake(collectionView.frame.size.width/self.rowWidth ,collectionView.frame.size.height);

    }
    else if (IS_IPHONE_6) {
        return CGSizeMake(collectionView.frame.size.width/self.rowWidth , collectionView.frame.size.height);
        
        
    }
    else if(IS_IPHONE_6_PLUS) {
        
        return CGSizeMake(collectionView.frame.size.width/self.rowWidth , collectionView.frame.size.height);
        
    }
    
    return CGSizeZero;
    
    // return CGSizeMake(collectionView.frame.size.width/3 , collectionView.frame.size.height/3-1);
    
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}


@end
