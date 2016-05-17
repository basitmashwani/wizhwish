//
//  WZChatListViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-15.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WZChatListViewController.h"

@interface WZChatListViewController ()

@end

@implementation WZChatListViewController

#pragma mark Private Methods

#pragma mark Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Mark TableViewDelegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WZProfileTableViewCell *profileCell = [tableView dequeueReusableCellWithIdentifier:K_FOLLOWER_CELL];
    
    return profileCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
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
