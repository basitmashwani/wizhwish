//
//  WPhotoViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-12-10.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WPhotoViewController.h"
#import <UIImage+Extra.h>

@interface WPhotoViewController ()

@property(nonatomic ,retain) AVCaptureSession *session;

@property(nonatomic ,retain) AVCaptureDevice *device;

@property(nonatomic ,retain) AVCaptureStillImageOutput *imageOutput;

@property(nonatomic ,retain) AVCaptureVideoPreviewLayer *previewLayer;

@property(nonatomic ,retain) NSArray *filterArray;

@property(nonatomic ,retain) NSMutableArray *filterImageArray;

@property(nonatomic ,retain) UIImage *capturedImage;

@property(nonatomic ,retain) ACEDrawingView *drawingView;

@property(nonatomic ,retain) UIButton *eraseButton;

@property(nonatomic ,retain) UIImage *imagePencilCapture;

@property(nonatomic ,retain) HRColorMapView  *colorPicker;

@property(nonatomic ,retain) UIView *overlayView;

@property(nonatomic ,retain) UIImageView *pencilImageView;

@property(nonatomic ,retain)  UIPanGestureRecognizer *panGesture;

@property(nonatomic ,retain)  UITapGestureRecognizer *tapGesture;

@property(nonatomic) CGPoint  labelCGPoint;

@property(nonatomic ,retain)  UIImagePickerController *imageController;

@property(nonatomic ,retain) NSMutableArray *imagesArray;

@property(nonatomic ,retain) NSMutableArray *tempImagesArray;

@property(nonatomic) BOOL isLibrary;

@property(nonatomic) BOOL isFlashOn;

@property(nonatomic) NSInteger selectedIndex;

@property(nonatomic) BOOL isTextEdited;

@property(nonatomic) BOOL isFilterEdited;

@property(nonatomic) BOOL isPencilEdited;

@property(nonatomic) CGRect viewFrame;



@end

@implementation WPhotoViewController

#pragma mark Private Methods


- (void)nextPressed {
    
    WWizhViewController *controller =  [[UIStoryboard getWhizStoryBoard] instantiateViewControllerWithIdentifier:K_SB_WIZH_VIEW_CONTROLLER];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)updateCameraViewWithImage:(UIImage*)image {
 
    [self.imagesArray addObject:image];
    [self.tempImagesArray addObject:image];

    self.selectedIndex = self.imagesArray.count-1;
    
    for(int i = 0;i<self.imagesArray.count;i++) {
        
        UIImage *image = [self.imagesArray objectAtIndex:i];
        switch (i) {
            case 0:
                
                [self.firstImage setImage:image forState:UIControlStateNormal];
                break;
                
            case 1:
                
                [self.secondImage setImage:image forState:UIControlStateNormal];
                break;
                
            case 2:
                
                [self.thirdImage setImage:image forState:UIControlStateNormal];
                break;
                
            case 3:
                
                [self.fourthImage setImage:image forState:UIControlStateNormal];
                break;
                
            case 4:
                
                [self.fifthImage setImage:image forState:UIControlStateNormal];
                break;
                
            case 5:
                
                [self.sixImage setImage:image forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
        
    }
    
     self.navigationItem.rightBarButtonItem =  [RUUtility getBarButtonWithImage:[UIImage imageNamed:@"Image_Next"] forViewController:self selector:@selector(nextPressed)];
    self.viewContainer.hidden = NO;
    self.buttonFlash.hidden = YES;
    [self.mainImageView setHidden:NO];
    [self.mainImageView setImage:image];
    [self.cameraView bringSubviewToFront:self.mainImageView];
    [self.previewLayer removeFromSuperlayer];
    [self.collectionView reloadData];
    self.collectionView.hidden = NO;
    self.stackView.hidden = NO;
    [self.cameraView bringSubviewToFront:self.stackView];
    //[self addText:self.mainImageView.image text:@"Syed MAshwani"];
    

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



- (void)setUpCamera {
    
    self.buttonFlash.hidden = NO;
    self.viewContainer.hidden = YES;
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
    
    self.previewLayer.frame = self.cameraView.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.cameraView.layer addSublayer:self.previewLayer];
    
    //Start capture session
    [self.session startRunning];
    
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    self.imageOutput.outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecKey,AVVideoCodecJPEG, nil];
    if ([_session canAddOutput:self.imageOutput]) {
        [_session addOutput:self.imageOutput];
    }
    
    [self.cameraView bringSubviewToFront:self.buttonFlash];
}

#pragma mark Life Cycle Methods


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.filterArray = [[NSArray alloc] initWithObjects:@"No Filter" ,@"CIPhotoEffectChrome", @"CIPhotoEffectFade", @"CIPhotoEffectInstant", @"CIPhotoEffectMono", @"CIPhotoEffectNoir", @"CIPhotoEffectProcess", @"CIPhotoEffectTonal", @"CIPhotoEffectTransfer" , nil];
        
        self.filterImageArray = [[NSMutableArray alloc] init];
        self.imagesArray = [[NSMutableArray alloc] init];
        self.tempImagesArray = [[NSMutableArray alloc] init];
        
    }
    
    UIImage *sampleImage = [UIImage imageNamed:@"Image_Filter_Sample"];
    
    for (int  i = 0; i<self.filterArray.count; i++) {
    
        UIImage *image = [UIImage getFilterImageWithIndex:i withImage:sampleImage];
        [self.filterImageArray addObject:image];
        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [RUUtility setBackButtonForController:self withSelector:@selector(backPressed:)];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (!self.isLibrary) {
        //self.selectedIndex = 0;
        [self setUpCamera];
    }
    
    self.textLabel.text = @"";
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if (!CGPointEqualToPoint(self.labelCGPoint, CGPointZero)) {
        
        self.textLabel.center = self.labelCGPoint;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Public Methods

- (void)backPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
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
             NSLog(@"Attachments: %@", exifAttachments);
         }
         else
         {
             NSLog(@"No attachments found.");
         }
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         self.capturedImage = image;
         [self updateCameraViewWithImage:image];
         // NSLog(@"Image %@",imageData);
        // [[self vImage] setImage:image];
         
     }];
}

