//
//  RUReachabilityManager.m
//  iOSReachabilityTestARC
//
//  Created by Arslan Raza on 05/08/2015.
//
//

#import "RUReachabilityManager.h"
#import "RUReachability.h"

#pragma mark - RUReachabilityContainer Implementation

@implementation RUReachabilityContainer



@end

#pragma mark - RUReachabilityManager Implementation


@interface RUReachabilityManager ()

@property(strong) RUReachability * googleReach;
@property(strong) RUReachability * localWiFiReach;
@property(strong) RUReachability * internetConnectionReach;
@property(strong) RUOverlayView * overlayView;

@property (nonatomic, strong) NSMutableArray *containers;

@end

@implementation RUReachabilityManager

static RUReachabilityManager *_sharedInstance = nil;

#pragma mark - Private Methods

- (RUOverlayView*)addOverLayViewForController:(UIViewController*)controller {
    if (controller) {
        RUOverlayView *overlay = [RUOverlayView showOnView:controller.view];
        return overlay;
    }
    return nil;
}

- (void)updateNavigationBarTitleForReachabilityStatus:(BOOL)isConnected {
    
    __weak __block typeof(self) weakself = self;
    
    if (!isConnected) {
        
        [self.containers enumerateObjectsUsingBlock:^(RUReachabilityContainer *singleContainer, NSUInteger idx, BOOL *stop) {
            UIViewController *controller = singleContainer.controller;
            
            if (controller) {
                if (!singleContainer.activityView) {
                    
                    NSLog(@"Adding Activity View for Controller: %@", controller);
                    // 1- Storing Previous Title View
                    singleContainer.previousTitleView = controller.navigationItem.titleView;
                    
                    // 2 - Creating and Setting Waiting for Network Title View
                    RUNavigationActivityView *activityView = [RUNavigationActivityView createView];
                    singleContainer.activityView = activityView;
                    [controller.navigationItem setTitleView:activityView];
                    
                    // 3 - Creating and Setting Overlay View to disable interaction
                    RUOverlayView *overlay = [weakself addOverLayViewForController:controller];
                    singleContainer.overlayView = overlay;
                    
                    // 4 - Updating Status Change Block
                    if (singleContainer.statusChangedBlock) {
                        singleContainer.statusChangedBlock(NO);
                    }
                }
            } else {
                NSLog(@"Controller {%@} is nil. Removing its container", controller);
                [weakself.containers removeObject:singleContainer];
            }
            
        }];
        
    } else {
        
        [self.containers enumerateObjectsUsingBlock:^(RUReachabilityContainer *singleContainer, NSUInteger idx, BOOL *stop) {
            UIViewController *controller = singleContainer.controller;
            if (controller) {
                if (singleContainer.activityView) {
                    NSLog(@"Removing Activity View for Controller: %@", controller);
                    controller.navigationItem.titleView = singleContainer.previousTitleView;
                    singleContainer.activityView = nil;
                    [singleContainer.overlayView removeFromSuperview];
                    singleContainer.overlayView = nil;
                    
                    if (singleContainer.statusChangedBlock) {
                        singleContainer.statusChangedBlock(YES);
                    }
                }
            }
        }];
    }
}

