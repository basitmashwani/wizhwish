//
//  WZChatListViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-15.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WZChatListViewController.h"

@interface WZChatListViewController ()

@property(nonatomic ,retain) NSArray *followerArray;

@end

@implementation WZChatListViewController

#pragma mark Private Methods



- (void)updateCellContentForInvite:(WZProfileTableViewCell*)cell showChecked:(BOOL)status {
    
   // NSLog(@"status%hhd",status);
    if (status) {
      
    
        
        
    [cell.buttonFollow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    [cell.buttonFollow setTitle:@"Invite" forState:UIControlStateNormal];
        
    UIImage *image = [UIImage imageNamed:@"Image_Follow_Bg"];
        
    [cell.buttonFollow setBackgroundImage:image forState:UIControlStateNormal];
        
      //  [cell.buttonCheckbox setFrame:CGRectMake(-50, frame.origin.y, frame.size.width, frame.size.height)];
        
        cell.buttonCheckbox.alpha = 1;
        
   
    } else {
        
        [cell.buttonFollow setTitleColor:[UIColor getTabBarColor] forState:UIControlStateNormal];
        
        [cell.buttonFollow setTitle:@"Chat" forState:UIControlStateNormal];
        
       // UIImage *image = [UIImage imageNamed:@"Image_Follow_Bg"];
        
        [cell.buttonFollow setBackgroundImage:nil forState:UIControlStateNormal];
        
        cell.buttonCheckbox.alpha = 0;

    }
}


#pragma mark Life Cycle Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    self.followerArray = [[NSArray alloc] init];
    
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (self.viewType == kWTypeContact) {
        
        NSLog(@"Contact");
    }
    
    [self showNavigationBar:YES];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
       [self.tableView reloadData];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Mark TableViewDelegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    WZProfileTableViewCell *profileCell;
    
    if (self.viewType == KWTypeFollower) {
        
        
         profileCell = [tableView dequeueReusableCellWithIdentifier:K_FOLLOWER_CELL];
        
        
          //  [self updateCellContentForInvite:profileCell showChecked:NO];
            
        
        
        return profileCell;
        
       
    }
    
       else {
        
            profileCell = [tableView dequeueReusableCellWithIdentifier:K_FOLLOWER_CELL];
           
           if (indexPath.row ==2) {
               
               profileCell = [tableView dequeueReusableCellWithIdentifier:K_CELL_INVITE];
               

           }
           else if (indexPath.row > 2) {
               
               profileCell = [tableView dequeueReusableCellWithIdentifier:K_FOLLOWER_CELL];
               
               [self updateCellContentForInvite:profileCell showChecked:YES];

           }
           else  {

               [self updateCellContentForInvite:profileCell showChecked:NO];

           }
           
           
           
           return  profileCell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.viewType == KWTypeFollower) {
        
        return 8;

    }
    else {
    
        return 8;
    
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
       
}



#pragma mark Public Methods
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
