//
//  WWCameraViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-07-26.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "WWCameraViewController.h"


@interface WWCameraViewController ()

@property(nonatomic ,retain) UILongPressGestureRecognizer *longPressGestureRecognizer;

@property(nonatomic ,retain) AVCaptureVideoPreviewLayer *previewLayer;

@property(nonatomic ,retain) AVCaptureStillImageOutput *imageOutput;

@property(nonatomic ,assign) BOOL isPause;

@property(nonatomic ,assign) BOOL isFlashOn;

@property(nonatomic ,assign) BOOL isRecording;

@property(nonatomic ,retain) AVCaptureSession *session;

@property(nonatomic ,retain) AVCaptureDevice *device;

@property(nonatomic ,retain) NSTimer *timer;

@property(nonatomic ,assign) NSInteger time;


@end

@implementation WWCameraViewController

#pragma mark - Life cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.nextButton addShadow];
    [self.crossButton addShadow];
   // [self.flashButton addShadow];
    [self.cameraButton addShadow];
    [self.switchCameraButton addShadow];
    
    // Do any additional setup after loading the view.

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES];

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

   // [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    
    
    self.progressView.layer.cornerRadius = self.progressView.frame.size.width/2;
    
    if (self.cameraMode == kWPhotoMode) {
     
        [self setUpCamera];
        [self.view bringSubviewToFront:self.switchCameraButton];
        
        [self.view bringSubviewToFront:self.cameraButton];
        
        [self.view bringSubviewToFront:self.crossButton];
        
        [self.cameraButton addTarget:self action:@selector(capturePressed:) forControlEvents:UIControlEventTouchDown];

       // [self.view bringSubviewToFront:self.flashButton];

    }
    else if (self.cameraMode == kWVideoMode) {
        
        
        _previewLayer = [[PBJVision sharedInstance] previewLayer];
        
        _previewLayer.frame = self.view.bounds;
        
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        //[_previewLayer addSublayer:self.timerView.layer];
        
        [self.view.layer addSublayer:_previewLayer];
        [self setupVideo];
        //
        [self.view bringSubviewToFront:self.switchCameraButton];
        
        [self.view bringSubviewToFront:self.cameraButton];
        
        [self.view bringSubviewToFront:self.crossButton];

        [self.view bringSubviewToFront:self.progressView];
        
        
        
        self.nextButton.hidden = YES;
        
        [self.view bringSubviewToFront:self.nextButton];
        // [self.view sendSubviewToBack:self.progressView];

        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapPressed:)];
        
        _longPressGestureRecognizer.numberOfTouchesRequired = 1;
        
        [_longPressGestureRecognizer setCancelsTouchesInView:NO];
        
        [self.cameraButton addGestureRecognizer:_longPressGestureRecognizer];
        
        
        //[self.progressView animateViewWithduration:5 initialValue:0];
        
    }
    

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.progressView removeAnimation];
    self.isRecording = NO;
}

- (BOOL)prefersStatusBarHidden {
    
    return  YES;
}

#pragma mark PBJVison Delegate Methods
- (void)vision:(PBJVision *)vision capturedVideo:(NSDictionary *)videoDict error:(NSError *)error
{
    if (error && [error.domain isEqual:PBJVisionErrorDomain] && error.code == PBJVisionErrorCancelled) {
        NSLog(@"recording session cancelled");
        return;
    } else if (error) {
        NSLog(@"encounted an error in video capture (%@)", error);
        return;
    }
    
    //NSLog(@"Video Recorded");
    //_currentVideo = videoDict;
    
    NSString *videoPath = [videoDict  objectForKey:PBJVisionVideoPathKey];
    NSLog(@"Video Recorded %@",videoPath);
    [[WSetting getSharedSetting] setFrontVideoUrlPath:videoPath];
    
    WWMediaDisplayViewController *mediaDisplayController = [[UIStoryboard getMediaStoryBoard] instantiateViewControllerWithIdentifier:k_SB_MEDIA_DISPLAY_VC];
    
    mediaDisplayController.displayMode = kWShowVideoMode;
    
    __weak typeof(self) weakSelf = self;
    
  //  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [RUUtility generateVideoThumbnail:[NSURL fileURLWithPath:videoPath] success:^(UIImage *image) {
        dispatch_async( dispatch_get_main_queue(), ^{
            // Add code here to update the UI/send notifications based on the
            // results of the background processing
            
            //[MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            mediaDisplayController.filteredImage = image;
           
            [weakSelf.navigationController pushViewController:mediaDisplayController animated:YES];
            
        });

        

    }];
    
  }

