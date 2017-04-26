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
#import "SCVideoPlayerView.h"
#import "SCAssetExportSession.h"
#import "NSURL+SCSaveToCameraRoll.h"


@import AVKit;
@import IGColorPicker;

@interface WVideoRecordViewController ()<PBJVisionDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ACEDrawingViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SCPlayerDelegate,ColorPickerViewDelegate,ColorPickerViewDelegateFlowLayout,UITextViewDelegate>

@property(nonatomic ,retain) UILongPressGestureRecognizer *longPressGestureRecognizer;

@property(nonatomic ,retain) AVCaptureVideoPreviewLayer *previewLayer;

@property(nonatomic) BOOL isRecording;

@property(nonatomic) NSInteger time;

@property(nonatomic ,retain) NSTimer *timer;

@property(nonatomic) BOOL secondVideo;

@property(nonatomic ,assign) NSInteger keyboardHeight;

@property(nonatomic ,retain) NSString *firstVideoPath;

@property(nonatomic ,retain) AVPlayerViewController *videoPlayer;

@property(nonatomic ,retain) NSMutableArray *filterArray;

@property(nonatomic ,retain) ACEDrawingView *drawingView;

@property(nonatomic ,retain) ColorPickerView *textColorPickerView;


@property(nonatomic ,retain) UIButton *eraseButton;

@property(nonatomic ,retain) UIImage *imagePencilCapture;

@property(nonatomic ,retain) ColorPickerView *colorPicker;

@property(nonatomic) CGPoint  labelPoint;

@property(nonatomic ,retain) UIView *overlayView;

@property(nonatomic ,retain) UIImageView *pencilImageView;

@property(nonatomic ,retain)  UIPanGestureRecognizer *panGesture;

@property(nonatomic ,retain)  UITapGestureRecognizer *tapGesture;

@property(nonatomic )  BOOL isUsingLibrary;

@property(nonatomic ,retain) SCFilterImageView *videoPlayerFilter;

@property(nonatomic ,retain) SCFilterImageView *miniVideoPlayerFilter;

@property(nonatomic ,retain) SCPlayer *scPlayer;

@property(nonatomic ,retain) SCPlayer *scMiniPlayer;

@property(nonatomic ,retain) UIButton *plusButton;

@property(nonatomic ,retain) UIButton *minusButton;

@property(nonatomic ,retain) UIImageView *playImageView;

@property(nonatomic ,retain) UIButton *playButton;

@property(nonatomic) BOOL isPause;

@property(nonatomic) BOOL isnextPressed;

@property(nonatomic ,retain) NSArray *filters;

@property(nonatomic ,assign) NSInteger fontCount;




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
    
    [self updateViewFor:@"Sound"];
}

- (void)pencilPressed:(id)sender {
    
    [self updateViewFor:@"Pencil"];
    
}
- (void)colorChanged:(id)sender {
    HRColorMapView *colorMap = (HRColorMapView*)sender;
    self.drawingView.lineColor = colorMap.color;
}

- (void)filterPressed:(id)sender {
    
    [self updateViewFor:@"Filter"];
   }

- (void)textPressed:(id)sender {
 
    [self updateViewFor:@"Text"];
    
}

- (void)tempButtonPressed:(id)sender {
    
    self.timerView.hidden = YES;
    WTempVideoRecorderViewController *tempController = [[UIStoryboard getMediaStoryBoard] instantiateViewControllerWithIdentifier:K_SB_TEMP_VIDEO_VIEW_CONTROLLER];
    [self.navigationController pushViewController:tempController animated:YES];
    
}

