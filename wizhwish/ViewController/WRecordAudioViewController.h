//
//  WRecordAudioViewControlleer.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-09.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRecordAudioViewController : UIViewController

@property(nonatomic ,retain) IBOutlet UILabel *labelTime;

@property(nonatomic ,retain) IBOutlet UIButton *buttonRecord;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@property(nonatomic ,retain) IBOutlet UIButton *buttonImport;

@property(nonatomic ,retain) IBOutlet UILabel *labelImport;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property(nonatomic ,retain) UIButton *buttonPencil;

@property(nonatomic ,assign) UIButton *buttonText;

- (IBAction)importPressed:(id)sender;

- (IBAction)pencilPressed:(id)sender;

- (IBAction)textPressed:(id)sender;



@end