#pragma mark - Private Methods
- (void)longTapPressed:(UITapGestureRecognizer*)gesture {
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (!_isRecording) {
                
                [[PBJVision sharedInstance] startVideoCapture];
              //  self.switchCameraButton.enabled = NO;
               // self.flashButton.enabled = NO;
                // NSLog(@"start recording");
                _isRecording = YES;
                [self startTimer];
                [self.progressView animateViewWithduration:60 initialValue:0];
                
                
                
                
            }
            else
                [[PBJVision sharedInstance] resumeVideoCapture];
                [self.progressView resumeAnimation];
            
            //NSLog(@"resume recording");
            
            self.isPause = NO;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            [[PBJVision sharedInstance] pauseVideoCapture];
            [self.progressView pauseAnimation];
            self.isPause = YES;
            //     NSLog(@"pause recording");
            // _isRecording = NO;
            break;
        }
        default:
            break;
    }

}
- (void)startTimer {
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCheck:) userInfo:nil repeats:YES];
    }
}

- (void)timerCheck:(id)sender {
    
    if(!self.isPause) {
        
        
        self.time = self.time+1;
        if(_time == 3) {
            
            self.nextButton.hidden = NO;
        }
//        if (_time<10) {
//            self.labelTime.text = [NSString stringWithFormat:@"0:0%ld", (long)self.time];
//        }
//        else {
//            self.labelTime.text = [NSString stringWithFormat:@"0:%ld",(long)self.time];
//            
//        }
    }
    
}

- (void)setUpCamera {
    
    self.flashButton.hidden = NO;
    //self.viewContainer.hidden = YES;
    self.isFlashOn = NO;
    //Capture Session
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    //Add device
    self.device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    
    //Input
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    if (!input)
    {
        NSLog(@"No Input");
    }
    
    [self.session addInput:input];
    
    //Output
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [self.session addOutput:output];
    output.videoSettings =
    @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
    
    //Preview Layer
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    
    self.previewLayer.frame = self.view.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    //Start capture session
    [self.session startRunning];
    
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    self.imageOutput.outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecKey,AVVideoCodecJPEG, nil];
    if ([_session canAddOutput:self.imageOutput]) {
        [_session addOutput:self.imageOutput];
    }
    
    [self.view bringSubviewToFront:self.flashButton];
}

- (void)setupVideo {
    _longPressGestureRecognizer.enabled = YES;
    //self.viewContainer.hidden = YES;
    //[self rightButtonCanShow:NO];
    
    PBJVision *vision = [PBJVision sharedInstance];
    //vision.captureSessionPreset = AVCaptureSessionPresetHigh;
    vision.delegate = self;
    vision.cameraMode = PBJCameraModeVideo;
    vision.cameraOrientation = PBJCameraOrientationPortrait;
    vision.focusMode = PBJFocusModeContinuousAutoFocus;
    vision.outputFormat = PBJOutputFormatPreset;
    
    NSString *outputFile = [NSString stringWithFormat:@"video_%@.mp4", @"Rear"];
    
    
    NSString *outputDirectory =  NSTemporaryDirectory();
    NSString *outputPath = [outputDirectory stringByAppendingPathComponent:outputFile];
    //vision.outputPath = outputPath;
    [[WSetting getSharedSetting] setFrontVideoUrlPath:outputPath];
    
    vision.outputPath = outputPath;
    [vision startPreview];
    [[PBJVision sharedInstance] setMaximumCaptureDuration:CMTimeMakeWithSeconds(60, 600)]; // ~ 5 seconds
    
    
}

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}


#pragma mark - Public Methods

