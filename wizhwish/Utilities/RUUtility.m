//
//  RUUtility.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-20.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//



#import "RUUtility.h"
#import "NSDate+Extras.h"


@implementation RUUtility


+ (void)setMainRootController:(UIViewController*)rootController {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    [UIView
     transitionWithView:window
     duration:0.5
     options:UIViewAnimationOptionTransitionFlipFromLeft
     animations:^(void) {
         BOOL oldState = [UIView areAnimationsEnabled];
         [UIView setAnimationsEnabled:NO];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootController];
         [self setUpNavigationBar:navController];
         [[[[UIApplication sharedApplication] delegate] window] setRootViewController:navController];
         [UIView setAnimationsEnabled:oldState];
     }
     completion:nil];
    
    
}

+ (void)setUpNavigationBar:(UINavigationController*)navController {
    
    [navController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    navController.navigationBar.tintColor = [UIColor whiteColor];
    navController.navigationBar.barTintColor = [UIColor navigationBarColor];
    navController.navigationBar.barStyle = UIBarStyleBlack;

    [navController.navigationItem setTitle:@"Wizh Wish"];
    
}

+ (void)setBackButtonForController:(UIViewController*)Controller withSelector:(SEL)selector {
    
    UIImage *image = [UIImage imageNamed:@"Image_Nav_Back"];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:Controller action:selector];
    [Controller.navigationItem setLeftBarButtonItem:barButton];
}



+ (UIBarButtonItem *)getBarButtonWithTitle:(NSString *)title forViewController:(UIViewController *)viewController selector:(SEL)selector {
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:viewController action:selector];
    
    return barButton;
    
}

+ (UIBarButtonItem *)getBarButtonWithImage:(UIImage *)image forViewController:(UIViewController *)viewController selector:(SEL)selector {
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:viewController action:selector];
    
    return barButton;
    
}


+ (void)openMediaActionSheetFor:(UIViewController*)controller cameraOption:(void(^)(void))camera libraryOption:(void(^)(void))library {
    
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:nil      //  Must be "nil", otherwise a blank title area will appear above our two buttons
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *buttonCancel = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * action)
                                   {
                                       //  UIAlertController will automatically dismiss the view
                                   }];
    
    UIAlertAction *buttonTakePhoto = [UIAlertAction
                                      actionWithTitle:@"Take photo"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action)
                                      {
                                          //  The user tapped on "Take a photo"
                                          //
                                          if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType: completionHandler:)]) {
                                              [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                                                  // Will get here on both iOS 7 & 8 even though camera permissions weren't required
                                                  // until iOS 8. So for iOS 7 permission will always be granted.
                                                  if (granted) {
                                                      // Permission has been granted. Use dispatch_async for any UI updating
                                                      // code because this block may be executed in a thread.
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          camera();
                                                      });
                                                  } else {
                                                      // Permission has been denied.
                                                  }
                                              }];
                                          }
                                      }];
    
    
    UIAlertAction *buttonLibrary = [UIAlertAction
                                    actionWithTitle:@"Choose Existing"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //  The user tapped on "Choose existing"
                                        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                                            if(status == PHAuthorizationStatusAuthorized) {
                                                library();
                                                
                                            }
                                            
                                        }];
    
                                       
                                    }];
    
    [alert addAction:buttonCancel];
    [alert addAction:buttonTakePhoto];
    [alert addAction:buttonLibrary];
    [controller presentViewController:alert animated:YES completion:nil];
    
}

+ (UIImagePickerController*)getImagePickerFor:(KMediaType)mediaType {
    
    UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
    if (mediaType == KMediaCamera) {
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
     
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    
    return imagePickerController;
    
    
    //                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //                                  imagePickerController.delegate = controller;
    //
    return nil;
    
}


+ (void)removeBaseDirectory {
   
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *appSupportDir = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL* dirPath = [[appSupportDir objectAtIndex:0] URLByAppendingPathComponent:@"WhizWish"];
    
    NSError *error;
    BOOL isRemoved = [fm removeItemAtPath:dirPath.path error:&error];
    
    if (isRemoved) {
        NSLog(@"Directory Removed");
    }
    
}
+ (NSString*)getFileURLPathforFileName:(NSString*)fileName withData:(NSData*)data {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *appSupportDir = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL* dirPath = [[appSupportDir objectAtIndex:0] URLByAppendingPathComponent:@"WhizWish"];
    
    NSError*    theError = nil; //error setting
    if (![fm createDirectoryAtURL:dirPath withIntermediateDirectories:YES
                       attributes:nil error:&theError])
    {
        NSLog(@"not created");
        
    }
    
     NSString *filePath = [dirPath.path stringByAppendingPathComponent:fileName];
    
  BOOL status =  [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
    
    if(status) {
        NSLog(@"write file");
    }
    return filePath;

}



@end
