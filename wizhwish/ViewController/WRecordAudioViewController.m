//
//  WRecordAudioViewControlleer.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-09.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#import "WRecordAudioViewController.h"

@interface WRecordAudioViewController ()<AVAudioRecorderDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WPhotoEditViewControllerDelegate>

@property(nonatomic ,retain) UILongPressGestureRecognizer *longPressGestureRecognizer;

@property(nonatomic ,retain) NSMutableDictionary *recordSetting;

@property(nonatomic ,retain) AVAudioRecorder *recorder;

@property(nonatomic) BOOL isRecording;

@property(nonatomic) BOOL isPause;

@property(nonatomic) BOOL isImported;

@property(nonatomic) NSInteger time;

@property(nonatomic ,retain) NSTimer *timer;

@property(nonatomic ,retain) AVAudioPlayer *audioPlayer;

@property(nonatomic ,retain) UIImagePickerController *imageController;

@property(nonatomic ,assign) BOOL isNextPressed;

@end

@implementation WRecordAudioViewController


#pragma mark - Private Methods

- (void)nextPressed {
    
    if (self.isNextPressed) {
        
        WWizhViewController *controller =  [[UIStoryboard getWhizStoryBoard] instantiateViewControllerWithIdentifier:K_SB_WIZH_VIEW_CONTROLLER];
        
        controller.showWhiz = NO;
        [[WSetting getSharedSetting] setAudioImage:self.mainImageView.image];
        [self.navigationController pushViewController:controller animated:YES];
    }
  
    else {
        
    
    [self.recorder stop];
    self.labelTime.hidden = YES;
    self.labelImport.hidden = NO;
    self.buttonImport.hidden = NO;
    self.imageConstraint.constant = 40;
    self.bottomView.hidden = NO;
    self.mainView.hidden = YES;
    self.isNextPressed = YES;
        
        self.navigationItem.rightBarButtonItem = [RUUtility getBarButtonWithTitle:@"Share" forViewController:self selector:@selector(nextPressed)];
  //  self.bottomViewHeight.constant = 50;
    }
    


}
#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    _longPressGestureRecognizer.numberOfTouchesRequired = 1;
    [_longPressGestureRecognizer setCancelsTouchesInView:NO];
    [self.buttonRecord addGestureRecognizer:_longPressGestureRecognizer];
    self.labelImport.hidden = YES;
    self.buttonImport.hidden = YES;
    self.bottomView.hidden = YES;
    [self.navigationItem setTitle:@"Audio"];
    
    self.navigationItem.leftBarButtonItem =  [RUUtility getBarButtonWithImage:[UIImage imageNamed:@"Image_Cross"] forViewController:self selector:@selector(crossPressed)];
    
    self.isRecording = NO;
    self.isPause = NO;

    [self.buttonPencil setImage:[UIImage imageNamed:@"Image_Pencil"] forState:UIControlStateNormal];
    [self.buttonPencil setImage:[UIImage imageNamed:@"Image_Text_Disable"] forState:UIControlStateNormal];
    
    
   // [self.buttonText setImage:nil forState:UIControlStateNormal];
   // [self.buttonText setImage:nil forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods

- (void)importPressed:(id)sender {
 
    self.imageController = [[UIImagePickerController alloc] init];
    self.imageController.delegate = self;
    //self.imageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imageController animated:YES completion:nil];
}

- (void)pencilPressed:(id)sender {
    
    if (self.isImported) {
        
    
    WPhotoEditViewController *controller = [[WPhotoEditViewController alloc] init];
    controller.delegate = self;
    controller.selectedImage = self.mainImageView.image;
    controller.selectedIndex = 0;
    controller.isDrawing = YES;
        
    controller.titleName = @"Audio";
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [RUUtility setUpNavigationBar:navController];
    [self presentViewController:navController animated:YES completion:nil];
    }

}

- (void)textPressed:(id)sender {
    if (self.isImported) {

    WPhotoEditViewController *controller = [[WPhotoEditViewController alloc] init];
    controller.delegate = self;
    controller.selectedImage = self.mainImageView.image;
    controller.selectedIndex = 0;
    controller.isDrawing = NO;
    controller.titleName = @"Audio";
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [RUUtility setUpNavigationBar:navController];
    [self presentViewController:navController animated:YES completion:nil];
    }
}

- (void)longPressed:(UIGestureRecognizer*)sender {

    switch (sender.state) {
        
case UIGestureRecognizerStateBegan:
    {
        if (!self.isRecording) {
            
            [self startRecording];
            self.isRecording = YES;
        }
        else {
            [self.recorder record];
        }
        self.isPause = NO;
        break;
    }
case UIGestureRecognizerStateEnded:
case UIGestureRecognizerStateCancelled:
case UIGestureRecognizerStateFailed:
    {
        [self.recorder pause];
        self.isPause = YES;
        break;
    }
default:
    break;
}


 }

- (void)crossPressed {
 
    if (_isImported) {
        
        self.navigationItem.leftBarButtonItem =  [RUUtility getBarButtonWithImage:[UIImage imageNamed:@"Image_Cross"] forViewController:self selector:@selector(crossPressed)];
        
        self.labelImport.hidden = NO;
        
        self.isImported = NO;
        
        self.bottomViewHeight.constant = 0;
        
        self.buttonImport.hidden = NO;
        
        self.mainImageView.image = [UIImage imageNamed:@"Image_Recording_Backgroud"];

    }
    else {
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}

- (void)startRecording {
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    [[WSetting getSharedSetting] setAudioURL:outputFileURL];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    self.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
    [self.recorder record];

    [self startTimer];
}


- (void) stopRecording {
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    [_recorder stop];
    
   // NSString *path = [[WSetting getSharedSetting] audioUrlPath];
   // NSError *err;
    //NSData *audioData = [NSData dataWithContentsOfFile:path options: 0 error:&err];
   // if(!audioData)
 //       NSLog(@"audio data: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
 //   [editedObject setValue:[NSData dataWithContentsOfURL:url] forKey:editedFieldKey];
    
    //[recorder deleteRecording];
    
    
    

    
    
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

- (void)rightButtonCanShow:(BOOL)show {
    
    if (show) {
        self.navigationItem.rightBarButtonItem =  [RUUtility getBarButtonWithImage:[UIImage imageNamed:@"Image_Next"] forViewController:self selector:@selector(nextPressed)];
        
    }
    else{
        
        self.navigationItem.rightBarButtonItem = nil;
    }
}


- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
    // your actions here
    
}

#pragma mark - UIImagePickerView Controller Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *capturedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.mainImageView.image = capturedImage;
    
    self.labelImport.hidden = YES;
    
    self.isImported = YES;
    
    self.bottomViewHeight.constant = 50;
    
    self.buttonImport.hidden = YES;

    self.navigationItem.leftBarButtonItem =  [RUUtility getBarButtonWithImage:[UIImage imageNamed:@"Image_Nav_Back"] forViewController:self selector:@selector(crossPressed)];


    
}

- (void)PhotoEditViewController:(WPhotoEditViewController *)viewController didSaveImage:(UIImage *)image withIndex:(NSInteger)index {
    
    self.mainImageView.image = image;
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
