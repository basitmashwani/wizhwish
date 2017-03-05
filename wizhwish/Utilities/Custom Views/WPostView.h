//
//  WPostView.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-07-23.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPostView : UIView


@property(nonatomic ,retain) IBOutlet UIButton *buttonText;

@property(nonatomic ,retain) IBOutlet UIButton *buttonGoOnline;

@property(nonatomic ,retain) IBOutlet UIButton *buttonVideo;

@property(nonatomic ,retain) IBOutlet UIButton *buttonPhoto;

@property(nonatomic ,retain) IBOutlet UIButton *buttonAudio;

@property(nonatomic ,retain) IBOutlet UIButton *buttonChat;

@property(nonatomic ,retain) IBOutlet UIButton *buttonHidden;

@property(nonatomic ,retain) IBOutlet UIButton *buttonMessage;

@property(nonatomic ,retain) IBOutlet UIButton *buttonNotification;

@property(nonatomic ,retain) IBOutlet UIButton *buttonMenu;

@property(nonatomic ,retain) IBOutlet UIButton *buttonGift;

@property(nonatomic ,retain) IBOutlet UIButton *buttonWhatOn;

@property(nonatomic ,retain) UIViewController *parentViewController;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerButtonWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerButtonHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightButtonWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightButtonHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftButtonWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftButtonHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerbuttonyAxis;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftButtonyAxis;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightButtonyAxis;










+ (WPostView *)getPostView;

- (IBAction)textPressed:(id)sender;

- (IBAction)audioPressed:(id)sender;

- (IBAction)videoPressed:(id)sender;

- (IBAction)goOnlinePressed:(id)sender;

- (IBAction)photoPressed:(id)sender;

- (IBAction)chatPressed:(id)sender;

- (IBAction)livePressed:(id)sender;

- (IBAction)giftPressed:(id)sender;

- (IBAction)notificationPressed:(id)sender;

- (IBAction)messagePressed:(id)sender;


@end
