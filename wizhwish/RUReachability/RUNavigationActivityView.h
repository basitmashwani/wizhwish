//
//  RUNavigationActivityView.h
//  iOSReachabilityTestARC
//
//  Created by Arslan Raza on 05/08/2015.
//
//

#import <UIKit/UIKit.h>

@interface RUNavigationActivityView : UIView

@property (nonatomic, weak) UIViewController *parentController;
@property (nonatomic, strong) UIView *previousTitleView;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


+ (RUNavigationActivityView*)createView;
- (void)setupParentNavigationController:(UIViewController*)aController;

@end