- (IBAction)switchCameraPressed:(id)sender {
 
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
            [self.buttonFlash setHidden:YES];
        }
        else
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            [self.buttonFlash setHidden:NO];
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

// Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found

}

- (IBAction)libraryPressed:(id)sender {
    
    self.isLibrary = YES;
    self.imageController = [[UIImagePickerController alloc] init];
    self.imageController.delegate = self;
    //self.imageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imageController animated:YES completion:nil];
    }

- (void)pencilPressed:(id)sender {
//
    self.isLibrary = YES;
    WPhotoEditViewController *controller = [[WPhotoEditViewController alloc] init];
    controller.delegate = self;
    controller.selectedImage = [self.imagesArray objectAtIndex:self.selectedIndex];
    controller.selectedIndex = self.selectedIndex;
    controller.isDrawing = YES;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [RUUtility setUpNavigationBar:navController];
    [self presentViewController:navController animated:YES completion:nil];

}
- (void)colorChanged:(id)sender {
    HRColorMapView *colorMap = (HRColorMapView*)sender;
    self.drawingView.lineColor = colorMap.color;
}

- (void)filterPressed:(id)sender {
    
   // self.textLabel.hidden = YES;
   // [self saveCurrentDrawingImageWithText:self.textLabel.text atIndex:self.selectedIndex];

    self.stackView.hidden = NO;
//    self.addButton.hidden = YES;
    self.pencilButton.selected = NO;
    self.textPencil.selected = NO;
    self.filterPencil.selected = YES;
    self.colorPicker.hidden = YES;
    [self.textLabel setUserInteractionEnabled:NO];
    [self.view sendSubviewToBack:self.drawingView];
    self.collectionView.hidden = NO;
    [self.collectionView reloadData];
   // [self addPencilWorkToView];
    self.mainImageView.image = [self.imagesArray objectAtIndex:self.selectedIndex];
   // [self saveCurrentDrawingImageAtIndex:self.selectedIndex];
}

