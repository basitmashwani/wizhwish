
//
//  WWishListViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-19.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "WWishListViewController.h"

@interface WWishListViewController ()<UITextFieldDelegate>

@property(nonatomic ,retain) NSMutableArray *standardLinkArray;

@property(nonatomic ,retain) NSString *firstVideoURL;

@property(nonatomic ,retain) NSString *secondVideoURL;

@property(nonatomic ,retain) NSString *audioURL;

@property(nonatomic ,retain) NSString *audioImageURL;

@property(nonatomic ,assign) BOOL isNextPressed;






@property(nonatomic ,retain) NSTimer *timer;

@end

@implementation WWishListViewController

#pragma mark - Life Cycle Methods


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self  = [super initWithCoder:aDecoder];
    
    self.standardLinkArray = [[NSMutableArray alloc] init];
  
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyBoardDidShow:)
                                                 name: UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyBoardDidHide:)
                                                 name: UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imagesUploaded)
                                                 name:@"imagesUploaded"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videosUploaded)
                                                 name:@"videosUploaded"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioUploaded)
                                                 name:@"audioUploaded"
                                               object:nil];
    
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:@"imagesUploaded"];

    [[NSNotificationCenter defaultCenter] removeObserver:@"videosUploaded"];

    [[NSNotificationCenter defaultCenter] removeObserver:@"audioUploaded"];

   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [RUUtility getBarButtonWithImage:[UIImage imageNamed:@"Image_Next"] forViewController:self selector:@selector(nextPressed)];
    
    [self didTappedView:self.view];
    
    if ([[WSetting getSharedSetting] firstOutputUrl].length > 0) {
        [self uploadVideos];
    }
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Private Methods

- (void)uploadVideos {
    
    BOOL isTwiceVideo = NO;
    
    
    //upload video files
    NSLog(@"First File name %@",[[WSetting getSharedSetting] firstVideoFileName]);
    
    NSString *fileName = [[WSetting getSharedSetting] firstVideoFileName];
    
    NSString *filePath = [[WSetting getSharedSetting] firstOutputUrl];
    
    //   NSURL *url = [NSURL fileURLWithPath:filePath];
    
    //  NSData *newDataForUpload = [NSData dataWithContentsOfURL:url];
    //NSLog(@"Size of new Video after compression is (bytes):%lu",[newDataForUpload length]/1024);
    
    __weak typeof(self) weakSelf = self;
    [[WZServiceParser sharedParser] processUploadFileAWSWithfilePath:filePath fileName:fileName success:^(NSString *fileName) {
        
        NSLog(@"first file uploaded");
        [[WSetting getSharedSetting] setIsFirstVideoUploaded:@"YES"];
        NSString  *videoURL = [NSString stringWithFormat:@"%@%@%@%@",k_AMAZON_S3_SERVER_URL,k_BUCKET_NAME,@"/",fileName];
        [[WSetting getSharedSetting] setFirstOutputUrl:videoURL];
        
        if (isTwiceVideo) {
            if ([[WSetting getSharedSetting] isSecondVideoUploaded].length > 0) {
                
                [[WSetting getSharedSetting] setUploadedCompleted:@"YES"];
                
                [weakSelf videosUploaded];
            }
            
        }
        else {
         
            [weakSelf videosUploaded];

        }
        
        
        
    }];
    
    if ([[WSetting getSharedSetting] secondOutputUrl].length > 0) {
        
        //upload video files
        isTwiceVideo = YES;
        NSLog(@"Second File name %@",[[WSetting getSharedSetting] secondVideoFileName]);
        
        NSString *fileName = [[WSetting getSharedSetting] secondVideoFileName];
        
        NSString *filePath = [[WSetting getSharedSetting] secondOutputUrl];
        
        
        
        [[WZServiceParser sharedParser] processUploadFileAWSWithfilePath:filePath fileName:fileName success:^(NSString *fileName) {
            
            NSLog(@"second file uploaded");
            
            [[WSetting getSharedSetting] setIsSecondVideoUploaded:@"YES"];
            NSString  *videoURL = [NSString stringWithFormat:@"%@%@%@%@",k_AMAZON_S3_SERVER_URL,k_BUCKET_NAME,@"/",fileName];
            [[WSetting getSharedSetting] setSecondOutputUrl:videoURL];
            [[WSetting getSharedSetting] setUploadedCompleted:@"YES"];
            
            
            if ([[WSetting getSharedSetting] isFirstVideoUploaded].length > 0) {
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"videosUploaded"
                 object:self];
            }
            
        }];
        
    }
}

