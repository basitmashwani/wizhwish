//
//  WVideoRecordViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-09-11.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WVideoRecordViewController.h"
#import "UIImage+FiltrrCompositions.h"
#import "UIImage+Scale.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <SCVideoPlayerView.h>
#import <SCAssetExportSession.h>
#import "NSURL+SCSaveToCameraRoll.h"


@import AVKit;

@interface WVideoRecordViewController ()<PBJVisionDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ACEDrawingViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SCPlayerDelegate>

@property(nonatomic ,retain) UILongPressGestureRecognizer *longPressGestureRecognizer;

@property(nonatomic ,retain) AVCaptureVideoPreviewLayer *previewLayer;

@property(nonatomic) BOOL isRecording;

@property(nonatomic) NSInteger time;

@property(nonatomic ,retain) NSTimer *timer;

@property(nonatomic) BOOL secondVideo;

@property(nonatomic ,retain) NSString *firstVideoPath;

@property(nonatomic ,retain) AVPlayerViewController *videoPlayer;

@property(nonatomic ,retain) NSMutableArray *filterArray;

@property(nonatomic ,retain) ACEDrawingView *drawingView;

@property(nonatomic ,retain) UIButton *eraseButton;

@property(nonatomic ,retain) UIImage *imagePencilCapture;

@property(nonatomic ,retain) HRColorMapView  *colorPicker;

@property(nonatomic) CGPoint  labelPoint;

@property(nonatomic ,retain) UIView *overlayView;

@property(nonatomic ,retain) UIImageView *pencilImageView;

@property(nonatomic ,retain)  UIPanGestureRecognizer *panGesture;

@property(nonatomic ,retain)  UITapGestureRecognizer *tapGesture;

@property(nonatomic )  BOOL isUsingLibrary;

@property(nonatomic ,retain) SCSwipeableFilterView *swipeFilterView;

@property(nonatomic ,retain) SCSwipeableFilterView *miniSwipeFilterView;

@property(nonatomic ,retain) SCPlayer *scPlayer;

@property(nonatomic ,retain) SCPlayer *scMiniPlayer;

@property(nonatomic ,retain) UIImageView *playImageView;

@property(nonatomic ,retain) UIButton *playButton;

@property(nonatomic) BOOL isPause;

@property(nonatomic) BOOL isnextPressed;




@end

@implementation WVideoRecordViewController

#pragma mark Public Methods


- (IBAction)erasePressed:(id)sender {
 
    if ([self.drawingView canUndo]) {
        [self.drawingView undoLatestStep];
        if (![self.drawingView canUndo]) {
            self.eraseButton.hidden = YES;
        }
        self.imagePencilCapture  = [self.drawingView image];
    }
}
- (void)soundPressed:(id)sender {
    
    self.soundButton.selected = YES;
    self.pencilButton.selected = NO;
    self.textPencil.selected = NO;
    self.filterPencil.selected = NO;
    [self.view sendSubviewToBack:self.drawingView];
    self.colorPicker.hidden = YES;
    
    [self addPencilWorkToView];
    self.collectionView.hidden = YES;
    
}

