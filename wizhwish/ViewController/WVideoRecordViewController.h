//
//  WVideoRecordViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-09-11.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PBJVision/PBJVision.h>
#import "SCustomProgressView.h"

@interface WVideoRecordViewController : UIViewController

@property(nonatomic ,retain) IBOutlet UIView *cameraView;

@property(nonatomic ,retain) IBOutlet UIView *timerView;

@property(nonatomic ,retain) IBOutlet UILabel *labelTime;

@property(nonatomic ,retain) IBOutlet UIButton *buttonAddVideo;

@property(nonatomic ,retain) IBOutlet UIButton *recordButton;

@property(nonatomic ,retain) IBOutlet UIView *viewContainer;

@property(nonatomic ,retain) IBOutlet UISlider *sliderSmallScreen;

@property(nonatomic ,retain) IBOutlet UISlider *sliderLargeScreen;

@property(nonatomic ,retain) IBOutlet UIButton *soundButton;

@property(nonatomic ,retain) IBOutlet UIButton *pencilButton;

@property(nonatomic ,retain) IBOutlet UIButton *filterPencil;

@property(nonatomic ,retain) IBOutlet UICollectionView *collectionView;

@property(nonatomic ,retain) IBOutlet UIButton *textPencil;

@property(nonatomic ,retain) IBOutlet UIButton *libraryButton;

@property(nonatomic ,retain) IBOutlet UIButton *switchButton;

@property(nonatomic ,retain) IBOutlet UILabel *labelSmall;

@property(nonatomic ,retain) IBOutlet UILabel *labelLarge;

@property(nonatomic ,retain) IBOutlet UITextView *textField;


@property(nonatomic ,retain) IBOutlet UILabel *textLabel;

@property(nonatomic ,retain) IBOutlet UIButton *buttonTemporary;

@property(nonatomic ,retain) IBOutlet NSLayoutConstraint *cameraConstraint;

@property(nonatomic ,retain)  IBOutlet SCustomProgressView *progressView;




- (IBAction)switchCameraPressed:(id)sender;

- (IBAction)libraryPressed:(id)sender;

- (IBAction)addSecondVideoPressed:(id)sender;

- (IBAction)soundPressed:(id)sender;

- (IBAction)filterPressed:(id)sender;

- (IBAction)pencilPressed:(id)sender;

- (IBAction)textPressed:(id)sender;

- (IBAction)erasePressed:(id)sender;

- (IBAction)tempButtonPressed:(id)sender;


@end

