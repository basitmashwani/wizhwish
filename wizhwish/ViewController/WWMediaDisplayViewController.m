//
//  WWMediaDisplayViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-08-06.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#define k_PENCIL_TYPE  111

#define k_TEXTVIEW_TYPE    222

#import "WWMediaDisplayViewController.h"
#import "KIImagePager.h"

@interface WWMediaDisplayViewController()<TOCropViewControllerDelegate,KIImagePagerDelegate,KIImagePagerDataSource,UICollectionViewDelegate,UICollectionViewDataSource,SCPlayerDelegate,ColorPickerViewDelegate,ColorPickerViewDelegateFlowLayout,ACEDrawingViewDelegate,SCPlayerDelegate,UITextViewDelegate,WPhotoEditViewControllerDelegate,WWStickerViewControllerDelegate>

@property(nonatomic ,retain) UIImageView *mainImageView;

@property(nonatomic ,retain) UILabel *label;

@property(nonatomic ,retain) KIImagePager *imagePager;

@property(nonatomic ,retain) NSArray *filterArray;

@property(nonatomic ,retain) NSMutableArray *filterImageArray;

@property(nonatomic ,retain) SCPlayer *scPlayer;

@property(nonatomic ,retain) SCFilterImageView *videoPlayerFilter;

@property(nonatomic ,retain) ACEDrawingView *drawingView;

@property(nonatomic ,retain) ColorPickerView *colorPickerView;

@property(nonatomic ,retain) UIImageView *imageViewPencil;

@property(nonatomic ,retain) UITextView *textView;

@property(nonatomic ,retain) UIPanGestureRecognizer *panGesture;

@property(nonatomic ,retain) UIPanGestureRecognizer *stickerPanGesture;

@property(nonatomic ,retain) UITapGestureRecognizer *tapGesture;

@property(nonatomic ,assign) CGPoint labelCGPoint;

@property(nonatomic ,retain) NSMutableArray *stickerArray;

@property(nonatomic ,retain) NSMutableArray *textArray;

@property(nonatomic ,retain) UIColor *selectedColor;

@property(nonatomic ,assign) BOOL isStickerAdded;








@end

@implementation WWMediaDisplayViewController

#pragma mark - Life Cycle Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.imageArray = [[NSMutableArray alloc] init];

        self.filterImageArray = [[NSMutableArray alloc] init];

        self.stickerArray = [[NSMutableArray alloc] init];

        self.textArray = [[NSMutableArray alloc] init];

        
        self.filteredImage = [UIImage imageNamed:@"Image_Filter_Sample"];
        

        
        self.filterArray = [[NSArray alloc] initWithObjects:@"No Filter" ,@"CIPhotoEffectChrome", @"CIPhotoEffectFade", @"CIPhotoEffectInstant", @"CIPhotoEffectMono", @"CIPhotoEffectNoir", @"CIPhotoEffectProcess", @"CIPhotoEffectTonal", @"CIPhotoEffectTransfer" , nil];
    }
    
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initControls];



    [self.cropButton addShadow];
    
    [self.pencilButton addShadow];
    
    [self.textButton addShadow];
    
    [self.addButton addShadow];
    
    [self.stickerButton addShadow];
    
    [self.crossButton addShadow];
    
    [self.saveButton addShadow];
    
    [self.nextButton addShadow];
    
    self.selectedIndex = 0;
    
    if (self.displayMode == kWShowImageMode) {
        
        
        _imagePager = [[KIImagePager alloc] initWithFrame:self.view.frame];
        
        [self.view addSubview:_imagePager];
        
        [self.view sendSubviewToBack:self.imagePager];
        
        _imagePager.delegate = self;
        
        _imagePager.dataSource = self;
        
        
        _imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        
        _imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
        
        [_imagePager reloadData];
        
        [self.view bringSubviewToFront:self.collectionView];
        
        //[self.collectionView addShadow];
        
        [self.collectionView reloadData];
        
        
    }
    else if (self.displayMode == kWShowVideoMode) {
        
        //Video Mode
        [self.view bringSubviewToFront:self.collectionView];
        
       
        
        //[self.collectionView addShadow];
        
    //    [self.collectionView reloadData];

    }
    
   
    
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES];
   
    
}