- (void)flashPressed:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    
    
    AVCaptureInput* currentCameraInput = [self.session.inputs firstObject];
    
    if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack)
    {
        
        Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
        if (captureDeviceClass != nil) {
            
            /// AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            if ([self.device hasTorch] && [self.device hasFlash]){
                
                [self.device lockForConfiguration:nil];
                
                if (self.isFlashOn) {
                    
                    [button setImage:[UIImage imageNamed:@"Image_Flash_Off"] forState:UIControlStateNormal];
                    self.isFlashOn = NO;
                    [self.device setTorchMode:AVCaptureTorchModeOff];
                    [self.device setFlashMode:AVCaptureFlashModeOff];
                    
                }
                else {
                    [button setImage:[UIImage imageNamed:@"Image_Flash_On"] forState:UIControlStateNormal];
                    self.isFlashOn = YES;
                    [self.device setTorchMode:AVCaptureTorchModeOn];
                    [self.device setFlashMode:AVCaptureFlashModeOn];
                }
                [self.device unlockForConfiguration];
            }
        }
    }
    
}
- (IBAction)capturePressed:(id)sender {
    
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in [self.imageOutput connections])
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
        {
            break;
        }
    }
    
    NSLog(@"About to request a capture from: %@", self.imageOutput);
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         
         CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             // Do something with the attachments.
             //NSLog(@"Attachments: %@", exifAttachments);
         }
         else
         {
             NSLog(@"No attachments found.");
             
             
         }
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         [self.session stopRunning];
         //[self.previewLayer removeFromSuperlayer];
      
         WWMediaDisplayViewController *mediaDisplayController = [[UIStoryboard getMediaStoryBoard] instantiateViewControllerWithIdentifier:k_SB_MEDIA_DISPLAY_VC];
         
          image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.1)];
         image = [UIImage resizeImage:image toResolution:480];

       //  imageData = UIImagePNGRepresentation(image);
        // self.capturedImage = image;
        // self.capturedImage = [self.capturedImage fixOrientation];
        // [self updateCameraViewWithImage:image];
         // NSLog(@"Image %@",imageData);
         // [[self vImage] setImage:image];
         
         if (self.isAddImage) {
             
             [[[WSetting getSharedSetting] imageArray] addObject:image];
             //[self.imageArray  addObject:self.selectedImage];
             
         }
         else {
             
             [[[WSetting getSharedSetting] imageArray] replaceObjectAtIndex:self.index withObject:image];
             
         }
         
        mediaDisplayController.displayMode = kWShowImageMode;
       
        mediaDisplayController.selectedImage = image;
         
        mediaDisplayController.selectedIndex = self.index;
         
       //  mediaDisplayController.tempImageArray = [[WSetting getSharedSetting] imageArray];
         
       
         [self.navigationController pushViewController:mediaDisplayController animated:YES];
         
     }];
}

- (void)switchCameraPressed:(id)sender {
    
    if (self.cameraMode == kWVideoMode) {
    PBJVision *vision = [PBJVision sharedInstance];
    if (vision.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
        vision.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    else {
        
        vision.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    
    }
    else {
        
        if(_session)
        {
            //Indicate that some changes will be made to the session
            [self.session beginConfiguration];
            
            //Remove existing input
            AVCaptureInput* currentCameraInput = [self.session.inputs firstObject];
            [self.session removeInput:currentCameraInput];
            
            //Get new input
            AVCaptureDevice *newCamera = nil;
            if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack)
            {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
                [self.flashButton setHidden:YES];
            }
            else
            {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
                [self.flashButton setHidden:NO];
            }
            
            //Add input to session
            NSError *err = nil;
            AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:&err];
            if(!newVideoInput || err)
            {
                NSLog(@"Error creating capture device input: %@", err.localizedDescription);
            }
            else
            {
                [_session addInput:newVideoInput];
            }
            
            //Commit all the configuration changes at once
            [_session commitConfiguration];
        }

    }
    
}
- (void)backPressed:(id)sender {
    
    [self.navigationController.navigationBar setHidden:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextPressed:(id)sender {
    
    [[PBJVision sharedInstance] endVideoCapture];

   

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
