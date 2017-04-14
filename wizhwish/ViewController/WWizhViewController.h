//
//  WWizhViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-12.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWizhViewController : UIViewController

@property(nonatomic ,retain) IBOutlet UIButton *buttonGift;

@property(nonatomic ,retain) IBOutlet UIButton *whizList;

@property(nonatomic ,retain) NSMutableArray *imgArray;

@property(nonatomic ,assign) BOOL showWhiz;

//- (IBAction)whizWishPressed:(id)sender;
//
//- (IBAction)giftPressed:(id)sender;
//
//- (IBAction)whizBoardPressed:(id)sender;
//
//- (IBAction)whizListPressed:(id)sender;
@end
