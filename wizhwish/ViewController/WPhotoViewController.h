//
//  WPhotoViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-12-10.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoTweaksViewController.h"

@interface WPhotoViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,ACEDrawingViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WPhotoEditViewControllerDelegate,PhotoTweaksViewControllerDelegate>

@property(nonatomic ,retain) IBOutlet UIView *cameraView;

@property(nonatomic ,retain) IBOutlet UIView *timerView;

@property(nonatomic ,retain) IBOutlet UILabel *labelTime;

@property(nonatomic ,retain) IBOutlet UIButton *recordButton;

@property(nonatomic ,retain) IBOutlet UIView *viewContainer;

@property(nonatomic ,retain) IBOutlet UIButton *pencilButton;

@property(nonatomic ,retain) IBOutlet UIButton *filterPencil;

@property(nonatomic ,retain) IBOutlet UICollectionView *collectionView;

@property(nonatomic ,retain) IBOutlet UIButton *textPencil;

@property(nonatomic ,retain) IBOutlet UIButton *libraryButton;

@property(nonatomic ,retain) IBOutlet UIButton *switchButton;

@property(nonatomic ,retain) IBOutlet UITextField *textField;

@property(nonatomic ,retain) IBOutlet UILabel *textLabel;

@property(nonatomic ,retain) IBOutlet UIButton *buttonFlash;

@property(nonatomic ,retain) IBOutlet UIImageView *mainImageView;

@property(nonatomic ,retain) IBOutlet UIView *stackView;

@property(nonatomic ,retain) IBOutlet UIButton *firstImage;

@property(nonatomic ,retain) IBOutlet UIButton *secondImage;

@property(nonatomic ,retain) IBOutlet UIButton *thirdImage;

@property(nonatomic ,retain) IBOutlet UIButton *fourthImage;

@property(nonatomic ,retain) IBOutlet UIButton *fifthImage;

@property(nonatomic ,retain) IBOutlet UIButton *sixImage;

@property(nonatomic ,retain) IBOutlet UIButton *addButton;

@property(nonatomic ,retain) IBOutlet UIButton *cropButton;




- (IBAction)switchCameraPressed:(id)sender;

- (IBAction)libraryPressed:(id)sender;

- (IBAction)filterPressed:(id)sender;

- (IBAction)pencilPressed:(id)sender;

- (IBAction)textPressed:(id)sender;

- (IBAction)erasePressed:(id)sender;

- (IBAction)capturePressed:(id)sender;

- (IBAction)cropPressed:(id)sender;

- (IBAction)flashPressed:(id)sender;

- (IBAction)firstImagePressed:(id)sender;

- (IBAction)secondImagePressed:(id)sender;

- (IBAction)thirdImagePressed:(id)sender;

- (IBAction)fourthImagePressed:(id)sender;

- (IBAction)fifthImagePressed:(id)sender;

- (IBAction)sixImagePressed:(id)sender;

- (IBAction)addImagePressed:(id)sender;


@end



