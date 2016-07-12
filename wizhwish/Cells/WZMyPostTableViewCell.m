//
//  WZMyPostTableViewCell.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-06-05.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WZMyPostTableViewCell.h"

@implementation WZMyPostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.imageViewPost setRoundCornersAsCircle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