- (void)initControls {
    
    
    self.selectedColor = [UIColor whiteColor];
    
    if (!self.drawingView) {
        
        self.drawingView = [[ACEDrawingView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-100)];
        self.drawingView.lineColor = [UIColor whiteColor];
        
        self.drawingView.delegate = self;
        [self.drawingView setAlpha:0.0];
        
        
        [self.view addSubview:_drawingView];
        
        
    }
    
    if (!self.colorPickerView) {
        self.colorPickerView = [[ColorPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height , self.view.frame.size.width, 50)];
        self.colorPickerView.delegate = self;
        
        [self.view addSubview:self.colorPickerView];
        
        
    }
    
    
    self.imageViewPencil = [[UIImageView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:self.imageViewPencil];
    
    
    [self.imageViewPencil fadeOutWithCompletion:nil];
    
    
    if (!self.textView) {
        
        self.textView = [[UITextView alloc] init];
        [self.textView setFrameWidth:self.view.frame.size.width];
        [self.textView setFrameHeight:self.view.center.y-20];
        self.textView.delegate = self;
        self.textView.text = @"Text";
        [self.textView setFont:[UIFont fontWithName:@"MicrosoftPhagsPa" size:28]];
        
        //  self.textField.placeholder = @"Text";
        self.textView.textAlignment = NSTextAlignmentCenter;
        [self.textView setCenter:CGPointMake(self.view.center.x, self.view.center.y-100)];
        [self.textView setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.textView.textColor = [UIColor whiteColor];
        self.textView.backgroundColor = [UIColor clearColor];
        
        [self.textView fadeOutWithCompletion:nil];
        [self.view addSubview:self.textView];
        
        // self.textField.hidden = YES;
        //[self.textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];

        CGFloat topCorrect = ([self.textView bounds].size.height - [self.textView  contentSize].height * [self.textView zoomScale])/2.0;
        topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
        [self.textView setContentInset:UIEdgeInsetsMake(topCorrect,0,0,0)];
        
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector (keyBoardDidShow:)
                                                     name: UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector (keyBoardDidHide:)
                                                     name: UIKeyboardDidHideNotification
                                                   object:nil];
        
    }
    
    

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv     contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    [tv setContentInset:UIEdgeInsetsMake(topCorrect,0,0,0)];
}


- (BOOL)prefersStatusBarHidden {
    
    return  YES;
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (!self.isStickerAdded)
    {
    if (self.displayMode == kWShowImageMode) {
        
    [self.imagePager setCurrentPage:self.selectedIndex];

    if ([[[WSetting getSharedSetting] imageArray] count] >= 5) {
        
        self.addButton.enabled = NO;
        self.addButton.alpha = 0.7;
        
    }

  NSMutableArray *imagesArray = [[WSetting getSharedSetting] imageArray];
    
    self.tempImageArray = [imagesArray copy];
    
    [self.collectionView reloadData];
            
    [self.imagePager setCurrentPage:self.selectedIndex animated:YES];
    
    } else if (self.displayMode == kWShowVideoMode) {
        
        //video
        __weak typeof(self) weakSelf = self;
        
        NSString *urlPath = [[WSetting getSharedSetting] frontVideoUrlPath];
        
        NSURL *videoURL = [NSURL fileURLWithPath:urlPath];
        
        [RUUtility generateVideoThumbnail:videoURL success:^(UIImage *image) {
            
            weakSelf.filteredImage = image;

            
        }];
        [self addVideoPlayerWithURL:videoURL];
        
        [self.view bringSubviewToFront:weakSelf.collectionView];
        
        [self.view bringSubviewToFront:self.crossButton];
        
        [self.view bringSubviewToFront:self.pencilButton];
        
        [self.view bringSubviewToFront:self.stickerButton];
        
        [self.view bringSubviewToFront:self.textButton];
        
        [self.view bringSubviewToFront:self.cropButton];
        
      //  [self.view bringSubviewToFront:self.addButton];

        [self.view bringSubviewToFront:self.saveButton];

        [self.view bringSubviewToFront:self.nextButton];
        
        
    }
        
    

    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods



- (void)showRemoveButtonView {
    
    [self hideAllButtons:YES];
    [self.textButton fadeOutWithCompletion:nil];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    view.tag = 124;
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
}

- (void)hideRemoveButtonView {
    [self hideAllButtons:NO];
    [self.textButton fadeInWithCompletion:nil];

   UIView *rView = [self.view viewWithTag:124];
    [rView removeFromSuperview];
}
- (void)addLabelToView {
    
    UILabel *label = nil;
    if (self.label != nil) {
        label = self.label;
        [self.label fadeInWithCompletion:nil];
       // self.label = nil;
    }
    else {
    label = [[UILabel alloc] init];
    [self.view addSubview:label];
        
    [self.view bringSubviewToFront:label];
        
    [self.textArray addObject:label];
        
    }
    
    
    
    CGSize contentSize = [self.textView.text sizeWithFont:self.textView.font constrainedToSize:CGSizeMake(300, 300) lineBreakMode:NSLineBreakByWordWrapping];
    

    CGFloat xAxis = contentSize.width/2;
    [label setCenter:CGPointMake(self.view.center.x - xAxis, self.textView.center.y)];
    // [label setCenter:CGPointMake(self.textView.contentSize.width/4,self.textView.center.y)];
    
    [label setFrameWidth:contentSize.width];
    [label setFrameHeight:contentSize.height];

    
    label.font = self.textView.font;
    
    label.numberOfLines = 0;
    
    label.textColor = self.selectedColor;
    
    
    label.text = self.textView.text;
    
//    UIFont *font = self.textView.font;
//    CGSize size = [self.textView.text sizeWithAttributes:
//                   @{NSFontAttributeName: font}];
//    
//    [label setFrameHeight:size.height];
//    
//    [label setFrameWidth:size.width];
   label.textAlignment = NSTextAlignmentCenter;
//    // self.isStickerAdded = NO;
//    label.numberOfLines = 0;
//    [label setCenter:CGPointMake(size.width/2, label.center.y)];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(labelChange:)];
    
    [label setUserInteractionEnabled:YES];
    
    panGesture.cancelsTouchesInView = NO;
    
    [label addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelPressed:)];
    
    [label setUserInteractionEnabled:YES];
    
    tapGesture.cancelsTouchesInView = NO;
    
    [label addGestureRecognizer:tapGesture];
}

- (void)addStickerToView:(UIImage*)stickerImage {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    [imageView setFrameHeight:150];
  
    [imageView setFrameWidth:150];
    
    [imageView setCenter:self.view.center];
    
    [imageView setImage:stickerImage];
    
    [self.view addSubview:imageView];
    
    [self.view bringSubviewToFront:imageView];
    
    [imageView.layer setBorderWidth:2.0];
    
    imageView.layer.borderColor = [[UIColor redColor] CGColor];
    
    [self.stickerArray addObject:imageView];
    
   // self.isStickerAdded = NO;
    
    self.stickerPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stickerChange:)];
    
    [imageView setUserInteractionEnabled:YES];
    
    self.stickerPanGesture.cancelsTouchesInView = NO;
    
    [imageView addGestureRecognizer:_stickerPanGesture];
    
}