- (void)pencilPressed:(id)sender {
    
    
    self.soundButton.selected = NO;
    self.pencilButton.selected = YES;
    self.textPencil.selected = NO;
    self.filterPencil.selected = NO;
    if (!self.drawingView) {
        self.drawingView = [[ACEDrawingView alloc] initWithFrame:self.cameraView.frame];
        [self.view addSubview:self.drawingView];

    }
    [self.view bringSubviewToFront:self.drawingView];
    self.drawingView.delegate = self;
    self.drawingView.lineWidth  = 3.0;
    self.drawingView.lineColor = [UIColor whiteColor];
    
    if (!self.colorPicker) {
    
     self.colorPicker = [HRColorMapView colorMapWithFrame:self.viewContainer.frame saturationUpperLimit:0.95];
                                 self.colorPicker.tileSize = [NSNumber numberWithInt:16];
    [self.view addSubview:self.colorPicker];
    }
    [self.drawingView loadImage:self.imagePencilCapture];
    self.colorPicker.hidden = NO;
    [self.colorPicker setFrameHeight:80];
    self.colorPicker.color = [UIColor whiteColor];
    [self.colorPicker addTarget:self action:@selector(colorChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.pencilImageView.hidden = YES;
   
}
- (void)colorChanged:(id)sender {
    HRColorMapView *colorMap = (HRColorMapView*)sender;
    self.drawingView.lineColor = colorMap.color;
}

- (void)filterPressed:(id)sender {
    
   
    self.soundButton.selected = NO;
    self.pencilButton.selected = NO;
    self.textPencil.selected = NO;
    self.filterPencil.selected = YES;
    self.colorPicker.hidden = YES;
    [self.textLabel setUserInteractionEnabled:NO];
    [self.view sendSubviewToBack:self.drawingView];
    self.collectionView.hidden = NO;
    [self.collectionView reloadData];
    [self addPencilWorkToView];
}

- (void)textPressed:(id)sender {
 
    
    self.soundButton.selected = NO;
    self.pencilButton.selected = NO;
    self.textPencil.selected = YES;
    self.filterPencil.selected = NO;
    //[self.drawingView removeFromSuperview];
    
    [self.view sendSubviewToBack:self.drawingView];
    self.textField.placeholder = @"Enter Text";
    self.textField.delegate = self;
    self.textField.textColor = [UIColor whiteColor];
    [self.textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.textField.backgroundColor = [UIColor clearColor];
    [self addPencilWorkToView];
       self.textField.textAlignment = NSTextAlignmentCenter;
    
   self.overlayView  = [[UIView alloc] initWithFrame:self.cameraView.frame];
    self.overlayView.backgroundColor = [UIColor grayColor];
    self.overlayView.alpha = 0.3;
    [self didTappedView:self.overlayView];

    self.textField.hidden = NO;
    [self.textField becomeFirstResponder];
    [self.view addSubview:self.overlayView];
    [self.view bringSubviewToFront:self.textField];
    self.textLabel.hidden = YES;
    [self.textLabel setUserInteractionEnabled:YES];
}

- (void)tempButtonPressed:(id)sender {
    
    self.timerView.hidden = YES;
    WTempVideoRecorderViewController *tempController = [[UIStoryboard getMediaStoryBoard] instantiateViewControllerWithIdentifier:K_SB_TEMP_VIDEO_VIEW_CONTROLLER];
    [self.navigationController pushViewController:tempController animated:YES];
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
            [self rightButtonCanShow:YES];
        }
        if (_time<10) {
            self.labelTime.text = [NSString stringWithFormat:@"0:0%ld", (long)self.time];
        }
        else {
            self.labelTime.text = [NSString stringWithFormat:@"0:%ld",(long)self.time];

        }
    }

}

- (void)updateViewForPlayerMode {
    
    
    self.time = 0;
    self.labelTime.text = @"0:00";
  //  [self rightButtonCanShow:NO];

    [self.previewLayer removeFromSuperlayer];
    self.cameraView.backgroundColor = [UIColor blackColor];
    
    [self.cameraView.layer addSublayer:self.timerView.layer];
   
    NSURL *videoURL   = [NSURL fileURLWithPath:[[WSetting getSharedSetting] rearVideoUrlPath]];
    if (self.secondVideo) {
        
        self.buttonAddVideo.hidden = YES;

        NSURL *secondVideoURL = [NSURL fileURLWithPath:[[WSetting getSharedSetting] frontVideoUrlPath]];
        
        [self.collectionView reloadData];
    
    // _videoPlayer = [[AVPlayerViewController alloc] init];
        _scMiniPlayer = [SCPlayer playerWithURL:secondVideoURL];
        _scMiniPlayer.delegate = self;
        self.miniSwipeFilterView = [[SCSwipeableFilterView alloc] initWithFrame:self.buttonAddVideo.frame];
     //   [self.swipeFilterView setFrameX:0.0];
       // [self.swipeFilterView setFrameY:0.0];
        [self.view addSubview:self.miniSwipeFilterView];
        [self.view bringSubviewToFront:self.miniSwipeFilterView];
        
            self.miniSwipeFilterView.contentMode = UIViewContentModeScaleAspectFill;
            
            SCFilter *emptyFilter = [SCFilter emptyFilter];
            emptyFilter.name = @"#nofilter";
            
            self.miniSwipeFilterView.filters = [[NSArray alloc] init];
            self.miniSwipeFilterView.filters = @[
                                             emptyFilter,
                                             [SCFilter filterWithCIFilterName:@"CIPhotoEffectNoir"],
                                             [SCFilter filterWithCIFilterName:@"CIPhotoEffectChrome"],
                                             [SCFilter filterWithCIFilterName:@"CIPhotoEffectInstant"],
                                             [SCFilter filterWithCIFilterName:@"CIPhotoEffectTonal"],
                                             [SCFilter filterWithCIFilterName:@"CIPhotoEffectFade"],
                                             [self createAnimatedFilter]
                                             // Adding a filter created using CoreImageShop
                                             // [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"a_filter" withExtension:@"cisf"]],
                                             ];
            _scMiniPlayer.SCImageView = self.miniSwipeFilterView;
            [self.miniSwipeFilterView addObserver:self forKeyPath:@"selectedFilter" options:NSKeyValueObservingOptionNew context:nil];
            
        
       }
    
    
    _scPlayer = [SCPlayer playerWithURL:videoURL];
    _scPlayer.delegate = self;
    //NSURL *url = [[NSBundle mainBundle] URLForResource:@"splash2" withExtension:@"mp4"];
    
    self.swipeFilterView = [[SCSwipeableFilterView alloc] initWithFrame:self.cameraView.frame];
    [self.swipeFilterView setFrameX:0.0];
    [self.swipeFilterView setFrameY:0.0];
    [self.cameraView addSubview:self.swipeFilterView];
    
    _playImageView = [[UIImageView alloc] init];
    [_playImageView setFrameHeight:60];
    [_playImageView setFrameWidth:60];
    _playImageView.center = CGPointMake(self.swipeFilterView.frame.size.width  / 2,
                                     self.swipeFilterView.frame.size.height / 2);

    _playImageView.image = [UIImage imageNamed:@"Image_Play"];
    
    
    [self.swipeFilterView addSubview:_playImageView];
    
     _playButton  = [[UIButton alloc] initWithFrame:_playImageView.frame];
    [_playButton setFrameWidth:100];
    [_playButton setFrameHeight:100];
    [self.swipeFilterView addSubview:_playButton];
    [_playButton addTarget:self action:@selector(playPressed:) forControlEvents:UIControlEventTouchUpInside];

        self.swipeFilterView.contentMode = UIViewContentModeScaleAspectFill;
        
        SCFilter *emptyFilter = [SCFilter emptyFilter];
        emptyFilter.name = @"#nofilter";
        
        self.swipeFilterView.filters = [[NSArray alloc] init];
        self.swipeFilterView.filters = @[
                                         emptyFilter,
                                         [SCFilter filterWithCIFilterName:@"CIPhotoEffectNoir"],
                                         [SCFilter filterWithCIFilterName:@"CIPhotoEffectChrome"],
                                         [SCFilter filterWithCIFilterName:@"CIPhotoEffectInstant"],
                                         [SCFilter filterWithCIFilterName:@"CIPhotoEffectTonal"],
                                         [SCFilter filterWithCIFilterName:@"CIPhotoEffectFade"],
                                         [self createAnimatedFilter]
                                         // Adding a filter created using CoreImageShop
                                        // [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"a_filter" withExtension:@"cisf"]],
                                         ];
        _scPlayer.SCImageView = self.swipeFilterView;
        [self.swipeFilterView addObserver:self forKeyPath:@"selectedFilter" options:NSKeyValueObservingOptionNew context:nil];
    
    if (!self.secondVideo) {
        
        self.buttonAddVideo.hidden = NO;
        [self.view bringSubviewToFront:self.buttonAddVideo];
        self.sliderSmallScreen.hidden = YES;
        self.labelSmall.hidden = YES;
        self.sliderLargeScreen.center = CGPointMake(self.sliderLargeScreen.center.x, self.sliderLargeScreen.center.y+10);
        
        self.labelLarge.center = CGPointMake(self.labelLarge.center.x, self.labelLarge.center.y+10);
        
    }
    else {
        [self.view bringSubviewToFront:_videoPlayer.view];
        self.sliderSmallScreen.hidden = NO;
        self.labelSmall.hidden = NO;
        
        self.sliderLargeScreen.center = CGPointMake(self.sliderLargeScreen.center.x, self.sliderLargeScreen.center.y-10);
        
        self.labelLarge.center = CGPointMake(self.labelLarge.center.x, self.labelLarge.center.y-10);
        

    }
    self.viewContainer.hidden = NO;



 }

- (void)didVideoPlayFinish {
 
    NSLog(@"Finish");
}
- (IBAction)addSecondVideoPressed:(id)sender {
    
    self.secondVideo = YES;
  //  [self.vkMediaPlayer.view removeFromSuperview];
   // [self.vkMediaPlayer removeFromParentViewController];
    _previewLayer.frame = self.cameraView.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_previewLayer addSublayer:self.timerView.layer];
    [self.cameraView.layer addSublayer:_previewLayer];
    [self.view bringSubviewToFront:self.cameraView];
    [self setup];
    [self.buttonAddVideo setHidden:YES];
    
}
- (void)crossPressed {
 
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextPressed {
    
    if (self.isnextPressed) {
        
//        WWizhViewController *controller =  [[UIStoryboard getWhizStoryBoard] instantiateViewControllerWithIdentifier:K_SB_WIZH_VIEW_CONTROLLER];
//        
//        [self.navigationController pushViewController:controller animated:YES];
        
       // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //Save video
        
        NSString *firstFilePath = [[WSetting getSharedSetting] rearVideoUrlPath];
        NSString *firstOutputPath = [self getOutputPathfor:@"Rear"];

        
            
        NSURL *url = [NSURL fileURLWithPath:firstFilePath];
        [self addTextToVideoWithVideoURL:url withText:self.textLabel.text];
        
        //End
        
        
    }
    else {
    
        [[PBJVision sharedInstance] endVideoCapture];
        self.isRecording = NO;
        self.libraryButton.enabled = YES;
        self.switchButton.enabled = YES;
       // [self updateViewForPlayerMode];
        self.isnextPressed = YES;
    }
    
}

- (void)switchCameraPressed:(id)sender {
    PBJVision *vision = [PBJVision sharedInstance];
    if (vision.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
        vision.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    else {
        
        vision.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    
}

- (void)libraryPressed:(id)sender {
 
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    imagePicker.videoMaximumDuration = 60.0f; // 30 seconds
    //temporary duation of 30 seconds for testing
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)rightButtonCanShow:(BOOL)show {
    
    if (show) {
        self.navigationItem.rightBarButtonItem =  [RUUtility getBarButtonWithImage:[UIImage imageNamed:@"Image_Next"] forViewController:self selector:@selector(nextPressed)];
        
    }
    else{
        
        self.navigationItem.rightBarButtonItem = nil;
    }
}


#pragma mark Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.labelPoint = self.textLabel.center;
    self.timerView.hidden = NO;
    [self.recordButton setRoundCornersAsCircle];
//    [self.progressView setRoundCornersAsCircle];
    
    self.soundButton.selected = YES;
    self.time = 0;
    self.collectionView.hidden = YES;
    self.labelTime.text = @"0:00";
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressed:)];
    _longPressGestureRecognizer.numberOfTouchesRequired = 1;
    [_longPressGestureRecognizer setCancelsTouchesInView:NO];
    [self.recordButton addGestureRecognizer:_longPressGestureRecognizer];
    
    
   self.navigationItem.leftBarButtonItem =  [RUUtility getBarButtonWithImage:[UIImage imageNamed:@"Image_Cross"] forViewController:self selector:@selector(crossPressed)];
    self.viewContainer.hidden = YES;
    
     self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(labelChange:)];
    [self.textLabel setUserInteractionEnabled:YES];
    _panGesture.cancelsTouchesInView = NO;
    [self.textLabel addGestureRecognizer:_panGesture];
    
     self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelPressed:)];
    _tapGesture.numberOfTapsRequired = 1;
    _tapGesture.cancelsTouchesInView = NO;
    [self.textLabel addGestureRecognizer:_tapGesture];
    

}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if (!CGPointEqualToPoint(self.labelPoint, CGPointZero)) {
        
   // self.textLabel.center = self.labelPoint;
    }
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
//    if (!self) {
        self = [super initWithCoder:aDecoder];
