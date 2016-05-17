//
//  UIViewController+Extras.m
//  Yatter
//
//  Created by Syed Abdul Basit on 2016-03-22.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "UIViewController+Extras.h"

@implementation UIViewController (Extras)



- (void)viewTapped:(id)sender {
    
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer*)sender;
    [gesture.view endEditing:YES];
}

- (void)swapFromViewController:(UIViewController *)fromViewController
              toViewController:(UIViewController *)toViewController
                    completion:(void (^)(BOOL finished))completion
{
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.childViewControllers.count > 0 && fromViewController) {
        toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [fromViewController willMoveToParentViewController:nil];
        [self addChildViewController:toViewController];
        __weak typeof (self) weakSelf = self;
        [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
            [fromViewController removeFromParentViewController];
            [toViewController didMoveToParentViewController:weakSelf];
          //  completion(finished);
        }];
    } else if (toViewController) {
        // If this is the very first time we're loading this we need to do
        // an initial load and not a swap.
        [self addChildViewController:toViewController];
        UIView* destView = (toViewController).view;
        destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:destView];
       // [destView setAlpha:0];
        [toViewController didMoveToParentViewController:self];
        //[UIView animateWithDuration:0.0 animations:^{
         //   [destView setAlpha:0.0];
        //    completion(YES);
        //}];
        
    } else {
        completion(false);
    }
}

- (void)swapToViewController:(UIViewController *)toViewController
                  completion:(void (^)(BOOL finished))completion {
    if (self.childViewControllers.count > 0) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:toViewController completion:completion];
    }
    else {
        [self swapFromViewController:nil toViewController:toViewController completion:completion];
    }
}


- (void)didTappedView:(UIView *)view {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGesture.cancelsTouchesInView = YES;
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)backPressed {
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}





@end
