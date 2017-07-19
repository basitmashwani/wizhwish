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
    navController.navigationBar.barTintColor = [UIColor getLightGrayNavigationColor]; //background colour
    navController.navigationBar.barStyle = UIBarStyleDefault;

    [navController.navigationItem setTitle:@"Wizh Wish"];
    
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor: [UIColor clearColor]];
    [shadow setShadowOffset: CGSizeMake(0.0f, 1.0f)];

    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Jazz LET" size:26],NSFontAttributeName,
      nil]];
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


+ (void)removeBaseDirectory:(NSString*)directoryName {

    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *appSupportDir = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL* dirPath = [[appSupportDir objectAtIndex:0] URLByAppendingPathComponent:directoryName];
    
    NSError *error;
    BOOL isRemoved = [fm removeItemAtPath:dirPath.path error:&error];
    
    if (isRemoved) {
        NSLog(@"Directory Removed");
    }
    
}
+ (NSString*)getFileURLPathforFileName:(NSString*)fileName directoryName:(NSString*)directoryName
  withData:(NSData*)data {

    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *appSupportDir = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL* dirPath = [[appSupportDir objectAtIndex:0] URLByAppendingPathComponent:directoryName];
    
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


+ (void)addImageToVideoWithVideoURL:(NSURL*)url withImage:(UIImage*)image success:(void(^)(void))success


 {
   
     AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:url options:nil];
     
         AVAssetTrack *clipVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
     
     CGSize sizeOfVideo = [clipVideoTrack naturalSize];
     //NSLog(@"sizeOfVideo.width is %f",sizeOfVideo.width);
     //NSLog(@"sizeOfVideo.height is %f",sizeOfVideo.height);
     //TextLayer defines the text they want to add in Video
     
     CALayer *aLayer = [CALayer layer];
     aLayer.contents = (id)image.CGImage;
     
     aLayer.frame = CGRectMake(0, 0, sizeOfVideo.width, sizeOfVideo.height);
    // aLayer.backgroundColor = [[UIColor redColor] CGColor];
     
     CALayer *optionalLayer = [CALayer layer];
     [optionalLayer addSublayer:aLayer];
     optionalLayer.frame=CGRectMake(0, 0, sizeOfVideo.width, sizeOfVideo.height);
     [optionalLayer setMasksToBounds:YES];
     
     [self addOverlayToVideo:optionalLayer sizeOfVideo:sizeOfVideo videoURL:url  success:^{
         success();
     }];
}



+ (void)addTextToVideoWithVideoURL:(NSURL*)url withText:(NSString*)text labelPoint:(CGPoint)labelPoint label:(UILabel*)textLabel success:(void(^)(void))success

{
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:url options:nil];
    
    AVAssetTrack *clipVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    CGSize sizeOfVideo = [clipVideoTrack naturalSize];
    //NSLog(@"sizeOfVideo.width is %f",sizeOfVideo.width);
    //NSLog(@"sizeOfVideo.height is %f",sizeOfVideo.height);
    //TextLayer defines the text they want to add in Video
    
    CATextLayer *textOfvideo = [[CATextLayer alloc] init];
    textOfvideo.string = [NSString stringWithFormat:@"%@",text];//text is shows the text that you want add in video.
    
    
    CGFloat yAxis = 0;
    labelPoint.y = labelPoint.y - 50;
    CGFloat percent = labelPoint.y/textLabel.superview.frame.size.height*100;
    CGFloat newPercent = sizeOfVideo.height/100;
    yAxis = newPercent *percent;
    yAxis = sizeOfVideo.height - yAxis;
    
    
    
    [textOfvideo setFont:(__bridge CFTypeRef)([UIFont fontWithName:[NSString stringWithFormat:@"%s","MicrosoftPhagsPa"] size:6])];//fontUsed is the name of font
    [textOfvideo setFrame:CGRectMake(labelPoint.x , yAxis , sizeOfVideo.width, 60)];
    // [textOfvideo setAlignmentMode:kCAAlignmentCenter];
    [textOfvideo setForegroundColor:[[textLabel textColor] CGColor]];
    
    
    CALayer *optionalLayer = [CALayer layer];
    [optionalLayer addSublayer:textOfvideo];
    optionalLayer.frame=CGRectMake(0, 0, sizeOfVideo.width, sizeOfVideo.height);
    [optionalLayer setMasksToBounds:YES];
    
    [self addOverlayToVideo:optionalLayer sizeOfVideo:sizeOfVideo videoURL:url success:^{
        success();
    }];
    
   }


+ (void)addOverlayToVideo:(CALayer*)layer sizeOfVideo:(CGSize)size videoURL:(NSURL*)url success:(void(^)(void))success  {
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:url options:nil];
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *clipVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *clipAudioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    //If you need audio as well add the Asset Track for audio here
    
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:clipVideoTrack atTime:kCMTimeZero error:nil];
    
    [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:clipAudioTrack atTime:kCMTimeZero error:nil];
    
    [compositionVideoTrack setPreferredTransform:[[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] preferredTransform]];
    
    CALayer *parentLayer=[CALayer layer];
    CALayer *videoLayer=[CALayer layer];
    parentLayer.frame=CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame=CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:layer];
    
    AVMutableVideoComposition *videoComposition=[AVMutableVideoComposition videoComposition] ;
    videoComposition.frameDuration = CMTimeMake(1, 10);
    videoComposition.renderSize = size;
    videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mixComposition duration]);
    AVAssetTrack *videoTrack = [[mixComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/utput_%@.mov", [dateFormatter stringFromDate:[NSDate date]]];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    exportSession.videoComposition=videoComposition;
    
    exportSession.outputURL = [NSURL fileURLWithPath:destinationPath];
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch (exportSession.status)
        {
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"Export OK");
                [[WSetting getSharedSetting] setFirstOutputUrl:destinationPath];
                success();
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportSession.error);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export Cancelled");
                break;
                
             case AVAssetExportSessionStatusUnknown:
                NSLog(@"Session unknow");
                break;
            
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"wating session");
                break;
            
            case AVAssetExportSessionStatusExporting:
                NSLog(@"Exporting");
                break;
        }
    }];

}

+ (void)generateVideoThumbnail:(NSURL*)url success:(void(^)(UIImage *image))success

{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
    CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
    
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result != AVAssetImageGeneratorSucceeded) {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
        }
        UIImage *image = [UIImage imageWithCGImage:im];
        image = [UIImage resizeImage:image toResolution:480];
        success(image);
       // [button setImage:[UIImage imageWithCGImage:im] forState:UIControlStateNormal];
       // ..thumbImg=[[UIImage imageWithCGImage:im] ];
    };
    
    CGSize maxSize = CGSizeMake(320, 180);
    generator.maximumSize = maxSize;
    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    
}



@end