//        
//    }
    self.filterArray = [[NSMutableArray alloc] init];
    
   // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
   //     // do some task
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        SCFilter *filter = nil;
        for (int i = 0; i<7; i++) {
            
            UIImage *image = [UIImage imageNamed:@"Image_Filter_Sample"];
            NSData *data = UIImageJPEGRepresentation(image, 0.8);
            CIImage *ciImage = [CIImage imageWithData:data];
            CIImage *processedImage = nil;
            
            switch (i) {
                    
                case 0:
               filter = [SCFilter emptyFilter];
              processedImage = [filter imageByProcessingImage:ciImage];
            [self.filterArray addObject:processedImage];
                    
                    break;
                case 1:
                    filter = [SCFilter filterWithCIFilterName:@"CIPhotoEffectNoir"];
                     processedImage = [filter imageByProcessingImage:ciImage];
                    [self.filterArray addObject:processedImage];

                    break;
                    
                case 2:
                    filter = [SCFilter filterWithCIFilterName:@"CIPhotoEffectChrome"];
                    processedImage = [filter imageByProcessingImage:ciImage];
                    [self.filterArray addObject:processedImage];

                    break;
                    
                case 3:
                    filter = [SCFilter filterWithCIFilterName:@"CIPhotoEffectInstant"];
                    processedImage = [filter imageByProcessingImage:ciImage];
                    [self.filterArray addObject:processedImage];

                    break;
                    
                case 4:
                    filter = [SCFilter filterWithCIFilterName:@"CIPhotoEffectTonal"];
                    
                    processedImage = [filter imageByProcessingImage:ciImage];
                    [self.filterArray addObject:processedImage];

                    break;
                    
                case 5:
                    filter = [SCFilter filterWithCIFilterName:@"CIPhotoEffectFade"];
                    processedImage = [filter imageByProcessingImage:ciImage];
                    [self.filterArray addObject:processedImage];

                    break;
                    
                case 6:
                    filter = [self createAnimatedFilter];
                    processedImage = [filter imageByProcessingImage:ciImage];
                    [self.filterArray addObject:processedImage];

                    break;
                    
                    default:
                    break;
            }
        }

        
    });
   
        return  self;
}

