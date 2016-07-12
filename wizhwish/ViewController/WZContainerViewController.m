//
//  WZContainerViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-15.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WZContainerViewController.h"

@interface WZContainerViewController ()

@property(nonatomic ,retain) WZChatListViewController *chatController;

@property(nonatomic ,retain) WZChatViewController *parentController;

@property(nonatomic ,retain) WZNewFriendViewController *friendController;

@end

@implementation WZContainerViewController

#pragma Mark Private Methods

#pragma Mark Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showNavigationBar:YES];
    //[self performSegueWithIdentifier:K_SEGUE_NEW_FRIENDS sender:self];
    
    // Do any additional setup after loading the view.
}

#pragma mark ChatViewController Delegate Methods
- (void)chatViewController:(WZChatViewController *)chatViewController didSelectView:(WChatViewType)chatType {
    
    
    if (chatType == kWChatViewContact) {
        
        self.chatController = [[UIStoryboard getChatStoryBoard] instantiateViewControllerWithIdentifier:K_SB_CHAT_LIST_VC];
        self.chatController.viewType = kWTypeContact;
        
    }
    else if(chatType == kChatViewFollower) {
        
        self.chatController = [[UIStoryboard getChatStoryBoard] instantiateViewControllerWithIdentifier:K_SB_CHAT_LIST_VC];
        self.chatController.viewType = KWTypeFollower;
        
    }
    else if(chatType == KWChatViewFriend) {
        
        self.friendController = [[UIStoryboard getChatStoryBoard] instantiateViewControllerWithIdentifier:K_SB_FRIEND_VIEW_CONTROLLER];
        
    }
    
    if (self.chatController) {
        
        [self swapToViewController:self.chatController completion:nil];
    }
    else if(self.friendController) {
        
        [self swapToViewController:self.friendController completion:nil];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    self.parentController = (WZChatViewController*)parent;
    self.parentController.delegate = self;
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 
 #pragma Mark Public Methods



@end
