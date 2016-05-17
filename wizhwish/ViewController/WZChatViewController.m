//
//  WChatViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-15.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WZChatViewController.h"

@interface WZChatViewController ()

@end

@implementation WZChatViewController

#pragma mark Private Methods

#pragma mark Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonNewFriend.selected = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Public Methods

- (void)newFriendPressed:(id)sender {
    
    self.buttonNewFriend.selected = YES;
    self.buttonContacts.selected = NO;
    self.buttonFollowers.selected = NO;
  
    
    if ([self.delegate respondsToSelector:@selector(chatViewController:didSelectView:)])
    {
        [self.delegate chatViewController:self didSelectView:KWChatViewFriend];
    }
}

- (void)contactsPressed:(id)sender {
    
    self.buttonNewFriend.selected = NO;
    self.buttonContacts.selected = YES;
    self.buttonFollowers.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(chatViewController:didSelectView:)])
    {
        [self.delegate chatViewController:self didSelectView:kWChatViewContact];
    }
}

- (void)FollowersPressed:(id)sender {
    
    
    self.buttonNewFriend.selected = NO;
    self.buttonContacts.selected = NO;
    self.buttonFollowers.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(chatViewController:didSelectView:)])
    {
        [self.delegate chatViewController:self didSelectView:kChatViewFollower];
    }
    
}

- (void)nearbyPressed:(id)sender {
    
}

- (void)groupPressed:(id)sender {
    
    WZFollowerViewController *groupController = [[UIStoryboard getProfileStoryBoard] instantiateViewControllerWithIdentifier:K_SB_FOLLOWER_VIEW_CONROLLER];
   
    groupController.profileType = kWProfileGroup;
    
    [self.navigationController pushViewController:groupController animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