- (SCFilter*)getFilterForIndex:(NSInteger)index {
    
    SCFilter *filter = nil;
    switch (index) {
            
        case 0:
            filter = [SCFilter emptyFilter];
            break;
        case 1:
            filter = [SCFilter filterWithCIFilterName:@"CIPhotoEffectNoir"];
            break;
            
        case 2:
            filter = [SCFilter filterWithCIFilterName:@"CIPhotoEffectChrome"];
            break;
            
        case 3:
            filter = [SCFilter filterWithCIFilterName:@"CIPhotoEffectInstant"];
            break;
            
        case 4:
            filter = [SCFilter filterWithCIFilterName:@"CIPhotoEffectTonal"];
            break;
            
        case 5:
            filter = [SCFilter filterWithCIFilterName:@"CIPhotoEffectFade"];
            break;
            
        case 6:
            filter = [self createAnimatedFilter];
            break;
            
        default:
            break;
    }
    
    return filter;

}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    if (!self.isUsingLibrary) {
        
    
    _previewLayer = [[PBJVision sharedInstance] previewLayer];
    //    _previewLayer.affineTransform = CGAffineTransformMakeScale(0.7, 23);
    
    _previewLayer.frame = self.cameraView.bounds;
     _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_previewLayer addSublayer:self.timerView.layer];
    [self.cameraView.layer addSublayer:_previewLayer];
    [self setup];
    [self.buttonAddVideo setHidden:YES];
        [self.view bringSubviewToFront:self.buttonTemporary];
    
  //  UIImage *image = [UIImage imageWithImage:self.sliderSmallScreen.currentThumbImage scaledToSize:CGSizeMake(30, 30)];
    
   // [self.sliderSmallScreen setThumbImage:image forState:UIControlStateNormal];
    
    [self.sliderSmallScreen addTarget:self action:@selector(smallScreenSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.sliderLargeScreen addTarget:self action:@selector(largeScreenSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
   
      }  else {
   
          [self updateViewForPlayerMode];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyBoardDidShow:)
                                                 name: UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyBoardDidHide:)
                                                 name: UIKeyboardDidHideNotification
                                               object:nil];

   // [self.progressView animateViewWithduration:5000 initialValue:1];

    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touch ended");
}

