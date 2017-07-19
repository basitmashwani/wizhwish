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

/**
 Write file to Directory
 @param fileName :NSString Instance file name
 @param directoryName :NSString Instance name of directory
 @parm data :NSData of file
 */
+ (NSString*)getFileURLPathforFileName:(NSString*)fileName directoryName:(NSString*)directoryName withData:(NSData*)data;


/**
 Remove Directory
 @param folderName :NSString of directory name
 */
+ (void)removeBaseDirectory:(NSString*)directoryName;


/**
Add text ovelay to video
 @param url :NSSURL Instance url of video
 @param text :NSString Instance text write to video
 @param labelPoint:CGPoint position of text Label
 @param success:success block
 */
+ (void)addTextToVideoWithVideoURL:(NSURL*)url withText:(NSString*)text labelPoint:(CGPoint)labelPoint label:(UILabel*)textLabel success:(void(^)(void))success;



+ (void)addImageToVideoWithVideoURL:(NSURL*)url withImage:(UIImage*)image success:(void(^)(void))success;

+ (void)generateVideoThumbnail:(NSURL*)url success:(void(^)(UIImage *image))success;



@end