- (void)labelPressed:(id)sender {
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)sender;
    self.label = (UILabel*)[tapGesture view];
    [self.label fadeOutWithCompletion:nil];
    [self showTextView];

}

- (void)labelChange:(id)sender {
    
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer*)sender;
    self.labelCGPoint = [recognizer locationInView:self.view];
    
    UILabel *myLabel = (UILabel*)[recognizer view];
    
     if (recognizer.state == UIGestureRecognizerStateEnded) {
      
         [self hideRemoveButtonView];
     }
     else if (recognizer.state == UIGestureRecognizerStateBegan) {
         
         [self showRemoveButtonView];
     }
    CGRect rect = CGRectMake(self.view.frame.origin.x-8, self.view.frame.origin.y - 8, self.view.frame.size.width - 8, self.view.frame.size.height - 8);
    
    if (CGRectContainsPoint(rect, self.labelCGPoint)) {
        
        myLabel.center = self.labelCGPoint;
        
    }
    
    // }
    
}

- (void)stickerChange:(id)sender {
    
    
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer*)sender;
    
   UIImageView *imgView = (UIImageView*) [recognizer view];
    CGPoint point = [recognizer locationInView:self.view];
    
    // if (recognizer.state == UIGestureRecognizerStateEnded) {
    CGRect rect = CGRectMake(self.view.frame.origin.x-8, self.view.frame.origin.y - 8, self.view.frame.size.width - 8, self.view.frame.size.height - 8);
    
    if (CGRectContainsPoint(rect, point)) {
        
        imgView.center = point;
        
    }
    
    // }
    
}