- (void)plusPressed {
   
    _fontCount = _fontCount + 2;
    
    [self.textField setFont:[UIFont fontWithName:@"MicrosoftPhagsPa" size:_fontCount]];
    
    [self.textLabel setFont:[UIFont fontWithName:@"MicrosoftPhagsPa" size:_fontCount]];
}
- (void)minusPressed {
    
    _fontCount = _fontCount - 2;
  
    [self.textField setFont:[UIFont fontWithName:@"MicrosoftPhagsPa" size:_fontCount]];
    
    [self.textLabel setFont:[UIFont fontWithName:@"MicrosoftPhagsPa" size:_fontCount]];
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
    
        _scMiniPlayer = [SCPlayer player];
        
        AVAsset *asset = [AVAsset assetWithURL:secondVideoURL];
        
        _scMiniPlayer.shouldSuppressPlayerRendering = YES;
        
        [_scMiniPlayer  setItemByAsset:asset];
        
        _scMiniPlayer.delegate = self;
        
        
        CGRect rect= CGRectMake(0, self.buttonAddVideo.frame.origin.y, self.buttonAddVideo.frame.size.width, self.buttonAddVideo.frame.size.height);
        
        SCVideoPlayerView *miniVideoPlayerView = [[SCVideoPlayerView alloc] initWithFrame:rect];
     
        [miniVideoPlayerView setFrameX:0.0];
        
        [miniVideoPlayerView setFrameY:0.0];
        
        [self.view addSubview:miniVideoPlayerView];
        
      //  [self.buttonAddVideo bringSubviewToFront:miniVideoPlayerView];
        
        miniVideoPlayerView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.miniVideoPlayerFilter = [[SCFilterImageView alloc] initWithFrame:rect];
        
        self.miniVideoPlayerFilter.filter = [SCFilter emptyFilter];
        
        //
        
        _scMiniPlayer.SCImageView = self.miniVideoPlayerFilter;
        
        //
        
        [self.view addSubview:self.self.miniVideoPlayerFilter];

        [self.view bringSubviewToFront:self.miniVideoPlayerFilter];
        
       }
    
    else {
    
    _scPlayer = [SCPlayer player];
   
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    
    _scPlayer.shouldSuppressPlayerRendering = YES;
    
    [_scPlayer  setItemByAsset:asset];
    
    _scPlayer.delegate = self;
    
   SCVideoPlayerView *videoPlayerView = [[SCVideoPlayerView alloc] initWithFrame:self.cameraView.frame];
    [videoPlayerView setFrameX:0.0];
    [videoPlayerView setFrameY:0.0];
    [self.cameraView addSubview:videoPlayerView];
   
    
    //Add play button
    _playImageView = [[UIImageView alloc] init];
    [_playImageView setFrameHeight:60];
    [_playImageView setFrameWidth:60];
    _playImageView.center = CGPointMake(videoPlayerView.frame.size.width  / 2,
                                     videoPlayerView.frame.size.height / 2.2);

    _playImageView.image = [UIImage imageNamed:@"Image_Play"];
    
    
   // [self.videoPlayerView addSubview:_playImageView];
    
     _playButton  = [[UIButton alloc] initWithFrame:_playImageView.frame];
    [_playButton setFrameWidth:100];
    [_playButton setFrameHeight:100];
   // [self.videoPlayerView addSubview:_playButton];
    [_playButton addTarget:self action:@selector(playPressed:) forControlEvents:UIControlEventTouchUpInside];

        videoPlayerView.contentMode = UIViewContentModeScaleAspectFill;
    
    
     self.videoPlayerFilter = [[SCFilterImageView alloc] initWithFrame:self.cameraView.bounds];
    
    self.videoPlayerFilter.filter = [SCFilter emptyFilter];
    
    //
    
    _scPlayer.SCImageView = self.videoPlayerFilter;
    
    //
    
    [self.cameraView addSubview:self.videoPlayerFilter];
    
    [self.videoPlayerFilter addSubview:_playImageView];
    [self.videoPlayerFilter addSubview:_playButton];
    
    
    }
    self.viewContainer.hidden = NO;
    
    if (!self.secondVideo) {
        
        self.buttonAddVideo.hidden = NO;
        [self.view bringSubviewToFront:self.buttonAddVideo];
        self.sliderSmallScreen.hidden = NO;
        self.labelSmall.hidden = NO;
        self.sliderLargeScreen.center = CGPointMake(self.sliderLargeScreen.center.x, self.sliderLargeScreen.center.y);
        
        self.labelLarge.center = CGPointMake(self.labelLarge.center.x, self.labelLarge.center.y);
        
        self.sliderSmallScreen.enabled = NO;
        
    }
    else {
        [self.view bringSubviewToFront:_videoPlayer.view];
        self.sliderSmallScreen.hidden = NO;
        self.labelSmall.hidden = NO;
        self.sliderSmallScreen.enabled = YES;
                
    }



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
 
    if (self.isnextPressed) {
        
        _previewLayer.frame = self.cameraView.bounds;
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [_previewLayer addSublayer:self.timerView.layer];
        [self.cameraView.layer addSublayer:_previewLayer];
        [self.view bringSubviewToFront:self.cameraView];
        [self setup];
        self.isUsingLibrary = NO;
        self.secondVideo = NO;

        
    }
    else {
 
        [self.navigationController popViewControllerAnimated:YES];
}
    
}

