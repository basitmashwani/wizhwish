//
//  WWizhViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-12.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "WWizhViewController.h"

@interface WWizhViewController ()

@end

@implementation WWizhViewController

#pragma mark - Private Methods
- (void)backPressed:(id)sender {
 
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"WhizWish"];
    
    [RUUtility setBackButtonForController:self withSelector:@selector(backPressed:)];
    
    if (!self.showWhiz) {
        self.buttonGift.alpha = 0.5;
        [self.buttonGift setEnabled:NO];
        
        self.whizList.alpha = 0.5;
        [self.whizList setEnabled:NO];
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(UIImage *image in self.imgArray) {
        
        NSString *fileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".png"];
        
        NSString  *imageURL = [NSString stringWithFormat:@"%@%@%@%@",k_AMAZON_S3_SERVER_URL,k_BUCKET_NAME,@"/",fileName];
        
        [array addObject:imageURL];
        
        NSData * imageData = [UIImage getImageCompressedData:image];//UIImagePNGRepresentation(image);
        
        NSLog(@"image size %u kb",imageData.length/1024);
        
        NSString  *filePath = [RUUtility getFileURLPathforFileName:fileName withData:imageData];
        
        [[WZServiceParser sharedParser] processUploadFileAWSWithfilePath:filePath fileName:fileName success:^(NSString *fileName) {
            
            NSString *count = [[WSetting getSharedSetting] uploadedCount];
           
            NSInteger mCount = [count integerValue]+1;
            NSString *increment = [NSString stringWithFormat:@"%d",mCount];
            [[WSetting getSharedSetting] setUploadedCount:increment];
            
            NSLog(@"file uploaded");
            
        }];
        
        
        
        
    }
    
    [WSetting getSharedSetting].imageArray = array;
    

}


#pragma mark - Public Methods


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    WWishBoardViewController *controller = [segue destinationViewController];

    
    if ([segue.identifier isEqualToString:@"K_SEGUE_WISHBOARD"]) {
        
        controller.currentType = KWWishBoard;
    }
    else if([segue.identifier isEqualToString:@"K_SEGUE_WISHLIST"]) {
     
        controller.currentType = kWWishLists;
    }
}


@end
