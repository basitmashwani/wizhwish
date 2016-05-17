//
//  WProfileTableViewCell.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-03.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WZProfileTableViewCell.h"

@implementation WZProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imageViewProfile setRoundCornersAsCircle];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