- (void)addVideoPlayerWithURL:(NSURL*)videoURL {
    
    _scPlayer = [SCPlayer player];
    
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    
    _scPlayer.shouldSuppressPlayerRendering = YES;
    
    [_scPlayer  setItemByAsset:asset];
    
    _scPlayer.volume = 0.0;
    [_scPlayer play];
    _scPlayer.delegate = self;
    
    SCVideoPlayerView *videoPlayerView = [[SCVideoPlayerView alloc] initWithFrame:self.view.frame];
    [videoPlayerView setFrameX:0.0];
    [videoPlayerView setFrameY:0.0];
    [self.view addSubview:videoPlayerView];
    
    
    videoPlayerView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    self.videoPlayerFilter = [[SCFilterImageView alloc] initWithFrame:self.view.bounds];
    
    self.videoPlayerFilter.filter = [SCFilter emptyFilter];
    
    //
    
    _scPlayer.SCImageView = self.videoPlayerFilter;
    
    //
  [self.view addSubview:self.videoPlayerFilter];
    
    [self.view bringSubviewToFront:self.collectionView];
    
    [self.collectionView reloadData];
    
    

}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer {
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        NSLog(@"Left");
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        
        NSLog(@"Right");
    }
}

#pragma mark - Public Methods



- (IBAction)pencilPressed:(id)sender {

    if (self.displayMode == kWShowImageMode) {
    WPhotoEditViewController *controller = [[WPhotoEditViewController alloc] init];
    controller.delegate = self;
    controller.selectedImage = [[[WSetting getSharedSetting] imageArray] objectAtIndex:self.selectedIndex];
    controller.selectedIndex = self.selectedIndex;
    controller.isDrawing = YES;
    controller.titleName = @"photo";
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [RUUtility setUpNavigationBar:navController withColor:[UIColor navigationBarColor]];
    [self presentViewController:navController animated:YES completion:nil];
    }
    else if (self.displayMode == kWShowVideoMode) {
        
        [self showDrawingView];
        
    }

}


- (void)hideAllButtons:(BOOL)isHide {
    
    if (isHide) {
    
        
        [self.stickerButton fadeOutWithCompletion:nil];
        
        [self.pencilButton fadeOutWithCompletion:nil];
        
        [self.cropButton fadeOutWithCompletion:nil];
        
        [self.nextButton fadeOutWithCompletion:nil];
        
        [self.saveButton fadeOutWithCompletion:nil];
        
        [self.crossButton fadeOutWithCompletion:nil];

        
        
    
        
    }
    else {
     
        [self.stickerButton fadeInWithCompletion:nil];
        
        [self.pencilButton fadeInWithCompletion:nil];
        
        [self.cropButton fadeInWithCompletion:nil];
        
        [self.nextButton fadeInWithCompletion:nil];
        
        [self.saveButton fadeInWithCompletion:nil];

        [self.crossButton fadeInWithCompletion:nil];



    }
}

- (void)hideDrawingView {
    
    [self.drawingView fadeOutWithCompletion:nil];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.colorPickerView.center = CGPointMake(self.colorPickerView.center.x, self.colorPickerView.center.y + 50);
    }];
    
    [self hideAllButtons:NO];
    
    self.crossButton.tag = 0;
    
    [self.crossButton setImage:[UIImage imageNamed:@"Image_Cross"] forState:UIControlStateNormal];
    
    self.textButton.tag = 0;
    
    [self.textButton setImage:[UIImage imageNamed:@"Image_Text"] forState:UIControlStateNormal];
    
    [self.view bringSubviewToFront:self.imageViewPencil];
    [self.imageViewPencil fadeInWithCompletion:nil];
    
}