- (void)textPressed:(id)sender {
    self.isLibrary = YES;

    WPhotoEditViewController *controller = [[WPhotoEditViewController alloc] init];
    controller.delegate = self;
    controller.isDrawing = NO;
    controller.selectedImage = [self.imagesArray objectAtIndex:self.selectedIndex];
    controller.selectedIndex = self.selectedIndex;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [RUUtility setUpNavigationBar:navController];
    [self presentViewController:navController animated:YES completion:nil];
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

- (IBAction)erasePressed:(id)sender {
    
}

- (IBAction)firstImagePressed:(id)sender {
 
    if (self.imagesArray.count>0) {
        
    
    self.selectedIndex = 0;
    UIImage *image = [self.imagesArray objectAtIndex:self.selectedIndex];
    self.capturedImage = image;
    self.mainImageView.image = self.capturedImage;
    
    }
}

- (IBAction)secondImagePressed:(id)sender {
    
    if (self.imagesArray.count>1) {

    self.selectedIndex = 1;
    UIImage *image = [self.imagesArray objectAtIndex:self.selectedIndex];
    self.capturedImage = image;

    self.mainImageView.image = self.capturedImage;

    }
}

- (IBAction)thirdImagePressed:(id)sender {
    
    if (self.imagesArray.count>2) {

    self.selectedIndex = 2;
    UIImage *image = [self.imagesArray objectAtIndex:self.selectedIndex];
    self.capturedImage = image;
    self.mainImageView.image = self.capturedImage;

    }
}

- (IBAction)fourthImagePressed:(id)sender {
    
    if (self.imagesArray.count>3) {

    self.selectedIndex = 3;
    UIImage *image = [self.imagesArray objectAtIndex:self.selectedIndex];
    self.capturedImage = image;
    self.mainImageView.image = self.capturedImage;

    }
}
- (IBAction)fifthImagePressed:(id)sender {
    
    if (self.imagesArray.count>4) {

    self.selectedIndex = 4;
    UIImage *image = [self.imagesArray objectAtIndex:self.selectedIndex];
    self.capturedImage = image;
    self.mainImageView.image = self.capturedImage;

    }
}
- (IBAction)sixImagePressed:(id)sender {
    
    if (self.imagesArray.count>5) {

    self.selectedIndex = 5;
    UIImage *image = [self.imagesArray objectAtIndex:self.selectedIndex];
    self.capturedImage = image;
    self.mainImageView.image = self.capturedImage;

    }
}
- (IBAction)addImagePressed:(id)sender {
    
    [self setUpCamera];
}



#pragma mark PhotoEditController Delegate Methods

- (void)PhotoEditViewController:(WPhotoEditViewController *)viewController didSaveImage:(UIImage *)image withIndex:(NSInteger)index {
    
    [self.imagesArray replaceObjectAtIndex:index withObject:image];
    [self.tempImagesArray replaceObjectAtIndex:index withObject:image];
    self.mainImageView.image = image;
    [self updateImageArrayWithImage:image atIndex:index];
    self.selectedIndex = index;
}


- (void)updateImageArrayWithImage:(UIImage*)image atIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
            
            [self.firstImage setImage:image forState:UIControlStateNormal];
            break;
            
        case 1:
            [self.secondImage setImage:image forState:UIControlStateNormal];
            
            
            break;
            
        case 2:
            [self.thirdImage setImage:image forState:UIControlStateNormal];
            
            
            break;
            
        case 3:
            [self.fourthImage setImage:image forState:UIControlStateNormal];
            
            
            break;
            
        case 4:
            [self.fifthImage setImage:image forState:UIControlStateNormal];
            
            
            break;
            
        case 5:
            [self.sixImage setImage:image forState:UIControlStateNormal];
            
            
            break;
            
        default:
            break;
    }

}

#pragma mark UIImageController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.capturedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *data = UIImagePNGRepresentation(self.capturedImage);
    UIImage *tmpImage = [UIImage imageWithData:data];
    UIImage *afterFixingOrientation = [UIImage imageWithCGImage:tmpImage.CGImage
                                                          scale:self.capturedImage.scale
                                                    orientation:self.capturedImage.imageOrientation];
    self.capturedImage = afterFixingOrientation;
    
    [self updateCameraViewWithImage:self.capturedImage];
}

#pragma mark UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
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

    //[self saveCurrentDrawingImageAtIndex:self.selectedIndex];
    
}

- (void)drawingView:(ACEDrawingView *)view willBeginDrawUsingTool:(id<ACEDrawingTool>)tool {
    
}






#pragma mark Collection View Delegate Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WZFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewFilter" forIndexPath:indexPath];

    UIImage *image = [self.filterImageArray objectAtIndex:indexPath.row];
    [cell.buttonPeople setImage:image forState:UIControlStateNormal];
    
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.filterArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.addButton.hidden = YES;
    UIImage *image = [self.tempImagesArray objectAtIndex:self.selectedIndex];
  //  image =  [UIImage getFilterImageWithIndex:0 withImage:image];
   UIImage *filteredImage =  [UIImage getFilterImageWithIndex:indexPath.row withImage:image];
    
    self.mainImageView.image = filteredImage;
    //self.mainImageView.image =[filteredImage fixOrientation];

    [self updateImageArrayWithImage:filteredImage atIndex:self.selectedIndex];
    [self.imagesArray replaceObjectAtIndex:self.selectedIndex withObject:filteredImage];
    //NSLog(@"Selected Index is %ld",(long)self.selectedIndex);
    //[self.imagesArray replaceObjectAtIndex:self.selectedIndex withObject:filteredImage];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