#pragma UISlider Methods

- (IBAction)smallScreenSliderValueChanged:(UISlider *)sender {

    UISlider *slider = (UISlider*)sender;
   // self.scMiniPlayer.plplayer.volume = slider.value;
    self.scMiniPlayer.volume = slider.value;
}


- (IBAction)largeScreenSliderValueChanged:(UISlider *)sender {
    
    
    UISlider *slider = (UISlider*)sender;
    self.scPlayer.volume = slider.value;
}

#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Private Methods

- (void)buttonPressed:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    NSInteger index = button.tag;
    
    
    [self.swipeFilterView setSelectedFilter: [self.swipeFilterView.filters objectAtIndex:index]];
    
    [self.miniSwipeFilterView setSelectedFilter: [self.miniSwipeFilterView.filters objectAtIndex:index]];
}
- (void)exportVideoToRollwithUrlPath:(NSString*)urlPath Filter:(SCFilter*)filter outPutPath:(NSString*)outputPath {
    
    
    NSURL *firstUrl = [NSURL fileURLWithPath:urlPath];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:firstUrl options:nil];
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:asset];
    exportSession.videoConfiguration.filter = filter;
    exportSession.videoConfiguration.preset = SCPresetHighestQuality;
    exportSession.audioConfiguration.preset = SCPresetHighestQuality;
    exportSession.videoConfiguration.maxFrameRate = 35;
    exportSession.outputUrl = [NSURL fileURLWithPath:outputPath];
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.delegate = self;
    exportSession.contextType = SCContextTypeAuto;
    
    CFTimeInterval time = CACurrentMediaTime();
    __weak typeof(self) wSelf = self;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        if (!exportSession.cancelled) {
            NSLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
        }
        
        
        NSError *error = exportSession.error;
        if (exportSession.cancelled) {
            NSLog(@"Export was cancelled");
        } else if (error == nil) {
            
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            [exportSession.outputUrl saveToCameraRollWithCompletion:^(NSString * _Nullable path, NSError * _Nullable error) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                if (error == nil) {
                    
                    
                    NSLog(@"Save to roll");
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                } else {
                    
                    NSLog(@"Failed");
                }
            }];
        } else {
            if (!exportSession.cancelled) {
                
                NSLog(@"Failed");
            }
        }
    }];
}