- (void)nextPressed {
    
    self.isNextPressed = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([[WSetting getSharedSetting] uploadedCompleted].length > 0) {
        
        if ([[[WSetting getSharedSetting] postType] isEqualToString:@"AUDIO"]) {
            
            [self postToServer:NO videos:NO audio:YES];
        }
        else if ([[[WSetting getSharedSetting] postType] isEqualToString:@"PHOTO"]) {
                
                [self postToServer:YES videos:NO audio:NO];
            
        }
        else if ([[[WSetting getSharedSetting] postType] isEqualToString:@"VIDEO"]) {
                
                [self postToServer:NO videos:YES audio:NO];
            }
        
    }
    else if ([[[WSetting getSharedSetting] postType] isEqualToString:@"TEXT"]) {
            
            [self postToServer:NO videos:NO audio:NO];
        }
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(postToServer) userInfo:nil repeats:YES];

    
}

- (void)audioUploaded {
    
    self.audioURL = [[WSetting getSharedSetting] audioUrlPath];
    self.audioImageURL = [[WSetting getSharedSetting] audioImageURL];
    
    NSLog(@"Audio File Uploaded");
    if (self.isNextPressed)
    [self postToServer:NO videos:NO audio:YES];
    
}

- (void)videosUploaded {
    
    NSLog(@"Video uploaded");
    self.firstVideoURL = [[WSetting getSharedSetting] firstOutputUrl];
    self.secondVideoURL = [[WSetting getSharedSetting] secondOutputUrl];
    [self postToServer:NO videos:YES audio:NO];
    
}


- (void)imagesUploaded {
    
    self.standardLinkArray = [[WSetting getSharedSetting] imageArray];
    NSLog(@"Images File Uploaded");
    if (self.isNextPressed) {
        [self postToServer:YES videos:NO audio:NO];
    }
}

