//
//  WWizhViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-12.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//


#define k_PUBLIC_LABEL_TEXT    @"Your Post is public it will be visible to all the selected users followers and to everyone if their account is not private"
#define k_PRIVATE_LABEL_TEXT     @"Your Post is private it will be visible to your selected followers"
#import "WWizhViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface WWizhViewController ()

@property(nonatomic ,retain)   NSMutableArray *array;
@end

@implementation WWizhViewController

#pragma mark - Private Methods
- (void)backPressed:(id)sender {
 
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Life Cycle Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
   self = [super initWithCoder:aDecoder];
    self.array = [[NSMutableArray alloc] init];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"WhizWish"];
    self.whizWishButton.backgroundColor = [UIColor whiteColor];
    
    [RUUtility setBackButtonForController:self withSelector:@selector(backPressed:)];
    
    
        self.privateSwitch.hidden = YES;
    
        self.privateLabel.hidden = YES;
    
        self.privateImage.hidden = YES;
    
       self.websiteTextField.hidden = YES;
    
    UITextField *txfSearchField = [self.searchBar valueForKey:@"_searchField"];
    txfSearchField.borderStyle = UITextBorderStyleRoundedRect;

    

    
    for (UIView *subview in [[self.searchBar.subviews lastObject] subviews]) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview setAlpha:0.0];
            break;
        }
        


    }
   // self.textView.layer.borderWidth = 2.0f;
   // self.textView.layer.borderColor = [[UIColor navigationBarColor] CGColor];
   // self.textView.layer.cornerRadius = 2;
    
    

  //  [self.tagUsersTextField setLeftViewMode:UITextFieldViewModeAlways];
   // self.tagUsersTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Image_Whiz_UserTag"]];
   // CGRect tagUsersFrame = self.tagUsersTextField.leftView.frame;
  //  self.tagUsersTextField.leftView.frame = CGRectMake(20, tagUsersFrame.origin.y, tagUsersFrame.size.width, tagUsersFrame.size.height);
    self.collectionViewContainer.hidden = YES;

    
    UIImage *tagUserImage = [UIImage imageNamed:@"Image_Whiz_UserTag"];
    [self.tagUsersTextField setLeftImageView:tagUserImage];
    
    UIImage *locationImage = [UIImage imageNamed:@"Image_Whiz_Location"];
    [self.locationTextField setLeftImageView:locationImage];
    
    UIImage *hashTagImage = [UIImage imageNamed:@"Image_Whiz_HashTag"];
    [self.hashTagTextField setLeftImageView:hashTagImage];
    
    UIImage *websiteImage = [UIImage imageNamed:@"Image_Whiz_Website"];
    [self.websiteTextField setLeftImageView:websiteImage];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

/*
 
 //IF IMAGES IS SELECTED THEN UPLOAD IMAGES
 
 
 */
    if (self.imgArray.count > 0) {
   
        [self uploadImages];
    }
    
    /*
     
     //IF VIDEOS IS SELECTED THEN UPLOAD VIDEOS
     
     
     */
    
    else if ([[WSetting getSharedSetting] firstOutputUrl].length > 0) {
        
     //   [self uploadVideos];
   

    }
    
    
    /*
     
     //IF IMAGES IS SELECTED THEN UPLOAD IMAGES
     
     
     */
    else if ([[WSetting getSharedSetting] audioURL].path.length > 0) {
        
        [self uploadAudio];
    }
    
    });

}

#pragma mark - Private Methods