- (void)nextPressed {
    
    if (self.isnextPressed) {
        
      //  WWizhViewController *controller =  [[UIStoryboard getWhizStoryBoard] instantiateViewControllerWithIdentifier:K_SB_WIZH_VIEW_CONTROLLER];
        
      //  controller.showWhiz = YES;
//        
      //  [self.navigationController pushViewController:controller animated:YES];
        
       // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //Save video
        
        NSString *originPath = [[WSetting getSharedSetting] rearVideoUrlPath];
        [self exportVideoToRollwithUrlPath:originPath Filter:self.videoPlayerFilter.filter];

        
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
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.allowsEditing = NO;
    imagePicker.videoQuality = UIImagePickerControllerQualityType640x480;
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
    self.fontCount = 23;
    
    self.navigationItem.title = @"Video";
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
    
    //[self didTappedView:self.view];
    

}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if (!CGPointEqualToPoint(self.labelPoint, CGPointZero)) {
        
         self.textLabel.center = self.labelPoint;
    }
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
//    if (!self) {
        self = [super initWithCoder:aDecoder];
//        
//    }
    self.filterArray = [[NSMutableArray alloc] init];
    
    self.filters = [[NSArray alloc] initWithObjects:@"No Filter" ,@"CIPhotoEffectChrome", @"CIPhotoEffectFade", @"CIPhotoEffectInstant", @"CIPhotoEffectMono", @"CIPhotoEffectNoir", @"CIPhotoEffectProcess", @"CIPhotoEffectTonal", @"CIPhotoEffectTransfer" , nil];

    
    
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
   
        //  [self updateViewForPlayerMode];
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
    
    CGPoint location = [[touches anyObject] locationInView:self.view];
    UIView *view = [self.view hitTest:location withEvent:nil];
    
    NSLog(@"tag number %ld",(long)view.tag);
    
    if (view.alpha < 1 && [self.textField isFirstResponder]) {
        
        [self.textField resignFirstResponder];
    }
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

#pragma mark - Touch delegate methods
#pragma Mark - UITExtview Delegate Methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        //  [textView resignFirstResponder];
        textView.text = [NSString stringWithFormat:@"%@\n",textView.text];
        self.textField.frame = CGRectMake(self.textField.frame.origin.x, self.textField.frame.origin.y - 10, self.textField.frame.size.width, self.textField.frame.size.height);
        
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    textView.text = [textView.text stringByReplacingOccurrencesOfString:@"Enter Text" withString:@""];
    
}


#pragma mark Private Methods


