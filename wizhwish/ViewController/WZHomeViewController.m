//
//  WHomeViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-20.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WZHomeViewController.h"

@implementation WZHomeViewController

#pragma mark Private Methods

- (void)settingPressed {
    
}

- (void)alertPressed {
    
    WZFollowerViewController *controller = [[UIStoryboard getProfileStoryBoard] instantiateViewControllerWithIdentifier:K_SB_FOLLOWER_VIEW_CONROLLER];
    
    controller.profileType = kWProfileAlerts;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)giftPressed {
    
    WZFollowerViewController *controller = [[UIStoryboard getProfileStoryBoard] instantiateViewControllerWithIdentifier:K_SB_FOLLOWER_VIEW_CONROLLER];
    
    controller.profileType = kWProfileGifts;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)inMailPressed {
 
    WZChatViewController *chatController = [[UIStoryboard getChatStoryBoard] instantiateViewControllerWithIdentifier:K_SB_CHAT_VIEW_CONTROLLER];
    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma Life Cycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationItem setHidesBackButton:YES];
    
    [self.navigationItem setTitle:@"Whizwish"];
    
   self.navigationItem.rightBarButtonItem =  [RUUtility getBarButtonWithImage:[UIImage imageNamed:@"Image_Setting"] forViewController:self selector:@selector(settingPressed)];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
   if ([segue.destinationViewController isKindOfClass:[WZMyProfileViewController class]]) {
       
       WZMyProfileViewController *profileController = (WZMyProfileViewController*)segue.destinationViewController;
    
       profileController.profileType = KWPofileTypeSelf;
    //    KWPofileTypeSelf = 0,
      //  kWProfileTypeOther
    }
    
}

#pragma mark UITableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        WZPostTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:K_POST_TOP_CELL];
        
        [self.buttonTopScroll setHidden:YES];
        
        [cell.buttonInMail addTarget:self action:@selector(inMailPressed) forControlEvents:UIControlEventTouchUpInside];

        [cell.buttonGift addTarget:self action:@selector(giftPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.buttonNotification addTarget:self action:@selector(alertPressed) forControlEvents:UIControlEventTouchUpInside];


       
        return cell;
    }
    else  {
   
        WZPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:K_POST_TABLEVIEW_CELL];
        
    if (cell) {
        
        if (indexPath.row >1) {
            
        
        [self.buttonTopScroll setHidden:NO];
        
        }
    }
        return cell;
    }
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return 250;
    }
    else  {
        
        return  370;
    }
}


#pragma mark Public Methods

- (void)scrollTopPressed:(id)sender {
  
    [self.tableView setContentOffset:CGPointZero animated:YES];

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
