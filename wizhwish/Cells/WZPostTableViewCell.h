//
//  WPostTableViewCell.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-30.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZPostTableViewCell : UITableViewCell

@property(nonatomic ,retain) IBOutlet UIImageView *imageViewProfile;

@property(nonatomic ,retain) IBOutlet UIImageView *imageViewPost;

@property(nonatomic ,retain) IBOutlet UILabel *labelProfileName;

@property(nonatomic ,retain) IBOutlet UIButton *buttonLike;

@property(nonatomic ,retain) IBOutlet UIButton *buttonComment;

@property(nonatomic ,retain) IBOutlet UIButton *buttonRewhiz;

@property(nonatomic ,retain) IBOutlet UILabel *labelPostDate;

@property(nonatomic ,retain) IBOutlet UILabel *labelCommentTitle;

@property(nonatomic ,retain) IBOutlet UILabel *labelComment;

@property(nonatomic ,retain) IBOutlet UILabel *labelPostTitle;

@property(nonatomic ,retain) IBOutlet UILabel *labelPostText;

@property(nonatomic)  BOOL isText;

@property(nonatomic ,retain) IBOutlet UILabel *labelOtherComment;
@end