- (void)updateViewFor:(NSString*)mode {
    
    if ([mode isEqualToString:@"Sound"]) {
        
        [self.plusButton removeFromSuperview];
        
        [self.minusButton removeFromSuperview];
        
        self.soundButton.selected = YES;
       
        self.pencilButton.selected = NO;
        
        self.textPencil.selected = NO;
        
        self.filterPencil.selected = NO;
        
        [self.view sendSubviewToBack:self.drawingView];
        
        self.colorPicker.hidden = YES;
        
        
        [self addPencilWorkToView];
        
        self.collectionView.hidden = YES;
        
        [self.textColorPickerView removeFromSuperview];
        
        self.textColorPickerView = nil;
        
        self.labelLarge.hidden = NO;
        
        self.labelSmall.hidden = NO;
        
        self.sliderLargeScreen.hidden = NO;
        
        self.sliderSmallScreen.hidden = NO;
        
        self.collectionView.hidden = YES;
        
        
        self.playButton.hidden = NO;
        self.playImageView.hidden = NO;
        
        

    }
    else if ([mode isEqualToString:@"Filter"]) {
     
        [self.plusButton removeFromSuperview];
        
        [self.minusButton removeFromSuperview];
        
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
        
        [self.textColorPickerView removeFromSuperview];
        
        self.textColorPickerView = nil;
        
        
        self.playButton.hidden = NO;
        self.playImageView.hidden = NO;

    }
    else if ([mode isEqualToString:@"Pencil"]) {
     
        
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
            
            self.colorPicker = [[ColorPickerView alloc] initWithFrame:self.viewContainer.frame];
            [self.view addSubview:self.colorPicker];
        }
        [self.drawingView loadImage:self.imagePencilCapture];
        self.colorPicker.hidden = NO;
        [self.colorPicker setFrameHeight:80];
        self.colorPicker.delegate = self;
        
        self.pencilImageView.hidden = YES;
        
        [self.plusButton removeFromSuperview];
        
        [self.minusButton removeFromSuperview];
        
        [self.textColorPickerView removeFromSuperview];
        
        self.textColorPickerView = nil;
        
        self.playButton.hidden = YES;
        
        self.playImageView.hidden = YES;
        
        
        if (!self.eraseButton) {
            self.eraseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        }
     //   self.eraseButton.hidden = NO;
        
        self.eraseButton.frame = CGRectMake(self.view.frame.size.width - 40, 80, 30, 30);
        [self.eraseButton setImage:[UIImage imageNamed:@"Image_Eraser"] forState:UIControlStateNormal];
        [self.eraseButton addTarget:self action:@selector(erasePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.eraseButton];
        self.eraseButton.hidden = YES;
        
       // [self.view bringSubviewToFront:self.eraseButton];
    }
    else if ([mode isEqualToString:@"Text"]) {
        
        
        self.colorPicker.hidden = YES;
        
          self.sliderLargeScreen.hidden = YES;
        
         self.sliderSmallScreen.hidden = YES;
        
        self.labelSmall.hidden = YES;
        
        self.labelLarge.hidden = YES;
        
        self.cameraView.frame = self.view.frame;
        
        self.soundButton.selected = NO;
        self.pencilButton.selected = NO;
        self.textPencil.selected = YES;
        self.filterPencil.selected = NO;
        
        self.collectionView.hidden = YES;
        
        [self.view sendSubviewToBack:self.drawingView];
        
        if (self.textLabel.text.length == 0) {
            self.textField.text = @"Enter Text";
        }
        self.textField.textColor = self.textLabel.textColor;
        [self.textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.textField.backgroundColor = [UIColor clearColor];
        [self addPencilWorkToView];
        self.textField.textAlignment = NSTextAlignmentCenter;
        // _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.textField.frame.origin.y+100);
        self.overlayView  = [[UIView alloc] initWithFrame:rect];
        self.overlayView.backgroundColor = [UIColor clearColor];
        self.overlayView.alpha = 0.3;
        //[self didTappedView:self.overlayView];
        self.textField.hidden = NO;
        [self.textField becomeFirstResponder];
        [self.view addSubview:self.overlayView];
        
        [self.view bringSubviewToFront:self.textField];
        self.textLabel.hidden = YES;
        [self.textLabel setUserInteractionEnabled:YES];
        
        self.plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.plusButton.frame = CGRectMake(10, 75, 30, 30);
        [self.plusButton setImage:[UIImage imageNamed:@"Image_Plus"] forState:UIControlStateNormal];
        [self.view addSubview:self.plusButton];
        [self.plusButton addTarget:self action:@selector(plusPressed) forControlEvents:UIControlEventTouchDown];
        
        
        
        self.minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.minusButton.frame = CGRectMake( 50, 75, 30, 30);
        [self.minusButton setImage:[UIImage imageNamed:@"Image_Minus"] forState:UIControlStateNormal];
        [self.view addSubview:self.minusButton];
        [self.minusButton addTarget:self action:@selector(minusPressed) forControlEvents:UIControlEventTouchDown];
        
        self.playButton.hidden = YES;
        self.playImageView.hidden = YES;

        
    }
    
}
- (void)buttonPressed:(id)sender {
    
    UIButton *button = (UIButton*)sender;
   
    NSInteger index = button.tag;
    
    NSString *filterName = [self.filters objectAtIndex:index];
   
    self.videoPlayerFilter.filter = [SCFilter filterWithCIFilterName:filterName];
  
    self.scPlayer.SCImageView = self.videoPlayerFilter;

    self.miniVideoPlayerFilter.filter = [SCFilter filterWithCIFilterName:filterName];
    
    self.scMiniPlayer.SCImageView = self.miniVideoPlayerFilter;
    
    
}
- (void)exportVideoToRollwithUrlPath:(NSString*)urlPath Filter:(SCFilter*)filter  {
    
    
    NSURL *firstUrl = [NSURL fileURLWithPath:urlPath];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:firstUrl options:nil];
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:asset];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/utput_%@.mov", [dateFormatter stringFromDate:[NSDate date]]];
    exportSession.videoConfiguration.filter = filter;
    
    exportSession.videoConfiguration.preset = SCPresetHighestQuality;
    
    exportSession.audioConfiguration.preset = SCPresetHighestQuality;
    
    exportSession.videoConfiguration.maxFrameRate = 35;
    
    exportSession.outputUrl = [NSURL fileURLWithPath:destinationPath];
    
    exportSession.outputFileType = AVFileTypeMPEG4;
    
    exportSession.delegate = self;
    
    exportSession.contextType = SCContextTypeAuto;
    
    CFTimeInterval time = CACurrentMediaTime();
    __weak typeof(self) wSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *fileURL = [NSURL fileURLWithPath:destinationPath];
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        if (!exportSession.cancelled) {
            NSLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
        }
        
        
        NSError *error = exportSession.error;
        if (exportSession.cancelled) {
            NSLog(@"Export was cancelled");
        } else if (error == nil) {
            
            __weak typeof(self) weakSelf = self;
            [[WSetting getSharedSetting] setFirstOutputUrl:destinationPath];
        
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            
            [exportSession.outputUrl saveToCameraRollWithCompletion:^(NSString * _Nullable path, NSError * _Nullable error) {
              
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                if (error == nil) {
                    
                    
                    NSLog(@"Save to roll");
                    if (self.textLabel.text.length > 0) {
                        [RUUtility addTextToVideoWithVideoURL:fileURL withText:weakSelf.textLabel.text labelPoint:weakSelf.labelPoint label:weakSelf.textLabel  success:^{
                            
                            NSString *destinationPath = [[WSetting getSharedSetting] firstOutputUrl];
                            
                            if (self.pencilImageView != nil) {
                                [RUUtility addImageToVideoWithVideoURL:[NSURL fileURLWithPath:destinationPath] withImage:weakSelf.drawingView.image success:^{
                                    NSLog(@"image is ready");
                                    NSString *destinationPath = [[WSetting getSharedSetting] firstOutputUrl];
                                    
                                    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(destinationPath))
                                        
                                        UISaveVideoAtPathToSavedPhotosAlbum(destinationPath, weakSelf, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                                }];
                            }

                            
                        }];
                        //
                    }
                 else  if (self.pencilImageView != nil) {
                        [RUUtility addImageToVideoWithVideoURL:fileURL withImage:weakSelf.drawingView.image success:^{
                            NSLog(@"image is ready");
                                NSString *destinationPath = [[WSetting getSharedSetting] firstOutputUrl];
                            
                        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(destinationPath))
                            
                            UISaveVideoAtPathToSavedPhotosAlbum(destinationPath, weakSelf, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                        }];
                    }
                    //End

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
   // [self.swipeFilterView removeObserver:self forKeyPath:@"selectedFilter"];
   // self.swipeFilterView = nil;
    [_scPlayer pause];
   // _scPlayer = nil;
    //[self cancelSaveToCameraRoll];
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

    self.isnextPressed = YES;
    
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    
    
    NSData *videoData = [NSData dataWithContentsOfURL:videoURL];

    NSString *outputFile = [NSString stringWithFormat:@"video_%@.mp4", @"Rear"];
//
    NSString *outputDirectory =  NSTemporaryDirectory();
//    
    if (self.secondVideo) {
        outputFile =  [NSString stringWithFormat:@"video_%@.mp4", @"Front"];
    }
//
    NSString *outputPath = [outputDirectory stringByAppendingPathComponent:outputFile];
//    
    
    
    if (self.secondVideo) {
        [[WSetting getSharedSetting] setFrontVideoUrlPath:outputPath];
    }
    else {
        [[WSetting getSharedSetting] setRearVideoUrlPath:outputPath];
    }
//
    BOOL success = [videoData writeToFile:outputPath atomically:NO];
    if (success) {
        NSLog(@"Video uploaded");
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
       
     
         [self updateViewForPlayerMode];
//
  }
//    
    [self rightButtonCanShow:YES];
//    
    
}


- (BOOL)encodeVideo:(NSURL *)videoURL exportPath:(NSString*)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    // Create the composition and tracks
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    NSArray *assetVideoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if (assetVideoTracks.count <= 0)
    {
        NSLog(@"Error reading the transformed video track");
        return NO;
    }
    
    // Insert the tracks in the composition's tracks
    AVAssetTrack *assetVideoTrack = [assetVideoTracks firstObject];
    [videoTrack insertTimeRange:assetVideoTrack.timeRange ofTrack:assetVideoTrack atTime:CMTimeMake(0, 1) error:nil];
    [videoTrack setPreferredTransform:assetVideoTrack.preferredTransform];
    
    AVAssetTrack *assetAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    [audioTrack insertTimeRange:assetAudioTrack.timeRange ofTrack:assetAudioTrack atTime:CMTimeMake(0, 1) error:nil];
    
    // Export to mp4
    NSString *mp4Quality = AVAssetExportPresetMediumQuality ;
    
   // NSString *exportPath = [NSString stringWithFormat:@"%@/%@.mp4",
     //                       [NSHomeDirectory() stringByAppendingString:@"/tmp"],
       //                     @"asdasdsa"];
    NSURL *exportUrl = [NSURL fileURLWithPath:path];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:mp4Quality];
    exportSession.outputURL = exportUrl;
    CMTime start = CMTimeMakeWithSeconds(0.0, 0);
    CMTimeRange range = CMTimeRangeMake(start, [asset duration]);
    exportSession.timeRange = range;
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch ([exportSession status])
        {
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"MP4 Successful!");
                if (self.secondVideo) {
                    [[WSetting getSharedSetting] setFrontVideoUrlPath:path];
                }
                else {
                    [[WSetting getSharedSetting] setRearVideoUrlPath:path];
                }
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export canceled");
                break;
            default:
                break;
        }
    }];
    
    return YES;
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
    
   
    
    self.imagePencilCapture = [view image];
    
    if (self.eraseButton.isHidden) {
        self.eraseButton.hidden = NO;
    }
}