- (void)setupReachability {
    
    __weak __block typeof(self) weakself = self;
    
    //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    //
    // create a Reachability object for www.google.com
    
    self.googleReach = [RUReachability reachabilityWithHostname:@"www.google.com"];
    
    
    
    self.googleReach.reachableBlock = ^(RUReachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"GOOGLE Block Says Reachable(%@)", reachability.currentReachabilityString];
        NSLog(@"%@", temp);
        
        // to update UI components from a block callback
        // you need to dipatch this to the main thread
        // this uses NSOperationQueue mainQueue
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakself updateNavigationBarTitleForReachabilityStatus:YES];
        }];
    };
    
    self.googleReach.unreachableBlock = ^(RUReachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"GOOGLE Block Says Unreachable(%@)", reachability.currentReachabilityString];
        NSLog(@"%@", temp);
        
        // to update UI components from a block callback
        // you need to dipatch this to the main thread
        // this one uses dispatch_async they do the same thing (as above)
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself updateNavigationBarTitleForReachabilityStatus:NO];
        });
    };
    
    [self.googleReach startNotifier];
    
    /*
     //////////////////////////////////////////////////////////////////////
     //////////////////////////////////////////////////////////////////////
     //
     // create a reachability for the local WiFi
     
     self.localWiFiReach = [RUReachability reachabilityForLocalWiFi];
     
     // we ONLY want to be reachable on WIFI - cellular is NOT an acceptable connectivity
     self.localWiFiReach.reachableOnWWAN = NO;
     
     self.localWiFiReach.reachableBlock = ^(RUReachability * reachability)
     {
     NSString * temp = [NSString stringWithFormat:@"LocalWIFI Block Says Reachable(%@)", reachability.currentReachabilityString];
     NSLog(@"%@", temp);
     
     dispatch_async(dispatch_get_main_queue(), ^{
     weakself.localWifiblockLabel.text = temp;
     weakself.localWifiblockLabel.textColor = [UIColor blackColor];
     });
     };
     
     self.localWiFiReach.unreachableBlock = ^(RUReachability * reachability)
     {
     NSString * temp = [NSString stringWithFormat:@"LocalWIFI Block Says Unreachable(%@)", reachability.currentReachabilityString];
     
     NSLog(@"%@", temp);
     dispatch_async(dispatch_get_main_queue(), ^{
     weakself.localWifiblockLabel.text = temp;
     weakself.localWifiblockLabel.textColor = [UIColor redColor];
     });
     };
     
     [self.localWiFiReach startNotifier];
     
     */
    
    //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    //
    // create a Reachability object for the internet
    
    self.internetConnectionReach = [RUReachability reachabilityForInternetConnection];
    
    self.internetConnectionReach.reachableBlock = ^(RUReachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@" InternetConnection Says Reachable(%@)", reachability.currentReachabilityString];
        NSLog(@"%@", temp);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself updateNavigationBarTitleForReachabilityStatus:YES];
        });
    };
    
    self.internetConnectionReach.unreachableBlock = ^(RUReachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"InternetConnection Block Says Unreachable(%@)", reachability.currentReachabilityString];
        
        NSLog(@"%@", temp);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself updateNavigationBarTitleForReachabilityStatus:NO];
        });
    };
    
    [self.internetConnectionReach startNotifier];
}

- (BOOL)checkIfControllerAlreadyAdded:(UIViewController*)aController {
    
    __block BOOL result = NO;
    [self.containers enumerateObjectsUsingBlock:^(RUReachabilityContainer *container, NSUInteger idx, BOOL *stop) {
        if (container.controller == aController) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

#pragma mark - Life Cycle Methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.containers = [NSMutableArray array];
        [self setupReachability];
        
    }
    return self;
}

+ (id)sharedManager {
    
    if (!_sharedInstance) {
        _sharedInstance = [[RUReachabilityManager alloc] init];
    }
    return _sharedInstance;
}

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.containers = nil;
}

#pragma mark - Public Methods

- (void)addControllerToShowNetworkStatus:(UIViewController*)aController withStatusChangedBlock:(void(^)(BOOL isConnected))statusChangedBlock {
    if (aController) {
        if (![self checkIfControllerAlreadyAdded:aController]) {
            NSLog(@"Controller Does not exist. Adding New Container");
            // Controller Does not exist. Creating a container for this controller
            
            RUReachabilityContainer *container = [[RUReachabilityContainer alloc] init];
            container.controller = aController;
            container.statusChangedBlock = statusChangedBlock;
            
            [self.containers addObject:container];
            
        } else {
            // Controller Already Added for Network Status Updates
            NSLog(@"Controller already exist in Containers");
            
        }
    }
}

- (void)addControllerToShowNetworkStatus:(UIViewController*)aController {
    
    [self addControllerToShowNetworkStatus:aController withStatusChangedBlock:nil];
    
}

- (void)removeControllerToShowNetworkStatus:(UIViewController*)aController {
    
    if (aController) {
        
        __weak __block typeof(self) weakself = self;
        [self.containers enumerateObjectsUsingBlock:^(RUReachabilityContainer *container, NSUInteger idx, BOOL *stop) {
            if (container.controller == aController) {
                [weakself.containers removeObject:aController];
            }
        }];
    }
    
}

@end