- (void)uploadImages {
    
   __block NSInteger count = 0;
    for(UIImage *image in self.imgArray) {
        
        
        NSString *fileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".png"];
        
        NSString  *imageURL = [NSString stringWithFormat:@"%@%@%@%@",k_AMAZON_S3_SERVER_URL,k_BUCKET_NAME,@"/",fileName];
        
        [self.array addObject:imageURL];
        
        NSData * imageData = [UIImage getImageCompressedData:image];//UIImagePNGRepresentation(image);
        
        //   NSLog(@"image size %lu kb",imageData.length/1024);
        
        NSString  *filePath = [RUUtility getFileURLPathforFileName:fileName directoryName:@"WhizWish" withData:imageData];
        
        // [RUUtility getFileURLPathforFileName:fileName withData:imageData];
        
        [[WZServiceParser sharedParser] processUploadFileAWSWithfilePath:filePath fileName:fileName success:^(NSString *fileName) {
            
            count = count+1;
//            NSString *count = [[WSetting getSharedSetting] uploadedCount];
//            
//            NSInteger mCount = [count integerValue]+1;
//            NSString *increment = [NSString stringWithFormat:@"%ld",(long)mCount];
//            [[WSetting getSharedSetting] setUploadedCount:increment];
            
            if (self.imgArray.count == count) {
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"imagesUploaded"
                 object:self];
            }
            NSLog(@"Image file uploaded");
            
            
        }];
        
    }
    
    [WSetting getSharedSetting].imageArray = self.array;
}


- (void)uploadVideos {
    
    BOOL isTwiceVideo = NO;
    
    
    //upload video files
    NSLog(@"First File name %@",[[WSetting getSharedSetting] firstVideoFileName]);
    
    NSString *fileName = [[WSetting getSharedSetting] firstVideoFileName];
    
    NSString *filePath = [[WSetting getSharedSetting] firstOutputUrl];
    
    //   NSURL *url = [NSURL fileURLWithPath:filePath];
    
    //  NSData *newDataForUpload = [NSData dataWithContentsOfURL:url];
    //NSLog(@"Size of new Video after compression is (bytes):%lu",[newDataForUpload length]/1024);
    
    
    [[WZServiceParser sharedParser] processUploadFileAWSWithfilePath:filePath fileName:fileName success:^(NSString *fileName) {
        
        NSLog(@"first file uploaded");
        [[WSetting getSharedSetting] setIsFirstVideoUploaded:@"YES"];
        NSString  *videoURL = [NSString stringWithFormat:@"%@%@%@%@",k_AMAZON_S3_SERVER_URL,k_BUCKET_NAME,@"/",fileName];
        [[WSetting getSharedSetting] setFirstOutputUrl:videoURL];
        
        if (isTwiceVideo) {
        if ([[WSetting getSharedSetting] isSecondVideoUploaded].length > 0) {
            
            [[WSetting getSharedSetting] setUploadedCompleted:@"YES"];

            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"videosUploaded"
             object:self];
        }
        
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

- (void)uploadAudio {
    
    NSString *fileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".m4a"];
    
    NSString  *audioURLPath = [NSString stringWithFormat:@"%@%@%@%@",k_AMAZON_S3_SERVER_URL,k_BUCKET_NAME,@"/",fileName];
    
    
    NSURL *audioURL = [[WSetting getSharedSetting] audioURL];
    NSData * imageData = [NSData dataWithContentsOfURL:audioURL];
    
    //   NSLog(@"image size %lu kb",imageData.length/1024);
    
    NSString  *filePath = [RUUtility getFileURLPathforFileName:fileName directoryName:@"WhizWish" withData:imageData];
    
    // [RUUtility getFileURLPathforFileName:fileName withData:imageData];
    
    [[WZServiceParser sharedParser] processUploadFileAWSWithfilePath:filePath fileName:fileName success:^(NSString *fileName) {
        
        [[WSetting getSharedSetting] setAudioUrlPath:audioURLPath];
        
        
        [[WSetting getSharedSetting] setIsAudioImageUploaded:@"YES"];
        
        
        if ([[WSetting getSharedSetting] audioImage] != nil) {
            
            NSString *fileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".png"];
            
            NSString  *imageURL = [NSString stringWithFormat:@"%@%@%@%@",k_AMAZON_S3_SERVER_URL,k_BUCKET_NAME,@"/",fileName];
            
            
            UIImage *audioImage = [[WSetting getSharedSetting] audioImage];
            
            NSData * imageData = [UIImage getImageCompressedData:audioImage];//UIImagePNGRepresentation(image);
            
            //   NSLog(@"image size %lu kb",imageData.length/1024);
            
            NSString  *filePath = [RUUtility getFileURLPathforFileName:fileName directoryName:@"WhizWish" withData:imageData];
            
            // [RUUtility getFileURLPathforFileName:fileName withData:imageData];
            
            [[WZServiceParser sharedParser] processUploadFileAWSWithfilePath:filePath fileName:fileName success:^(NSString *fileName) {
                
                
               // [[WSetting getSharedSetting] setIsAudioFileUploaded:@"YES"];
                NSLog(@"audio image file uploaded");
                
                [[WSetting getSharedSetting] setAudioImageURL:imageURL];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"audioUploaded"
                 object:self];
                
                [[WSetting getSharedSetting] setUploadedCompleted:@"YES"];
                
                
                
            }];
        }
        else {
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"audioUploaded"
             object:self];
            [[WSetting getSharedSetting] setUploadedCompleted:@"YES"];
        }

        
        
    }];
    
    

}
#pragma mark - Public Methods

