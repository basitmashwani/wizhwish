//
//  RUReachabilityManager.h
//  iOSReachabilityTestARC
//
//  Created by Arslan Raza on 05/08/2015.
//
//

#import <Foundation/Foundation.h>
#import "RUOverlayView.h"
#import "RUNavigationActivityView.h"

typedef void (^RUReachabilityStatusChangedBlock)(BOOL isConnected);

@interface RUReachabilityContainer : NSObject

@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, weak) RUNavigationActivityView *activityView;
@property (nonatomic, weak) RUOverlayView *overlayView;
@property (nonatomic, strong) UIView *previousTitleView;
@property (readwrite, nonatomic, copy) RUReachabilityStatusChangedBlock statusChangedBlock;
@end

@interface RUReachabilityManager : NSObject

/**
 Create (for first time only when its called) / get Singleton shared manager object
 */
+ (id)sharedManager;

/**
 Adding a controller to show Activity status in Navigation bar when no internet connection is available 
 @param aController: UIViewController object
 */
- (void)addControllerToShowNetworkStatus:(UIViewController*)aController;

/**
 Adding a controller to show Activity status in Navigation bar when no internet connection is available
 @param aController: UIViewController object
 @param statusChangedBlock: UIViewController object
 */
- (void)addControllerToShowNetworkStatus:(UIViewController*)aController withStatusChangedBlock:(void(^)(BOOL isConnected))statusChangedBlock;

/**
 Removing a Controller for internet connection reachability updates
 @param aController: UIViewController object
 */
- (void)removeControllerToShowNetworkStatus:(UIViewController*)aController;

@end
