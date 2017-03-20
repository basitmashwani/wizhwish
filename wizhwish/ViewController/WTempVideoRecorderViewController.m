//
//  WTempVideoRecorderViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-03-05.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "WTempVideoRecorderViewController.h"

@interface WTempVideoRecorderViewController ()

@property(nonatomic ,retain) UILongPressGestureRecognizer *longPressGestureRecognizer;

@property(nonatomic ,retain) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation WTempVideoRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    _previewLayer = [[PBJVision sharedInstance] previewLayer];

    _previewLayer.frame = self.view.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_previewLayer addSublayer:self.timerView.layer];
    [self.view.layer addSublayer:_previewLayer];
    [self setup];
    [self.view bringSubviewToFront:self.libraryButton];
    
    [self.view bringSubviewToFront:self.switchButton];
    
    [self.view bringSubviewToFront:self.captureButton];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
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
    

[vision startPreview];
[[PBJVision sharedInstance] setMaximumCaptureDuration:CMTimeMakeWithSeconds(5, 600)]; // ~ 5 seconds


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