- (IBAction)whizWishPressed:(id)sender {
    
    self.whizWishButton.backgroundColor = [UIColor whiteColor];
    
    self.whizBoardButton.backgroundColor = [UIColor getLightGrayColor];
    
    self.whizListButton.backgroundColor = [UIColor getLightGrayColor];
    
    self.buttonGift.backgroundColor = [UIColor getLightGrayColor];
    
    self.privateSwitch.hidden = YES;

    self.privateLabel.hidden = YES;
    
    self.privateImage.hidden = YES;
    
    self.collectionViewContainer.hidden = YES;
    
    self.websiteTextField.hidden = YES;
    
    self.titleLabel.text = @"share your moment";
    
    
    self.giftView.hidden = YES;


    
}

- (IBAction)giftPressed:(id)sender {
 
    self.whizWishButton.backgroundColor = [UIColor getLightGrayColor];
    
    self.whizBoardButton.backgroundColor = [UIColor getLightGrayColor];
    
    self.whizListButton.backgroundColor = [UIColor getLightGrayColor];
    
    self.buttonGift.backgroundColor = [UIColor whiteColor];
    
    self.websiteTextField.hidden = NO;

    self.titleLabel.text = @"share your gift";
    
    
    self.giftView.hidden = NO;
    self.privateLabel.hidden = YES;
    self.privateSwitch.hidden = YES;
    
    if (self.privateSwitch.on) {
       // self.searchViewConstraint.constant = -15;

    }
    else {
    
        self.searchViewConstraint.constant = -15;
    }
    self.collectionViewContainer.hidden = NO;

    
}

- (IBAction)whizBoardPressed:(id)sender {
    
    self.whizWishButton.backgroundColor = [UIColor getLightGrayColor];
    
    self.whizBoardButton.backgroundColor = [UIColor whiteColor];
    
    self.whizListButton.backgroundColor = [UIColor getLightGrayColor];
    
    self.buttonGift.backgroundColor = [UIColor getLightGrayColor];
    
    
    self.privateSwitch.hidden = NO;
    
    self.privateLabel.hidden = NO;
    
    self.privateImage.hidden = NO;
    
    self.collectionViewContainer.hidden = NO;
    
    self.websiteTextField.hidden = NO;
    
    
    self.giftView.hidden = YES;
    
    self.searchViewConstraint.constant = 10;


    
    
    self.titleLabel.text = @"post on your followers wishboard";

}

