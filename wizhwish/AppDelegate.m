//
//  AppDelegate.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-18.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "AppDelegate.h"
//#import <Kickf>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *secret = @"bNT4?7:RJsJNrOEffRxFDQ:umBFl9@_B:X=1Mm!E_onDhDX1qqDaQDE:u@syWC;2mKtLu3q-GfN7JKm6R:Z1JXtMo2k3PaE3uFkcl-xcYotXDL_IXAcP1_i8xr0wdQ6i";

    [Kickflip setupWithAPIKey:k_KICKFLIP_API_KEY secret:secret];
  //  [Kickflip setMaxBitrate:2000*1000]; // 2 Mbps
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:k_ACCESS_TOKEN];
    if (accessToken) {
        
        WZHomeViewController *profileViewController = [[UIStoryboard getHomeStoryBoard] instantiateViewControllerWithIdentifier:K_SB_HOME_VIEW_CONTROLLER];
        [RUUtility setMainRootController:profileViewController];
    }

 //   [NSLog addLogger:[DDTTYLogger sharedInstance]];
    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
