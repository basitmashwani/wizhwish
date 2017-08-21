//
//  WWStickerViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-08-18.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WWStickerViewControllerDelegate;
@interface WWStickerViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic ,retain) IBOutlet UICollectionView *collectionView;

@property(nonatomic ,assign) id<WWStickerViewControllerDelegate> delegate;
@end

@protocol WWStickerViewControllerDelegate <NSObject>

- (void)StickerViewController:(WWStickerViewController*)controller didStickerSelected:(UIImage*)stickerImage;

@end
