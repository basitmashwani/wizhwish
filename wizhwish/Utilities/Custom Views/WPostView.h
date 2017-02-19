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

@property(nonatomic ,retain) IBOutlet UIViewController *parentController;


+ (WPostView *)getPostView;

- (IBAction)textPressed:(id)sender;

- (IBAction)audioPressed:(id)sender;

- (IBAction)videoPressed:(id)sender;

- (IBAction)goOnlinePressed:(id)sender;

- (IBAction)photoPressed:(id)sender;

- (IBAction)chatPressed:(id)sender;


@end
