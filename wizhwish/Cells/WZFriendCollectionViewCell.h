//
//  WFriendCollectionViewCell.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-21.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface WZFriendCollectionViewCell : UICollectionViewCell

@property(nonatomic ,retain) IBOutlet UIImageView *imageView;

@property(nonatomic ,retain) IBOutlet UIImageView *profileImageView;

@property(nonatomic ,retain) IBOutlet UILabel *labelName;

@property(nonatomic ,retain) IBOutlet UILabel *labelCaption;

@property(nonatomic ,retain) IBOutlet UIButton *buttonPeople;





@end
