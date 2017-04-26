//
//  WPhotoEditViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-01.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPhotoEditViewController.h"

@protocol WPhotoEditViewControllerDelegate;

@interface WPhotoEditViewController : UIViewController<ColorPickerViewDelegate>

@property(nonatomic ,retain) UIImage *selectedImage;

@property(nonatomic ,assign) NSInteger selectedIndex;

@property(nonatomic ,retain) NSString *titleName;

@property(nonatomic ,assign) BOOL isDrawing;

@property(nonatomic) id<WPhotoEditViewControllerDelegate> delegate;

@end

@protocol WPhotoEditViewControllerDelegate <NSObject>

- (void)PhotoEditViewController:(WPhotoEditViewController*)viewController didSaveImage:(UIImage*)image withIndex:(NSInteger)index;

@end
