//
//  WWCameraViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-07-26.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCustomProgressView.h"

typedef enum {
    kWPhotoMode = 0,
    kWVideoMode
} WWCameraMode;

@interface WWCameraViewController : UIViewController<PBJVisionDelegate>

@property(nonatomic ,retain) IBOutlet UIButton *crossButton;

@property(nonatomic ,retain) IBOutlet UIButton *cameraButton;

@property(nonatomic ,retain) IBOutlet UIButton *flashButton;

@property(nonatomic ,retain) IBOutlet UIButton *switchCameraButton;

@property(nonatomic ,retain) IBOutlet UIButton *nextButton;

@property(nonatomic ,retain) IBOutlet SCustomProgressView *progressView;

@property(nonatomic ,assign)  WWCameraMode cameraMode;

@property(nonatomic ,assign) BOOL isAddImage;

@property(nonatomic ,assign) NSInteger index;


- (IBAction)switchCameraPressed:(id)sender;

- (IBAction)flashPressed:(id)sender;

- (IBAction)backPressed:(id)sender;

- (IBAction)nextPressed:(id)sender;

@end

