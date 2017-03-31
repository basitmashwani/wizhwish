//
//  RUUtility.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-20.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//


typedef enum {
    KMediaCamera = 0,
    KMediaLibrary
} KMediaType;

#import <Foundation/Foundation.h>
#import "WZPost.h"


@interface RUUtility : NSObject


/**
 Set Main Window Root Controller with Flip Animation
 @param rootController: UIViewController instance
 */
+ (void)setMainRootController:(UIViewController*)rootController;

/**
Set up Navigation Bar colour and titles
 @param navController: UINavigationViewController instance
 */

+ (void)setUpNavigationBar:(UINavigationController*)navController;

/**
Set Back Button to Navigation Bar
 @param controller:UIViewController Instance
 @parm selector:Selector for Button

 */
+ (void)setBackButtonForController:(UIViewController*)Controller withSelector:(SEL)selector;


/**
get UIBarButton Instance
 @param title:NSString title for Button
 @parm selector:Selector For Button
 
 */


+ (UIBarButtonItem*)getBarButtonWithTitle:(NSString*)title forViewController:(UIViewController*)viewController selector:(SEL)selector;

/**
 get UIBarButton Instance
 @param image:UIImage image for Button
 @parm selector:Selector For Button
 
 */



+ (UIBarButtonItem *)getBarButtonWithImage:(UIImage *)image forViewController:(UIViewController *)viewController selector:(SEL)selector;

/**
 Open ActionSheet for Camera and Librar Instance
 @param controller :UIViewController Instance
 @parm camera :camera block
 @parm library :library block
 
 */
+ (void)openMediaActionSheetFor:(UIViewController*)controller cameraOption:(void(^)(void))camera libraryOption:(void(^)(void))library;


/**
 Get UIImagePickerController Instance
 @param mediaType :KMediaType Instance
 **/

+ (UIImagePickerController*)getImagePickerFor:(KMediaType)mediaType;




@end
