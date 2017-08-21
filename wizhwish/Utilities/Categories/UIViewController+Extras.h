//
//  UIViewController+Extras.h
//  Yatter
//
//  Created by Syed Abdul Basit on 2016-03-22.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extras)

//- (void)toggleSlideBarLeft;
//- (void)toggleSlideBarRight;
- (void)swapFromViewController:(UIViewController *)fromViewController
              toViewController:(UIViewController *)toViewController
                    completion:(void (^)(BOOL finished))completion;

- (void)swapToViewController:(UIViewController *)toViewController
                  completion:(void (^)(BOOL finished))completion;

- (void)didTappedView:(UIView*)view;

- (void)backPressed;
- (UIViewController *)backViewController;


@end