- (void)showTextView {

    [self hideAllButtons:YES];
    
    [self.collectionView fadeOutWithCompletion:nil];
    
    [self.textButton setImage:[UIImage imageNamed:@"Image_Next"] forState:UIControlStateNormal];
    
    [self.crossButton setImage:[UIImage imageNamed:@"Image_Eraser"] forState:UIControlStateNormal];
    
    self.textButton.tag = k_TEXTVIEW_TYPE;
    
    [self.view bringSubviewToFront:self.colorPickerView];
    
    self.crossButton.tag = k_TEXTVIEW_TYPE;
    
    [self.view bringSubviewToFront:self.textView];

    [self.view setAlpha:0.8];
    
   [self.textView becomeFirstResponder];

    [self.textView fadeInWithCompletion:nil];



    
}
- (void)hideTextView {
    
    [self.textView resignFirstResponder];
    
    [self.textView fadeOutWithCompletion:nil];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.colorPickerView.center = CGPointMake(self.colorPickerView.center.x, self.colorPickerView.center.y + 50);
    }];
    
    [self hideAllButtons:NO];
    
    self.crossButton.tag = 0;
    
    [self.crossButton setImage:[UIImage imageNamed:@"Image_Cross"] forState:UIControlStateNormal];
    
    self.textButton.tag = 0;
    
    [self.textButton setImage:[UIImage imageNamed:@"Image_Text"] forState:UIControlStateNormal];
    
   
   
        [self addLabelToView];
}

- (void)showDrawingView {
    [self hideAllButtons:YES];
    
    [self.collectionView fadeOutWithCompletion:nil];
    
    [self.textButton setImage:[UIImage imageNamed:@"Image_Next"] forState:UIControlStateNormal];
    
    [self.crossButton setImage:[UIImage imageNamed:@"Image_Eraser"] forState:UIControlStateNormal];
    
    self.textButton.tag = k_PENCIL_TYPE;
    
    [self.view bringSubviewToFront:self.drawingView];
    
    [self.view bringSubviewToFront:self.colorPickerView];
    
    [self.drawingView fadeInWithCompletion:nil];
    
    self.crossButton.tag = k_PENCIL_TYPE;
    
    [UIView animateWithDuration:1.0 animations:^{
    
        self.colorPickerView.center = CGPointMake(self.colorPickerView.center.x, self.colorPickerView.center.y - 50);
    }];
    
    
    if ([self.drawingView canUndo]) {
        [self.crossButton fadeInWithCompletion:nil];
    }
    
    [self.imageViewPencil fadeOutWithCompletion:nil];
    
    
    


}
- (IBAction)stickerPressed:(id)sender {
    
    WWStickerViewController *controller = [[UIStoryboard getMediaStoryBoard] instantiateViewControllerWithIdentifier:k_SB_STICKER_VC];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    
    self.isStickerAdded = YES;
    
    controller.delegate = self;
    
    [self presentViewController:navController animated:YES completion:nil];
}



- (IBAction)textPressed:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    
    if (button.tag == k_PENCIL_TYPE) {
        
        [self hideDrawingView];
    }
    else if (button.tag == k_TEXTVIEW_TYPE) {
    
        
        [self hideTextView];
        
    }
    
    else {
       
       if (self.displayMode == kWShowImageMode) {
        WPhotoEditViewController *controller = [[WPhotoEditViewController alloc] init];
   
        controller.delegate = self;
        
        controller.selectedImage = [[[WSetting getSharedSetting] imageArray] objectAtIndex:self.selectedIndex];
    
        controller.selectedIndex = self.selectedIndex;
    
        controller.isDrawing = NO;
    
        controller.titleName = @"photo";
    
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
        [RUUtility setUpNavigationBar:navController withColor:[UIColor navigationBarColor]];
    
        [self presentViewController:navController animated:YES completion:nil];
    }
    else if (self.displayMode == kWShowVideoMode) {
        
        
        [self showTextView];
    }
        
    }
}

