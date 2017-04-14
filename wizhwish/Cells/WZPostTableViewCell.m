//
//  WPostTableViewCell.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-30.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WZPostTableViewCell.h"

@interface WZPostTableViewCell()<KIImagePagerDataSource,KIImagePagerDelegate>


@end

@implementation WZPostTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self.imageViewProfile setRoundCornersAsCircle];
    //self.imageViewPost.delegate = self;
  

}


- (void)setUpImagePager {
    
    self.imageViewPost.userInteractionEnabled = YES;
    self.imageViewPost.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    self.imageViewPost.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    
    // pager.slideshowTimeInterval = 3.5f;
    self.imageViewPost.slideshowShouldCallScrollToDelegate = YES;
    self.imageViewPost.delegate = self;
    self.imageViewPost.dataSource = self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    
    return  self.imageArray;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleToFill;
}

- (NSString *) captionForImageAtIndex:(NSUInteger)index inPager:(KIImagePager *)pager
{
    return @"";
}

#pragma mark - KIImagePager Delegate
- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}

- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}





@end