- (void)postToServer:(BOOL)image videos:(BOOL)video audio:(BOOL)audio {
    
    
//    
    NSString *text = [[WSetting getSharedSetting] postText];
//
//
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
//
    if (image) {
        
        [[WZServiceParser sharedParser] processPostText:text tags:self.tagTextField.text imagesArray:self.standardLinkArray videoURL:nil secondURL:nil audioURL:nil audioImageURL:nil success:^(NSString *successStr) {
            //
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    [CSNotificationView showInViewController:weakSelf style:CSNotificationViewStyleSuccess message:@"Post publish successfully."];
                    [WSetting distroySetting];
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            //
                } failure:^(NSError *error) {
            //
                    [OLGhostAlertView showAlertAtBottomWithTitle:@"Message" message:@"Unable to proceed request"];
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                }];
    }
    
    else if (video) {
        
        _firstVideoURL = [[WSetting getSharedSetting] firstOutputUrl];
        _secondVideoURL = [[WSetting getSharedSetting] secondOutputUrl];
        
            [[WZServiceParser sharedParser] processPostText:text tags:self.tagTextField.text imagesArray:self.standardLinkArray videoURL:_firstVideoURL secondURL:_secondVideoURL audioURL:nil audioImageURL:nil success:^(NSString *successStr) {
                //
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [CSNotificationView showInViewController:weakSelf style:CSNotificationViewStyleSuccess message:@"Post publish successfully."];
                [WSetting distroySetting];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                //
            } failure:^(NSError *error) {
                //
                [OLGhostAlertView showAlertAtBottomWithTitle:@"Message" message:@"Unable to proceed request"];
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            }];
        }
    
    else if (audio) {
        
        _audioURL = [[WSetting getSharedSetting] audioUrlPath];
        _audioImageURL = [[WSetting getSharedSetting] audioImageURL];
        
        [[WZServiceParser sharedParser] processPostText:text tags:self.tagTextField.text imagesArray:self.standardLinkArray videoURL:nil secondURL:nil audioURL:_audioURL audioImageURL:_audioImageURL success:^(NSString *successStr) {
            //
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [CSNotificationView showInViewController:weakSelf style:CSNotificationViewStyleSuccess message:@"Post publish successfully."];
            [WSetting distroySetting];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            //
        } failure:^(NSError *error) {
            //
            [OLGhostAlertView showAlertAtBottomWithTitle:@"Message" message:@"Unable to proceed request"];
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
    }
    else {
        
        
            [[WZServiceParser sharedParser] processPostText:text tags:self.tagTextField.text imagesArray:self.standardLinkArray videoURL:nil secondURL:nil audioURL:nil audioImageURL:nil success:^(NSString *successStr) {
                //
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [CSNotificationView showInViewController:weakSelf style:CSNotificationViewStyleSuccess message:@"Post publish successfully."];
                [WSetting distroySetting];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                //
            } failure:^(NSError *error) {
                //
                [OLGhostAlertView showAlertAtBottomWithTitle:@"Message" message:@"Unable to proceed request"];
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            }];
        }

    

    }

//    if ([WSetting getSharedSetting].imageArray != nil)
//    self.standardLinkArray = [[WSetting getSharedSetting] imageArray];
//    
//    /*
//    IMAGES POST
//     */
//    NSInteger count = [[[WSetting getSharedSetting] uploadedCount] integerValue];
//   
//    if (_standardLinkArray.count > 0 && count < _standardLinkArray.count) {
//        
//        NSLog(@"Not uploaded");
//        
//        return;
//        
//    }
//    
//    
//    /*
//     VIDEO POST
//     */
//    else if ([[WSetting getSharedSetting] firstOutputUrl].length > 0 && [[WSetting getSharedSetting] secondOutputUrl].length > 0) {
//        //Both video recorded and in uploading state
//        
//        if ([[[WSetting getSharedSetting] isFirstVideoUploaded] length] == 0 || [[[WSetting getSharedSetting] isSecondVideoUploaded] length] == 0 ){
//            
//            return;
//        }
//        
//    }
//    
//    else if ([[WSetting getSharedSetting] firstOutputUrl].length > 0 ) {
//        //Both video recorded and in uploading state
//        
//        if (![[[WSetting getSharedSetting] isFirstVideoUploaded] isEqualToString:@"YES"]) {
//            
//            return;
//        }
//        
//    }
//    
//    
//    /*
//     AUDIO POST
//     */
//    else if ([[[WSetting getSharedSetting] audioURL] path].length > 0) {
//        
//        if ([[WSetting getSharedSetting] audioImage] != nil) {
//            
//        }
//    }
//    
//    [_timer invalidate];
//    _timer = nil;
//    
//    NSLog(@"Uploaded");
//    NSString *firstVideoURL = [[WSetting getSharedSetting] firstOutputUrl];
//    
//    
//    NSString *secondVideoURL = [[WSetting getSharedSetting] secondOutputUrl];
//    [[WZServiceParser sharedParser] processPostText:text tags:self.tagTextField.text imagesArray:self.standardLinkArray videoURL:firstVideoURL secondURL:secondVideoURL audioURL:nil audioImageURL:nil success:^(NSString *successStr) {
//        
//        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//        [CSNotificationView showInViewController:weakSelf style:CSNotificationViewStyleSuccess message:@"Post publish successfully."];
//        [WSetting distroySetting];
//        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//
//        
//        
//    } failure:^(NSError *error) {
//        
//        [OLGhostAlertView showAlertAtBottomWithTitle:@"Message" message:@"Unable to proceed request"];
//        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//        
//        
//    }];
//}


#pragma mark - UIKeyboard Delegate Methods

- (void)keyBoardDidShow:(id)sender {
    
    CGRect textRect = self.tagTextField.frame;
    self.tagTextField.frame = CGRectMake(textRect.origin.x, textRect.origin.y - 20, textRect.size.width, textRect.size.height);
}

- (void)keyBoardDidHide:(id)sender {
   
    
    CGRect textRect = self.tagTextField.frame;
    self.tagTextField.frame = CGRectMake(textRect.origin.x, textRect.origin.y + 20, textRect.size.width, textRect.size.height);
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