- (IBAction)cropPressed:(id)sender {

    
    UIImage *selectedImage = [[[WSetting getSharedSetting] imageArray] objectAtIndex:self.selectedIndex];
    
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:selectedImage];
  //  cropController.showActivitySheetOnDone = YES;
    cropController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:cropController];
    //[RUUtility setUpNavigationBar:navController withColor:[UIColor navigationBarColor]];
    [self presentViewController:navController animated:YES completion:nil];
    

}

- (IBAction)addPhotoPressed:(id)sender {

  WWCameraViewController *controler = (WWCameraViewController*)[self backViewController];
    
    controler.isAddImage = YES;
    
    controler.cameraMode = kWPhotoMode;
    
    controler.index = self.selectedIndex+1;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closePressed:(id)sender {

    UIButton *button = (UIButton*)sender;
    WWCameraViewController *controller = (WWCameraViewController*)[self backViewController];
   
    if (button.tag != k_PENCIL_TYPE) {
    if (self.displayMode == kWShowImageMode) {
    controller.isAddImage = NO;
    
    controller.cameraMode = kWPhotoMode;
    
    controller.index = self.selectedIndex;
    
    } else if(self.displayMode == kWShowVideoMode) {
        
        controller.cameraMode = kWVideoMode;
        
    }

    [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        if ([self.drawingView canUndo]) {
            
            [self.drawingView undoLatestStep];
            
            if (!self.drawingView.canUndo) {
                [self.crossButton fadeOutWithCompletion:nil];

            }
        }
        else {
            
            [self.crossButton fadeOutWithCompletion:nil];
        }
    }

}

- (IBAction)savePressed:(id)sender {
    
    UIImage *image = [[[WSetting getSharedSetting] imageArray] objectAtIndex:self.selectedIndex];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [OLGhostAlertView showAlertAtBottomWithTitle:@"" message:@"Image saved to gallary."];
}

#pragma mark - SCPlayer Delegate Methods

- (void)player:(SCPlayer *)player didReachEndForItem:(AVPlayerItem *)item {
    
    [player seekToTime:kCMTimeZero];
    [player play];
}

#pragma mark - Drawing View Delegate Methods
- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool {

    if (view.canUndo) {
        
        [self.crossButton fadeInWithCompletion:nil];
        
    }
    
    [self.imageViewPencil setImage:view.image];
}

- (void)drawingView:(ACEDrawingView *)view didUndoDrawUsingTool:(id<ACEDrawingTool>)tool {

    [self.imageViewPencil setImage:view.image];

}


#pragma mark - ColorPicker Delegate Methods

- (CGSize)colorPickerView:(ColorPickerView *)colorPickerView sizeForItemAt:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.view.frame.size.width/10, 50);
}
- (void)colorPickerView:(ColorPickerView *)colorPickerView didSelectItemAt:(NSIndexPath *)indexPath {
    
    if (self.drawingView.alpha == 1) {
  
        self.drawingView.lineColor = [colorPickerView.colors objectAtIndex:indexPath.row];
    }
    else {
        
        self.textView.textColor = [colorPickerView.colors objectAtIndex:indexPath.row];

        self.selectedColor = [colorPickerView.colors objectAtIndex:indexPath.row];

    }
}
#pragma mark - Crop Controller Delegate Methods

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(nonnull UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    
    [[[WSetting getSharedSetting] imageArray] replaceObjectAtIndex:self.selectedIndex withObject:image];
    
   // [self.tempImageArray replaceObjectAtIndex:self.selectedIndex withObject:image];

    [self.imagePager reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WPhoto Edit Controller Delegate Methods

- (void)PhotoEditViewController:(WPhotoEditViewController *)viewController didSaveImage:(UIImage *)image withIndex:(NSInteger)index {
    
    [[[WSetting getSharedSetting] imageArray] replaceObjectAtIndex:index withObject:image];
    
   // [self.tempImageArray replaceObjectAtIndex:self.selectedIndex withObject:image];

    
    [self.imagePager reloadData];

    
    
    
    
}

#pragma mark - KIImagePager Delegate Methods

- (NSArray *)arrayWithImages:(KIImagePager *)pager {
    
    NSMutableArray *mArray = [[WSetting getSharedSetting] imageArray];
   
    if (mArray.count<2)
        pager.imageCounterDisabled = YES;
    
    return [[NSArray alloc] initWithArray:mArray];

}

- (UIViewContentMode)contentModeForPlaceHolder:(KIImagePager *)pager {
   
    return UIViewContentModeScaleToFill;
}

- (UIViewContentMode)contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager {
    
    return UIViewContentModeScaleToFill;
}
- (NSString *)captionForImageAtIndex:(NSUInteger)index inPager:(KIImagePager *)pager {
    
    return @"";
}

- (void)imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index {
    
    self.selectedIndex = index;
    
    [self.collectionView reloadData];
}


#pragma mark Collection View Delegate Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WZFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewFilter" forIndexPath:indexPath];
    
    if ([[WSetting getSharedSetting] imageArray].count > 0) {
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Add code here to do background processing
            //
            //
            UIImage *image =  [self.tempImageArray objectAtIndex:self.selectedIndex]; //[[[WSetting getSharedSetting] imageArray] objectAtIndex:self.selectedIndex];
          
            image  = [UIImage getFilterImageWithIndex:indexPath.row withImage:image];
            //  [cell.buttonPeople setImage:image forState:UIControlStateNormal];
            
            
            dispatch_async( dispatch_get_main_queue(), ^{
                // Add code here to update the UI/send notifications based on the
                // results of the background processing
                
                [cell.buttonPeople addShadow]; 
                [cell.buttonPeople setImage:image forState:UIControlStateNormal];
                
            });
        });
        
        
    }
    else if (self.filteredImage != nil) {
        
        __block UIImage *image = nil;
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Add code here to do background processing
            if (!self.filteredImage) {
                
                CIImage *filterImage = [self.filterArray objectAtIndex:indexPath.row];
                
                image = [[UIImage alloc] initWithCIImage:filterImage];
            }
            else {
                
                
                image = [UIImage getFilterImageWithIndex:indexPath.row withImage:self.filteredImage];
                
            }
            
            dispatch_async( dispatch_get_main_queue(), ^{
                // Add code here to update the UI/send notifications based on the
                // results of the background processing
                [cell.buttonPeople setImage:image forState:UIControlStateNormal];
              
                
            });
        });
        
    
    }
    
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.filterArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.displayMode == kWShowImageMode) {
    UIImage *image =   [self.tempImageArray objectAtIndex:self.selectedIndex];
  
    UIImage *filteredImage =  [UIImage getFilterImageWithIndex:indexPath.row withImage:image];
    
    [[[WSetting getSharedSetting] imageArray] replaceObjectAtIndex:self.selectedIndex withObject:filteredImage];
    
     [self.imagePager reloadData];
    }
    else if (self.displayMode == kWShowVideoMode) {
        
        NSString *filterName = [self.filterArray objectAtIndex:indexPath.row];
        
        self.videoPlayerFilter.filter = [SCFilter filterWithCIFilterName:filterName];
        
        self.scPlayer.SCImageView = self.videoPlayerFilter;
        
    }
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

