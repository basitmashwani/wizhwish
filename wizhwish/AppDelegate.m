//
//  AppDelegate.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-18.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "AppDelegate.h"
@import Fabric;
@import Crashlytics;
@import AeroGearPush;

//#import <Kickf>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                                UIUserNotificationTypeAlert | UIUserNotificationTypeBadge |
                                                UIUserNotificationTypeSound categories:nil];
        [UIApplication.sharedApplication registerUserNotificationSettings:settings];
       // [[UIApplication sharedApplication] registerForRemoteNotifications];
    
        [Fabric with:@[[Crashlytics class]]];
   
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:k_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (accessToken) {
        
        WZHomeViewController *profileViewController = [[UIStoryboard getHomeStoryBoard] instantiateViewControllerWithIdentifier:K_SB_HOME_VIEW_CONTROLLER];
        [RUUtility setMainRootController:profileViewController];
    }

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

 
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


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    UIApplicationState state = [application applicationState];
    
    
    if (state == UIApplicationStateActive)
    {
        
        NSLog(@"received a notification while active...");
        
    }
    else if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground  )
    {
        //opened from a push notification when the app was on background
        NSLog(@"i received a notification...");
       // NSLog(@"Message: %@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
       // NSLog(@"whole data: %@",userInfo);
    }
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{   
    DeviceRegistration *registration =
        [[DeviceRegistration alloc] initWithServerURL:
         [NSURL URLWithString:@"http://192.168.1.70:8080/ag-push/"]];
    
        [registration registerWithClientInfo:^(id clientInfo) {
    
            // apply the token, to identify this device
            [clientInfo setDeviceToken:deviceToken];
    
            [clientInfo setVariantID:@"59264c58-87d7-40c5-be89-eda980763904"];
            [clientInfo setVariantSecret:@"dc1eb020-c21e-48af-857d-a1f25b2fa69e"];
            [clientInfo setAlias:@"basit@gmail.com"];
    
            // --optional config--
            // set some 'useful' hardware information params
            UIDevice *currentDevice = [UIDevice currentDevice];
            [clientInfo setOperatingSystem:[currentDevice systemName]];
            [clientInfo setOsVersion:[currentDevice systemVersion]];
            [clientInfo setDeviceType: [currentDevice model]];
    
        } success:^() {
            NSLog(@"UPS registration worked");
    
        } failure:^(NSError *error) {
            NSLog(@"UPS registration Error: %@", error);
        }];

}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    NSLog(@"Registering device for push notifications..."); // iOS 8
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)notification completionHandler:(void(^)())completionHandler
{
    NSLog(@"Received push notification: %@, identifier: %@", notification, identifier); // iOS 8 s
    completionHandler();
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // Respond to any push notification registration errors here.
    NSLog(@"Failed to get token, error: %@", error);
}
@end
