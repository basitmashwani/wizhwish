//
//  WTopViewController.h
//  
//
//  Created by Syed Abdul Basit on 2017-06-11.
//
//

#import <UIKit/UIKit.h>

@interface WTopViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic ,retain) IBOutlet UICollectionView *collectionView;

@end