- (IBAction)whizListPressed:(id)sender {
 
    self.whizWishButton.backgroundColor = [UIColor getLightGrayColor];
    
    self.whizBoardButton.backgroundColor = [UIColor getLightGrayColor];
    
    self.whizListButton.backgroundColor = [UIColor whiteColor];
    
    self.buttonGift.backgroundColor = [UIColor getLightGrayColor];
    
    self.websiteTextField.hidden = NO;

    self.collectionViewContainer.hidden = NO;
    

    self.privateSwitch.hidden = NO;
    
    self.privateLabel.hidden = NO;
    
    self.privateImage.hidden = NO;

    self.titleLabel.text = @"Add to your wishlist";
    
    self.giftView.hidden = YES;
  
    self.searchViewConstraint.constant = 10;


}

- (IBAction)privateSwitchChanged:(id)sender {
    
    if ([sender isOn]) {
        
        self.privateLabel.text = k_PRIVATE_LABEL_TEXT;

    }
    else {
      
        self.privateLabel.text = k_PUBLIC_LABEL_TEXT;
    }
}
- (void)publicButtonPressed:(id)sender {
    
    self.publicImage.hidden = NO;
    self.giftImage.hidden = YES;
    self.thankYouImage.hidden = YES;
    self.publicIcon.image = [UIImage imageNamed:@"Image_Whiz_Public_Selected"];
    self.giftIcon.image = [UIImage imageNamed:@"Image_Whiz_Gift"];
    self.thankYouIcon.image = [UIImage imageNamed:@"Image_Whiz_ThankYou"];
    
    [self.publicButton setTitleColor:[UIColor navigationBarColor] forState:UIControlStateNormal];
    [self.ThankYouButton setTitleColor:[UIColor getDarkGrayColor] forState:UIControlStateNormal];
    [self.buttonGift setTitleColor:[UIColor getDarkGrayColor] forState:UIControlStateNormal];

}

- (void)giftButtonPressed:(id)sender {
    
    
    self.publicImage.hidden = YES;
    self.giftImage.hidden = NO;
    self.thankYouImage.hidden = YES;
    self.giftIcon.image = [UIImage imageNamed:@"Image_Whiz_Gift_Selected"];
    self.thankYouIcon.image = [UIImage imageNamed:@"Image_Whiz_ThankYou"];
    self.publicIcon.image = [UIImage imageNamed:@"Image_Whiz_Public"];
    
    [self.giftButton setTitleColor:[UIColor navigationBarColor] forState:UIControlStateNormal];
    [self.publicButton setTitleColor:[UIColor getDarkGrayColor] forState:UIControlStateNormal];

    [self.ThankYouButton setTitleColor:[UIColor getDarkGrayColor] forState:UIControlStateNormal];

}

- (void)thankYouButtonPressed:(id)sender {
    
    
    self.publicImage.hidden = YES;
    self.giftImage.hidden = YES;
    self.thankYouImage.hidden = NO;

    self.thankYouIcon.image = [UIImage imageNamed:@"Image_Whiz_ThankYou_Selected"];
    self.giftIcon.image = [UIImage imageNamed:@"Image_Whiz_Gift"];
    self.publicIcon.image = [UIImage imageNamed:@"Image_Whiz_Public"];

   
    
    
    [self.ThankYouButton setTitleColor:[UIColor navigationBarColor] forState:UIControlStateNormal];
    [self.giftButton setTitleColor:[UIColor getDarkGrayColor] forState:UIControlStateNormal];
    [self.publicButton setTitleColor:[UIColor getDarkGrayColor] forState:UIControlStateNormal];

}

#pragma mark UICollectionView Delegate Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WZFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_PEOPLE_COLLECTION_CELL forIndexPath:indexPath];
    [cell.buttonPeople setUserInteractionEnabled:NO];
       return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(collectionView.frame.size.width/4.5 , collectionView.frame.size.height);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    WZFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_PEOPLE_COLLECTION_CELL forIndexPath:indexPath];

    
    if(cell.checked.hidden)
        cell.checked.hidden = NO;
    else
        cell.checked.hidden = YES;
    
    [cell setSelected:YES];
}


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