-(void)addTextToVideoWithVideoURL:(NSURL*)url withText:(NSString*)text
{
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
    
    CGSize sizeOfVideo = [videoAsset naturalSize];
    //NSLog(@"sizeOfVideo.width is %f",sizeOfVideo.width);
    //NSLog(@"sizeOfVideo.height is %f",sizeOfVideo.height);
    //TextLayer defines the text they want to add in Video
    
    CATextLayer *textOfvideo = [[CATextLayer alloc] init];
    textOfvideo.string=[NSString stringWithFormat:@"%@",text];//text is shows the text that you want add in video.
    
    [textOfvideo setFont:(__bridge CFTypeRef)([UIFont fontWithName:[NSString stringWithFormat:@"%s","MicrosoftPhagsPa"] size:23])];//fontUsed is the name of font
    [textOfvideo setFrame:CGRectMake(self.labelPoint.x , self.labelPoint.y , sizeOfVideo.width, 60)];
   // [textOfvideo setAlignmentMode:kCAAlignmentCenter];
    [textOfvideo setForegroundColor:[[self.textLabel textColor] CGColor]];
    
    
    CALayer *optionalLayer = [CALayer layer];
    [optionalLayer addSublayer:textOfvideo];
    optionalLayer.frame=CGRectMake(0, 0, sizeOfVideo.width, sizeOfVideo.height);
    [optionalLayer setMasksToBounds:YES];
    
    CALayer *parentLayer=[CALayer layer];
    CALayer *videoLayer=[CALayer layer];
    parentLayer.frame=CGRectMake(0, 0, sizeOfVideo.width, sizeOfVideo.height);
    videoLayer.frame=CGRectMake(0, 0, sizeOfVideo.width, sizeOfVideo.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:optionalLayer];
    
    AVMutableVideoComposition *videoComposition=[AVMutableVideoComposition videoComposition] ;
    videoComposition.frameDuration=CMTimeMake(1, 10);
    videoComposition.renderSize=sizeOfVideo;
    videoComposition.animationTool=[AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
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
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(destinationPath)) {
                    UISaveVideoAtPathToSavedPhotosAlbum(destinationPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                }
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportSession.error);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export Cancelled");
                break;
        }
    }];
}


-(void) video: (NSString *) videoPath didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error)
        NSLog(@"Finished saving video with error: %@", error);
}

- (NSString*)getOutputPathfor:(NSString*)videoType {
    
    if ([videoType isEqualToString:@"Front"]) {
        
        NSString *outputFile = [NSString stringWithFormat:@"video_%@.mp4", @"Front-Output"];
        
        NSString *outputDirectory =  NSTemporaryDirectory();
        NSString *outputPath = [outputDirectory stringByAppendingPathComponent:outputFile];
        return outputPath;
    }
    else {
        
        NSString *outputFile = [NSString stringWithFormat:@"video_%@.mp4", @"Rear-Output"];
        
        NSString *outputDirectory =  NSTemporaryDirectory();
        NSString *outputPath = [outputDirectory stringByAppendingPathComponent:outputFile];
        return outputPath;

    }
}

- (void)playPressed:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    [_scPlayer play];
    [_scMiniPlayer play];
    button.hidden = YES;
    _playImageView.hidden = YES;
    
}
- (void)dealloc {
    [self.swipeFilterView removeObserver:self forKeyPath:@"selectedFilter"];
    self.swipeFilterView = nil;
    [_scPlayer pause];
   // _scPlayer = nil;
    //[self cancelSaveToCameraRoll];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.swipeFilterView) {
     
    }
}


