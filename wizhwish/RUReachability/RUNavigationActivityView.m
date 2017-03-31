//
//  RUNavigationActivityView.m
//  iOSReachabilityTestARC
//
//  Created by Arslan Raza on 05/08/2015.
//
//

#import "RUNavigationActivityView.h"

@implementation RUNavigationActivityView

#pragma mark - Private Methods

#pragma mark - Life Cycle Methods

+ (RUNavigationActivityView*)createView {
    
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"RUNavigationActivityView" owner:self options:nil];
    RUNavigationActivityView *activityView = [nibs objectAtIndex:0];
    
    if (activityView) {
        
//        [driverAlert setupViews];
//        [driverAlert setAlpha:0];
//        
//        
//        [driverAlert fadeInWithCompletion:nil];
        
    }
    
    return activityView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Public Methods

- (void)setupParentNavigationController:(UIViewController*)aController; {
    if (aController) {
        self.parentController = aController;
        
//        UIViewController *topController = navController.topViewController;
        self.previousTitleView = aController.navigationItem.titleView;
        [aController.navigationItem setTitleView:self];
    }
}

@end
