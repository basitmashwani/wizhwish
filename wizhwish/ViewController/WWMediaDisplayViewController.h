//
//  WWMediaDisplayViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-08-06.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//
typedef enum {
    kWShowImageMode = 0,
    kWShowVideoMode
} WWDisplayMode;

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WWMediaDisplayViewController : UIViewController

@property(nonatomic ,retain) NSMutableArray *imageArray;

@property(nonatomic ,assign) WWDisplayMode displayMode;

@property(nonatomic ,assign) IBOutlet UIButton *pencilButton;

@property(nonatomic ,assign) IBOutlet UIButton *stickerButton;

@property(nonatomic ,assign) IBOutlet UIButton *textButton;

@property(nonatomic ,assign) IBOutlet UIButton *cropButton;

@property(nonatomic ,assign) IBOutlet UIButton *addButton;

@property(nonatomic ,assign) IBOutlet UIButton *crossButton;

@property(nonatomic ,assign) IBOutlet UIButton *saveButton;

@property(nonatomic ,assign) IBOutlet UIButton *nextButton;

@property(nonatomic ,assign) IBOutlet UICollectionView *collectionView;

@property(nonatomic ,retain) NSMutableArray *tempImageArray;

@property(nonatomic ,retain) UIImage *filteredImage;




@property(nonatomic ,assign)  BOOL imageAdded;

@property(nonatomic ,retain)  UIImage *selectedImage;

@property(nonatomic ,assign)  NSInteger selectedIndex;

- (IBAction)pencilPressed:(id)sender;

- (IBAction)stickerPressed:(id)sender;

- (IBAction)textPressed:(id)sender;

- (IBAction)cropPressed:(id)sender;

- (IBAction)addPhotoPressed:(id)sender;

- (IBAction)closePressed:(id)sender;

- (IBAction)savePressed:(id)sender;

@end
