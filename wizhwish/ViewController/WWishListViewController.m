//
//  WWishListViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-19.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "WWishListViewController.h"

@interface WWishListViewController ()

@property(nonatomic ,retain) NSMutableArray *standardLinkArray;

@property(nonatomic ,retain) NSTimer *timer;

@end

@implementation WWishListViewController

#pragma mark - Life Cycle Methods


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self  = [super initWithCoder:aDecoder];
    
    self.standardLinkArray = [[NSMutableArray alloc] init];
  
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [RUUtility getBarButtonWithImage:[UIImage imageNamed:@"Image_Next"] forViewController:self selector:@selector(nextPressed)];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)nextPressed {
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(postToServer) userInfo:nil repeats:YES];
//    if ([[WSetting getSharedSetting] imageArray] != nil) {
//        
//        // Post Images
//        [self postImagesToServer];
//    }
//    else if ([[WSetting getSharedSetting] postText].length > 0) {
//        
//        // Post Text;
    
       // [self postToServer];
  //
  //  }
    

    
}

- (void)postToServer {
    
    
    NSString *text = [[WSetting getSharedSetting] postText];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    
    
    
    self.standardLinkArray = [[WSetting getSharedSetting] imageArray];
    
    
    NSInteger count = [[[WSetting getSharedSetting] uploadedCount] integerValue];
    if (_standardLinkArray.count > 0 && count < _standardLinkArray.count) {
        
        NSLog(@"Not uploaded");
        
        return;
        
    }
    [_timer invalidate];
    _timer = nil;
    
    NSLog(@"Uploaded");
    
    [[WZServiceParser sharedParser] processPostText:text tags:nil imagesArray:self.standardLinkArray videoArray:nil audioArray:nil  success:^(NSString *accessToken) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [CSNotificationView showInViewController:weakSelf style:CSNotificationViewStyleSuccess message:@"Post publish successfully."];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];

        
        
    } failure:^(NSError *error) {
        
        [OLGhostAlertView showAlertAtBottomWithTitle:@"Message" message:@"Unable to proceed request"];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        
    }];
}

//- (void)postImagesToServer {
//   
//    NSArray *array = [[WSetting getSharedSetting] imageArray];
//    
//    __weak typeof(self) weakSelf = self;
//    for (UIImage *image in array) {
//        
//            [weakSelf uploadPhotos:image];
//
//    }
//    
//    [self.navigationController popToRootViewControllerAnimated:YES];
//
//    
//}

//- (void)uploadPhotos:(UIImage*)image {
//    
//    
//    __weak typeof(self) weakSelf = self;
//    
//    NSInteger imageCount = [[[WSetting getSharedSetting] imageArray] count];
//    
//    NSString *fileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".png"];
//    
//    NSData * imageData = [UIImage getImageCompressedData:image];//UIImagePNGRepresentation(image);
//        
//        NSString  *filePath = [RUUtility getFileURLPathforFileName:fileName withData:imageData];
//        
//        [[WZServiceParser sharedParser] processUploadFileAWSWithfilePath:filePath fileName:fileName success:^(NSString *fileName) {
//            
//            
//            
//            NSString  *imageURL = [NSString stringWithFormat:@"%@%@%@%@",k_AMAZON_S3_SERVER_URL,k_BUCKET_NAME,@"/",fileName];
//            
//            
//            [weakSelf.standardLinkArray addObject:imageURL];
//            
//            if (weakSelf.standardLinkArray.count == imageCount) {
//                
//                [weakSelf postToServer];
//            }
//
//            
//    }];
//
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