#pragma mark UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView {
    
    textView.text = [textView.text stringByReplacingOccurrencesOfString:@"Text" withString:@""];
   
    

}



#pragma KeyBoard Delegate Methods
- (void)keyBoardDidShow:(id)sender {
    
    NSLog(@"Keyboard did show");
    
    CGSize keyboardSize = [[[sender userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.colorPickerView.center = CGPointMake(self.colorPickerView.center.x, self.colorPickerView.center.y -  self.colorPickerView.center.y +120+keyboardSize.height);
    }];

  //  self.colorPickerView.frame = CGRectMake(0, keyboardSize.height+80, self.view.frame.size.width, 30);
}
- (void)keyBoardDidHide:(id)sender {
    
    CGSize keyboardSize = [[[sender userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    [UIView animateWithDuration:0 animations:^{
        
        self.colorPickerView.center = CGPointMake(self.colorPickerView.center.x, self.colorPickerView.center.y +  self.colorPickerView.center.y +120+keyboardSize.height);
    }];
    
    
    
}


#pragma mark - StickerViewController Delegate Methods

- (void)StickerViewController:(WWStickerViewController *)controller didStickerSelected:(UIImage *)stickerImage {
    
    [controller.navigationController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"image recieved");
    [self addStickerToView:stickerImage];
}




@end

