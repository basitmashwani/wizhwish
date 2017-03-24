//
//  WPostTableViewCell.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-30.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WZPostTableViewCell.h"

@implementation WZPostTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self.imageViewProfile setRoundCornersAsCircle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
