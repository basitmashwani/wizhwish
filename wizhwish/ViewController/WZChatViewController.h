//
//  WChatViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-15.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KWChatViewFriend = 0,
    kWChatViewContact,
    kChatViewFollower
    
} WChatViewType;

@protocol ChatViewControllerDelegate;

@interface WZChatViewController : UIViewController


@property(nonatomic ,retain) IBOutlet UIButton *buttonNewFriend;

@property(nonatomic ,retain) IBOutlet UIButton *buttonContacts;

@property(nonatomic ,retain) IBOutlet UIButton *buttonFollowers;

@property(nonatomic ,assign) IBOutlet id<ChatViewControllerDelegate> delegate;


- (IBAction)newFriendPressed:(id)sender;

- (IBAction)contactsPressed:(id)sender;

- (IBAction)FollowersPressed:(id)sender;

- (IBAction)nearbyPressed:(id)sender;

- (IBAction)groupPressed:(id)sender;


@end

@protocol ChatViewControllerDelegate <NSObject>

- (void)chatViewController:(WZChatViewController*)chatViewController didSelectView:(WChatViewType)chatType;


@end