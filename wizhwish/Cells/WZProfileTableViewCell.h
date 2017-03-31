//
//  WProfileTableViewCell.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-03.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZProfileTableViewCell : UITableViewCell

@property(nonatomic ,retain) IBOutlet UIImageView *imageViewProfile;

@property(nonatomic ,retain) IBOutlet UILabel *labelUserName;

@property(nonatomic ,retain) IBOutlet UILabel *labelName;

@property(nonatomic ,retain) IBOutlet UIButton *buttonFollow;

@property(nonatomic ,retain) IBOutlet UIButton *buttonCheckbox;

@property(nonatomic ,retain) IBOutlet UIImageView *imageViewPost;

@property(nonatomic ,retain) IBOutlet UILabel *timeLabel;






@end