- (SCFilter *)createAnimatedFilter {
    SCFilter *animatedFilter = [SCFilter emptyFilter];
    animatedFilter.name = @"Animated FilterZ";
    
    SCFilter *gaussian = [SCFilter filterWithCIFilterName:@"CIGaussianBlur"];
    SCFilter *blackAndWhite = [SCFilter filterWithCIFilterName:@"CIColorControls"];
    
    [animatedFilter addSubFilter:gaussian];
    [animatedFilter addSubFilter:blackAndWhite];
    
    double duration = 0.5;
    double currentTime = 0;
    BOOL isAscending = YES;
    
    Float64 assetDuration =  2.0;//CMTimeGetSeconds(_recordSession.assetRepresentingSegments.duration);
    
    while (currentTime < assetDuration) {
        if (isAscending) {
            [blackAndWhite addAnimationForParameterKey:kCIInputSaturationKey startValue:@1 endValue:@0 startTime:currentTime duration:duration];
            [gaussian addAnimationForParameterKey:kCIInputRadiusKey startValue:@0 endValue:@10 startTime:currentTime duration:duration];
        } else {
            [blackAndWhite addAnimationForParameterKey:kCIInputSaturationKey startValue:@0 endValue:@1 startTime:currentTime duration:duration];
            [gaussian addAnimationForParameterKey:kCIInputRadiusKey startValue:@10 endValue:@0 startTime:currentTime duration:duration];
        }
        
        currentTime += duration;
        isAscending = !isAscending;
    }
    
    return animatedFilter;
}




- (void)addPencilWorkToView {
    if (self.imagePencilCapture != nil) {
        if (!self.pencilImageView) {
            self.pencilImageView = [[UIImageView alloc] init];
            [self.view addSubview:self.pencilImageView];
            
        }
        self.pencilImageView.hidden = NO;
        self.pencilImageView.image = self.imagePencilCapture;
        self.pencilImageView.frame = self.drawingView.frame;
        
        [self.view bringSubviewToFront:self.pencilImageView];
    }

}
- (void)labelPressed:(id)sender {
    

    self.textLabel.hidden = YES;
    self.textField.hidden = NO;
    [self.textField becomeFirstResponder];
    
    [self.view addSubview:self.overlayView];
}
- (void)labelChange:(id)sender {
  
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer*)sender;
     self.labelPoint = [recognizer locationInView:self.view];

    //if (recognizer.state == UIGestureRecognizerStateEnded) {
    CGRect rect = CGRectMake(self.cameraView.frame.origin.x-8, self.cameraView.frame.origin.y - 8, self.cameraView.frame.size.width - 8, self.cameraView.frame.size.height - 8);
        
    if (CGRectContainsPoint(rect, self.labelPoint)) {
        
        self.textLabel.center = self.labelPoint;
        
        }
  }