- (void)drawingView:(ACEDrawingView *)view willBeginDrawUsingTool:(id<ACEDrawingTool>)tool {
    
}


#pragma Color Picker Layout Delegate Methods

- (CGSize)colorPickerView:(ColorPickerView *)colorPickerView sizeForItemAt:(NSIndexPath *)indexPath {
    
    return  CGSizeMake(30, 30);
}

#pragma mark ColorPicker Delegate Methods

- (void)colorPickerView:(ColorPickerView *)colorPickerView didSelectItemAt:(NSIndexPath *)indexPath {
    
    if (colorPickerView.tag == 100) {
        //update text UI
        self.textLabel.textColor = [colorPickerView.colors objectAtIndex:indexPath.row];
        
        self.textField.textColor = [colorPickerView.colors objectAtIndex:indexPath.row];
        
    }
    else {
    
        self.drawingView.lineColor = [colorPickerView.colors objectAtIndex:indexPath.row];
    }
    
    
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
- (void)keyBoardDidShow:(NSNotification*)sender {
    
    
    CGSize keyboardSize = [[[sender userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    self.keyboardHeight = MIN(keyboardSize.height,keyboardSize.width);
    NSLog(@"Keyboard did show");
    
    if (!_textColorPickerView) {
        self.textColorPickerView  = [[ColorPickerView alloc] init];
    _textColorPickerView.delegate = self;
    _textColorPickerView.layoutDelegate = self;
    _textColorPickerView.scrollToPreselectedIndex = YES;
    _textColorPickerView.tag = 100;
        [self.view addSubview:_textColorPickerView];
    
    }
    _textColorPickerView.frame = CGRectMake(0, self.keyboardHeight , self.view.frame.size.width, 60);
    
    [self.view addSubview:self.overlayView];

  //  self.textField.inputView = _textColorPickerView;
//
    //[self.view bringSubviewToFront:_textColorPickerView];
    
   
}
- (void)keyBoardDidHide:(id)sender {
   //  NSLog(@"keyboard did hide");
   // [self.textLabel removeFromSuperview];
    self.textLabel.text = self.textField.text;
    [self.view bringSubviewToFront:self.textLabel];
    [self viewDidLayoutSubviews];
    self.textLabel.hidden = NO;
    [self.overlayView removeFromSuperview];
   // self.overlayView = nil;
   // self.textLabel.center = CGPointMake(100, 100);
    self.textField.hidden = YES;
   // [_textColorPickerView setFrameY:self.textColorPickerView.frame.origin.y - keyboardSize.height ];
    self.labelSmall.hidden = YES;
    self.labelLarge.hidden = YES;
  
    self.sliderSmallScreen.hidden = YES;
   
    self.sliderLargeScreen.hidden = YES;
    
    _textColorPickerView.frame = CGRectMake(0, self.viewContainer.frame.origin.y+10, self.view.frame.size.width, 60);
    
    
   
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