- (void)longpressed:(UIGestureRecognizer*)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (!_isRecording) {
                
                [[PBJVision sharedInstance] startVideoCapture];
                self.switchButton.enabled = NO;
                self.libraryButton.enabled = NO;
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
- (void)setup
{
    _longPressGestureRecognizer.enabled = YES;
    self.viewContainer.hidden = YES;
    [self rightButtonCanShow:NO];
    
    _isnextPressed = NO;
    PBJVision *vision = [PBJVision sharedInstance];
    //vision.captureSessionPreset = AVCaptureSessionPresetHigh;
    vision.delegate = self;
    vision.cameraMode = PBJCameraModeVideo;
    vision.cameraOrientation = PBJCameraOrientationPortrait;
    vision.focusMode = PBJFocusModeContinuousAutoFocus;
    vision.outputFormat = PBJOutputFormatPreset;
    
    NSString *outputFile = [NSString stringWithFormat:@"video_%@.mp4", @"Rear"];
    
    if (self.secondVideo) {
        outputFile =  [NSString stringWithFormat:@"video_%@.mp4", @"Front"];
    }

    NSString *outputDirectory =  NSTemporaryDirectory();
    NSString *outputPath = [outputDirectory stringByAppendingPathComponent:outputFile];
    vision.outputPath = outputPath;
    if (self.secondVideo) {
        
        [[WSetting getSharedSetting] setFrontVideoUrlPath:outputPath];

    }
    else {
     
        [[WSetting getSharedSetting] setRearVideoUrlPath:outputPath];

    }
    [vision startPreview];
    //[[PBJVision sharedInstance] setMaximumCaptureDuration:CMTimeMakeWithSeconds(5, 600)]; // ~ 5 seconds
    
    
}

#pragma mark Collection View Delegate Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WZFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewFilter" forIndexPath:indexPath];
    CIImage *filterImage = [self.filterArray objectAtIndex:indexPath.row];
    UIImage *image = [[UIImage alloc] initWithCIImage:filterImage];

    [cell.buttonPeople setImage:image forState:UIControlStateNormal];
    [cell.buttonPeople setTag:indexPath.row];
    [cell.buttonPeople addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
  
   
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.filterArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
//    NSInteger index = indexPath.row;
//  
//    
//    [self.swipeFilterView setSelectedFilter: [self.swipeFilterView.filters objectAtIndex:index]];
//    
//    [self.miniSwipeFilterView setSelectedFilter: [self.miniSwipeFilterView.filters objectAtIndex:index]];
  
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(collectionView.frame.size.width/4-4 , collectionView.frame.size.height);
    
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}


#pragma mark UIMediaPickerView Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
  
    self.isUsingLibrary = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];

    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    NSData *videoData = [NSData dataWithContentsOfURL:videoURL];

    NSString *outputFile = [NSString stringWithFormat:@"video_%@.mp4", @"Rear"];

    NSString *outputDirectory =  NSTemporaryDirectory();
    
    if (self.secondVideo) {
        outputFile =  [NSString stringWithFormat:@"video_%@.mp4", @"Front"];
    }

    NSString *outputPath = [outputDirectory stringByAppendingPathComponent:outputFile];
    
    if (self.secondVideo) {
        [[WSetting getSharedSetting] setFrontVideoUrlPath:outputPath];
    }
    else {
        [[WSetting getSharedSetting] setRearVideoUrlPath:outputPath];
    }

    BOOL success = [videoData writeToFile:outputPath atomically:NO];
    if (success) {
        NSLog(@"Video uploaded");
    }
    
    [self rightButtonCanShow:YES];

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
    
    self.libraryButton.enabled = YES;
    self.switchButton.enabled = YES;
    [self updateViewForPlayerMode];
    self.isnextPressed = YES;
    

//    [_assetLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:videoPath] completionBlock:^(NSURL *assetURL, NSError *error1) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Video Saved!" message: @"Saved to the camera roll."
//                                                       delegate:self
//                                              cancelButtonTitle:nil
//                                              otherButtonTitles:@"OK", nil];
//        [alert show];
//    }];
}

#pragma mark ACEDrawingView Delegate Methods
- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool {
    
    if (!self.eraseButton) {
    self.eraseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    self.eraseButton.hidden = NO;
    self.eraseButton.frame = CGRectMake(self.drawingView.center.x+80, self.drawingView.center.y, 100, 100);
    [self.eraseButton setImage:[UIImage imageNamed:@"Image_Eraser"] forState:UIControlStateNormal];
    [self.eraseButton addTarget:self action:@selector(erasePressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.eraseButton];
   
    [view bringSubviewToFront:self.eraseButton];
    
    self.imagePencilCapture = [view image];
}

- (void)drawingView:(ACEDrawingView *)view willBeginDrawUsingTool:(id<ACEDrawingTool>)tool {
    
}


#pragma mark SPlayer Delegate Methods

- (void)player:(SCPlayer *__nonnull)player didPlay:(CMTime)currentTime loopsCount:(NSInteger)loopsCount {
    
}

- (void)player:(SCPlayer *__nonnull)player didChangeItem:(AVPlayerItem *__nullable)item {
    
}

- (void)player:(SCPlayer *__nonnull)player didReachEndForItem:(AVPlayerItem *__nonnull)item
{
    _playImageView.hidden = NO;
    _playButton.hidden = NO;
    [player seekToTime:kCMTimeZero];
    
}

- (void)player:(SCPlayer *__nonnull)player itemReadyToPlay:(AVPlayerItem *__nonnull)item {
    
}

- (void)player:(SCPlayer *__nonnull)player didSetupSCImageView:(SCImageView *__nonnull)SCImageView {
    
}


#pragma KeyBoard Delegate Methods
- (void)keyBoardDidShow:(id)sender {
    
    NSLog(@"Keyboard did show");
}
- (void)keyBoardDidHide:(id)sender {
    
  //  NSLog(@"keyboard did hide");
   // [self.textLabel removeFromSuperview];
    self.textLabel.text = self.textField.text;
    [self.view bringSubviewToFront:self.textLabel];
    [self viewDidLayoutSubviews];
    self.textLabel.hidden = NO;
    [self.overlayView removeFromSuperview];
   // self.textLabel.center = CGPointMake(100, 100);
    self.textField.hidden = YES;
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

